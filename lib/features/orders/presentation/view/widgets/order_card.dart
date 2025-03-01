import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';

import 'package:beautilly/core/utils/theme/app_theme.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/orders/domain/entities/order.dart';
import 'package:beautilly/features/orders/presentation/view/order_details_view.dart';
import 'package:beautilly/features/reservations/presentation/view/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beautilly/features/orders/domain/repositories/orders_repository.dart';
import 'package:beautilly/core/utils/common/custom_dialog_button.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class OrderCard extends StatefulWidget {
  final OrderEntity order;
  final bool isMyRequest;
  final Function(int)? onDelete;

  const OrderCard({
    super.key,
    required this.order,
    required this.isMyRequest,
    this.onDelete,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getOrderCardDimensions(context);
    final colors = Theme.of(context).extension<CustomColors>()!;

    return GestureDetector(
      onTap: _isLoading ? null : () async {
        try {
          setState(() => _isLoading = true);
          final result = await sl<OrdersRepository>()
              .getOrderDetails(widget.order.id);
          if (!mounted) return;

          result.fold(
            (failure) {
              CustomSnackbar.showError(
                context: context,
                message: failure.message,
              );
            },
            (orderDetails) async {
              final shouldRefresh = await Navigator.push<bool>(
                context,
                PageRoutes.fadeScale(
                  page: OrderDetailsView(
                    orderDetails: orderDetails,
                    isMyOrder: widget.isMyRequest,
                    fromAllOrders: !widget.isMyRequest,
                  ),
                ),
              );

              if (shouldRefresh == true && mounted) {
                if (widget.isMyRequest) {
                  context.read<OrdersCubit>().loadMyOrders();
                } else {
                  context.read<OrdersCubit>().loadAllOrders();
                }
              }
            },
          );
        } catch (e) {
          if (!mounted) return;
          CustomSnackbar.showError(
            context: context,
            message: 'حدث خطأ في تحميل تفاصيل الطلب',
          );
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      },
      child: Stack(
        children: [
          MouseRegion(
            cursor: _isLoading ? SystemMouseCursors.wait : SystemMouseCursors.click,
            child: Opacity(
              opacity: _isLoading ? 0.7 : 1.0,
              child: Container(
                width: dimensions.width,
                height: dimensions.height,
                decoration: BoxDecoration(
                  color: colors.cardContentBg,
                  borderRadius: BorderRadius.circular(dimensions.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: dimensions.borderRadius,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header with Image (الجزء العلوي مع الصورة)
                    Expanded(
                      flex: widget.isMyRequest ? 2 : 1,
                      child: _buildHeader(dimensions),
                    ),
                    
                    // Details Section (تفاصيل الطلب)
                    Expanded(
                      flex: widget.isMyRequest ? 3 : 1, // زيادة مساحة التفاصيل في طلبات المستخدمين
                      child: Padding(
                        padding: EdgeInsets.all(dimensions.padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMeasurements(dimensions),
                            const SizedBox(height: 8),
                            _buildFabrics(dimensions),
                            if (widget.isMyRequest) ...[
                              const Spacer(),
                              _buildDeleteButton(dimensions),
                            ] else 
                              const Spacer(), // لملء المساحة في طلبات المستخدمين
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CustomProgressIndcator(
                  color: AppColors.primary,
                  size: 38,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(OrderCardDimensions dimensions) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(dimensions.borderRadius),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.order.images.main,
            fit: BoxFit.cover,
            placeholder: (context, url) => const ShimmerEffect(
              height: double.infinity,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.design_services_outlined,
                size: dimensions.iconSize * 2,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(dimensions.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(dimensions),
                  const SizedBox(width: 4),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  CircleAvatar(
                    radius: dimensions.avatarSize / 2,
                    backgroundColor: Colors.white,
                    child: _buildCustomerAvatar(dimensions),
                  ),
                  SizedBox(width: dimensions.spacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.order.customer.name,
                              style: getBoldStyle(
                                color: Colors.white,
                                fontSize: dimensions.titleSize,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                            const Spacer(),
                            _buildDateChip(dimensions),
                          ],
                        ),
                        Text(
                          'طلب #${widget.order.id}',
                          style: getMediumStyle(
                            color: Colors.white70,
                            fontSize: dimensions.subtitleSize,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(OrderCardDimensions dimensions) {
    Color statusColor;
    IconData statusIcon;

    switch (widget.order.status) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'in_progress':
        statusColor = Colors.blue;
        statusIcon = Icons.pending;
        break;
      case 'uncompleted':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 2),
          Text(
            widget.order.statusLabel,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              color: statusColor,
              fontSize: FontSize.size12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(OrderCardDimensions dimensions) {
    final difference = DateTime.now().difference(widget.order.createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return Text(
          'منذ ${difference.inMinutes} دقيقة',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: Colors.white70,
          ),
        );
      }
      return Text(
        'منذ ${difference.inHours} ساعة',
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size12,
          color: Colors.white70,
        ),
      );
    } else if (difference.inDays < 7) {
      return Text(
        'منذ ${difference.inDays} يوم',
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size12,
          color: Colors.white70,
        ),
      );
    } else {
      return Text(
        '${widget.order.createdAt.day}/${widget.order.createdAt.month}/${widget.order.createdAt.year.toString().substring(2)}',
        style: getMediumStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size12,
          color: Colors.white70,
        ),
      );
    }
  }

  Widget _buildCustomerAvatar(OrderCardDimensions dimensions) {
    if (widget.order.customer.avatar != null) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: "https://dallik.com/storage/${widget.order.customer.avatar}",
          width: dimensions.avatarSize,
          height: dimensions.avatarSize,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
          errorWidget: (context, url, error) => _buildAvatarText(dimensions),
        ),
      );
    } else {
      return _buildAvatarText(dimensions);
    }
  }

  Widget _buildAvatarText(OrderCardDimensions dimensions) {
    return Text(
      widget.order.customer.name[0].toUpperCase(),
      style: getBoldStyle(
        fontFamily: FontConstant.cairo,
        color: AppColors.primary,
        fontSize: FontSize.size16,
      ),
    );
  }

  Widget _buildMeasurements(OrderCardDimensions dimensions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.order.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getMediumStyle(
            fontSize: dimensions.subtitleSize,
            fontFamily: FontConstant.cairo,
          ),
        ),
        SizedBox(height: dimensions.spacing),
        Wrap(
          spacing: dimensions.spacing,
          runSpacing: dimensions.spacing / 2,
          children: [
            _buildMeasurementChip(
              Icons.height,
              '${widget.order.height} سم',
              dimensions,
            ),
            _buildMeasurementChip(
              Icons.monitor_weight_outlined,
              '${widget.order.weight} كجم',
              dimensions,
            ),
            _buildMeasurementChip(
              Icons.straighten,
              widget.order.size,
              dimensions,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFabrics(OrderCardDimensions dimensions) {
    return Wrap(
      spacing: dimensions.spacing,
      runSpacing: dimensions.spacing / 2,
      children: widget.order.fabrics.map((fabric) => _buildFabricChip(fabric, dimensions)).toList(),
    );
  }

  Widget _buildMeasurementChip(
      IconData icon, String label, OrderCardDimensions dimensions) {
    return _buildInfoChip(
        icon, label, dimensions.chipHeight, dimensions.chipHeight);
  }

  Widget _buildFabricChip(Fabric fabric, OrderCardDimensions dimensions) {
    return _buildInfoChip(
      Icons.format_paint_outlined,
      fabric.type,
      dimensions.chipHeight,
      dimensions.chipHeight,
      textColor: _getColorFromHex(fabric.color),
    );
  }

  Widget _buildInfoChip(
      IconData icon, String label, double height, double width,
      {Color? textColor}
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: textColor?.withOpacity(0.3) ?? AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor ?? AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF' + hexColor;
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  Widget _buildDeleteButton(OrderCardDimensions dimensions) {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'تأكيد الحذف',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size18,
                ),
              ),
              content: Text(
                'هل أنت متأكد من حذف هذا الطلب؟',
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomDialogButton(
                          text: 'إلغاء',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomDialogButton(
                          text: 'حذف',
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onDelete?.call(widget.order.id);
                          },
                          isDestructive: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        icon: SvgPicture.asset(
          'assets/icons/trash.svg',
          color: AppColors.error,
          width: 18,
          height: 18,
        ),
        label: Text(
          'حذف الطلب',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            color: AppColors.error,
            fontSize: FontSize.size12,
          ),
        ),
        style: TextButton.styleFrom(
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
