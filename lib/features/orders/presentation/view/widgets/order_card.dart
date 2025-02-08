import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/orders/domain/entities/order.dart';
import 'package:beautilly/features/orders/presentation/view/order_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beautilly/features/orders/domain/repositories/orders_repository.dart';
import 'package:beautilly/core/utils/common/custom_dialog_button.dart';

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
    return Stack(
      children: [
        GestureDetector(
          onTap: _isLoading
              ? null
              : () async {
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
                      (orderDetails) {
                        Navigator.push(
                          context,
                          PageRoutes.fadeScale(
                            page: OrderDetailsView(
                              order: orderDetails,
                              isMyOrder: widget.isMyRequest,
                            ),
                          ),
                        );
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
          child: MouseRegion(
            cursor:
                _isLoading ? SystemMouseCursors.wait : SystemMouseCursors.click,
            child: Opacity(
              opacity: _isLoading ? 0.7 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).cardColor,
                      Theme.of(context).cardColor.withOpacity(0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header & Image Section
                    Stack(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: widget.order.images.medium,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 160,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 160,
                              color: Colors.grey[100],
                              child: const Icon(Icons.error_outline,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        // Gradient Overlay
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        // Status Badge
                        Positioned(
                          top: 12,
                          right: 12,
                          child: _buildStatusBadge(),
                        ),
                        // User Info
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Text(
                                  widget.order.customer.name[0].toUpperCase(),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    color: AppColors.primary,
                                    fontSize: FontSize.size16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.customer.name,
                                      style: getMediumStyle(
                                        fontFamily: FontConstant.cairo,
                                        color: Colors.white,
                                        fontSize: FontSize.size16,
                                      ),
                                    ),
                                    Text(
                                      'طلب #${widget.order.id}',
                                      style: getRegularStyle(
                                        fontFamily: FontConstant.cairo,
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: FontSize.size12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Details Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description
                          Text(
                            widget.order.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: getRegularStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size14,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Measurements & Fabrics
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildInfoChip(
                                Icons.height,
                                '${widget.order.height} سم',
                                AppColors.primary.withOpacity(0.1),
                              ),
                              _buildInfoChip(
                                Icons.monitor_weight_outlined,
                                '${widget.order.weight} كجم',
                                AppColors.primary.withOpacity(0.1),
                              ),
                              _buildInfoChip(
                                Icons.straighten,
                                widget.order.size,
                                AppColors.primary.withOpacity(0.1),
                              ),
                              ...widget.order.fabrics
                                  .map((fabric) => _buildInfoChip(
                                        Icons.format_paint_outlined,
                                        fabric.type,
                                        _getColorFromHex(fabric.color)
                                            .withOpacity(0.1),
                                        textColor:
                                            _getColorFromHex(fabric.color),
                                      )),
                            ],
                          ),

                          // Actions
                          if (widget.isMyRequest) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                            margin: const EdgeInsets.only(
                                                bottom: 8, left: 8, right: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: CustomDialogButton(
                                                    text: 'إلغاء',
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: CustomDialogButton(
                                                    text: 'حذف',
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      widget.onDelete?.call(
                                                          widget.order.id);
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
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.error,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/trash.svg',
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'حذف الطلب',
                                          style: getRegularStyle(
                                            fontFamily: FontConstant.cairo,
                                            color: AppColors.error,
                                            fontSize: FontSize.size12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: AppColors.error,
                                  tooltip: 'حذف',
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CustomProgressIndcator(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge() {
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
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          const SizedBox(width: 4),
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

  Widget _buildInfoChip(IconData icon, String label, Color backgroundColor,
      {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              textColor?.withOpacity(0.2) ?? AppColors.primary.withOpacity(0.2),
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
              color: textColor ?? Colors.black87,
              fontSize: FontSize.size12,
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
}
