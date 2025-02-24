import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/image_viewer.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/orders/domain/entities/order_details.dart';
import 'package:beautilly/features/orders/presentation/cubit/cancel_offer_cubit/cancel_offer_state.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../cubit/accept_offer_cubit/accept_offer_cubit.dart';
import '../cubit/accept_offer_cubit/accept_offer_state.dart';
import '../cubit/order_details_cubit/order_details_cubit.dart';
import '../cubit/order_details_cubit/order_details_state.dart';
import '../cubit/cancel_offer_cubit/cancel_offer_cubit.dart';

class OrderDetailsView extends StatelessWidget {
  static const String routeName = '/order-details';
  final OrderDetails orderDetails;
  final bool isMyOrder;
  final bool fromAllOrders;

  const OrderDetailsView({
    super.key,
    required this.orderDetails,
    required this.isMyOrder,
    this.fromAllOrders = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AcceptOfferCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              sl<OrderDetailsCubit>()..getOrderDetails(orderDetails.id),
        ),
        BlocProvider(
          create: (context) => sl<CancelOfferCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<OrdersCubit>(),
        ),
      ],
      child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: (context, state) {
          if (state is OrderDetailsSuccess) {
            // يمكن إضافة أي منطق إضافي هنا
          }
        },
        builder: (context, detailsState) {
          return BlocListener<AcceptOfferCubit, AcceptOfferState>(
            listener: (context, state) {
              if (state is AcceptOfferSuccess) {
                context
                    .read<OrderDetailsCubit>()
                    .updateOfferStatus(state.offerId);

                if (fromAllOrders) {
                  context.read<OrdersCubit>().loadAllOrders();
                } else {
                  context.read<OrdersCubit>().loadMyOrders();
                }

                // تأخير عرض الرسالة والتنقل
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    CustomSnackbar.showSuccess(
                      context: context,
                      message: 'تم قبول العرض بنجاح',
                    );
                  }
                });
              } else if (state is AcceptOfferError) {
                CustomSnackbar.showError(
                  context: context,
                  message: state.message,
                );
              }
            },
            child: BlocListener<CancelOfferCubit, CancelOfferState>(
              listener: (context, state) {
                if (state is CancelOfferSuccess) {
                  context
                      .read<OrderDetailsCubit>()
                      .updateOfferStatus(state.offerId);

                  if (fromAllOrders) {
                    context.read<OrdersCubit>().loadAllOrders();
                  } else {
                    context.read<OrdersCubit>().loadMyOrders();
                  }

                  // تأخير عرض الرسالة والتنقل
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      CustomSnackbar.showSuccess(
                        context: context,
                        message: 'تم إلغاء قبول العرض بنجاح',
                      );
                    }
                  });
                } else if (state is CancelOfferError) {
                  CustomSnackbar.showError(
                    context: context,
                    message: state.message,
                  );
                }
              },
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 300,
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ),
                      ),
                      pinned: true,
                      flexibleSpace: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageViewer(
                                imageUrl: orderDetails.images.main,
                              ),
                            ),
                          );
                        },
                        child: FlexibleSpaceBar(
                          background: Hero(
                            tag: 'order_${orderDetails.id}',
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: orderDetails.images.main,
                                  fit: BoxFit.cover,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // معلومات العميل
                            Row(
                              children: [
                                // صورة العميل
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(
                                    imageUrl: orderDetails.customer.images.main,
                                    width: 45,  // تصغير حجم الصورة
                                    height: 45,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => CircleAvatar(
                                      radius: 22.5,  // نصف القطر يساوي نصف العرض
                                      backgroundColor: AppColors.primary.withOpacity(0.1),
                                      child: Text(
                                        orderDetails.customer.name[0].toUpperCase(),
                                        style: getBoldStyle(
                                          color: AppColors.primary,
                                          fontSize: FontSize.size16,  // تصغير حجم الحرف
                                          fontFamily: FontConstant.cairo,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),  // تقليل المسافة
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderDetails.customer.name,
                                        style: getBoldStyle(
                                          fontSize: FontSize.size16,  // تصغير حجم الخط
                                          fontFamily: FontConstant.cairo,
                                        ),
                                      ),
                                      const SizedBox(height: 4),  // تقليل المسافة
                                      Row(
                                        children: [
                                        const  Icon(
                                            Icons.location_on_outlined,
                                            size: 16,  // تصغير حجم الأيقونة
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 2),  // تقليل المسافة
                                          Expanded(  // إضافة Expanded لمنع تجاوز النص
                                            child: Text(
                                              '${orderDetails.customer.address.city}، ${orderDetails.customer.address.state}',
                                              style: getRegularStyle(
                                                color: Colors.grey[600],
                                                fontSize: FontSize.size12,
                                                fontFamily: FontConstant.cairo,
                                              ),
                                              maxLines: 1,  // تحديد عدد الأسطر
                                              overflow: TextOverflow.ellipsis,  // إضافة ... عند تجاوز النص
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),  // مسافة قبل حالة الطلب
                                _buildStatusChip(orderDetails.status, orderDetails.statusLabel),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // القياسات
                            Text(
                              'القياسات',
                              style: getBoldStyle(
                                fontSize: FontSize.size18,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildMeasurementsGrid(),
                            const SizedBox(height: 24),

                            // الأقمشة
                            Text(
                              'الأقمشة المختارة',
                              style: getBoldStyle(
                                fontSize: FontSize.size18,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildFabricsList(),
                            const SizedBox(height: 24),

                            // الوصف
                            Text(
                              'الوصف',
                              style: getBoldStyle(
                                fontSize: FontSize.size18,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              orderDetails.description,
                              style: getRegularStyle(
                                fontSize: FontSize.size16,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),

                            // العروض المقدمة
                            const SizedBox(height: 24),
                            Text(
                              'العروض المقدمة',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size18,
                              ),
                            ),
                            const SizedBox(height: 22),
                            if (detailsState is OrderDetailsLoading) ...[
                              const Center(
                                child: CustomProgressIndcator(
                                  color: AppColors.primary,
                                ),
                              ),
                            ] else if (detailsState is OrderDetailsSuccess) ...[
                              if (detailsState.orderDetails.offers.isNotEmpty)
                                _buildOffersSection(
                                  context,
                                  detailsState.orderDetails,
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    Color color;
    IconData icon;

    switch (status) {
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'in_progress':
        color = Colors.blue;
        icon = Icons.pending;
        break;
      case 'pending':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: getMediumStyle(
              color: color,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementsGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildMeasurementCard(
          icon: Icons.height,
          title: 'الطول',
          value: '${orderDetails.height} سم',
        ),
        _buildMeasurementCard(
          icon: Icons.monitor_weight_outlined,
          title: 'الوزن',
          value: '${orderDetails.weight} كجم',
        ),
        _buildMeasurementCard(
          icon: Icons.straighten,
          title: 'المقاس',
          value: orderDetails.size,
        ),
      ],
    );
  }

  Widget _buildMeasurementCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: getRegularStyle(
              color: Colors.grey[600],
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: getBoldStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFabricsList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: orderDetails.fabrics.map((fabric) {
        final color = _getColorFromHex(fabric.color);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.format_paint_outlined, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                fabric.type,
                style: getMediumStyle(
                  color: color,
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOffersSection(BuildContext context, OrderDetails orderDetails) {
    final hasAcceptedOffer =
        orderDetails.offers.any((offer) => offer.status == 'accepted');

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orderDetails.offers.length,
      itemBuilder: (context, index) {
        final offer = orderDetails.offers[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalonProfileView(salonId: offer.shop.id),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // صورة الصالون
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              imageUrl:
                                  (offer.shop as ShopWithDetails).images.main,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                child: Text(
                                  offer.shop.name[0].toUpperCase(),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    color: AppColors.primary,
                                    fontSize: FontSize.size16,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => CircleAvatar(
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                child: Text(
                                  offer.shop.name[0].toUpperCase(),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    color: AppColors.primary,
                                    fontSize: FontSize.size16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer.shop.name,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size16,
                                  ),
                                ),
                                if (offer.daysCount != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${(offer.shop as ShopWithDetails).address.city}، ${(offer.shop as ShopWithDetails).address.state}',
                                        style: getRegularStyle(
                                          color: Colors.grey[600],
                                          fontSize: FontSize.size12,
                                          fontFamily: FontConstant.cairo,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.access_time,
                                        size: 18,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDate(offer.createdAt),
                                        style: getRegularStyle(
                                          fontFamily: FontConstant.cairo,
                                          fontSize: FontSize.size14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${offer.price} ريال',
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size16,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      if (offer.notes != null && offer.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                offer.notes!,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (offer.daysCount != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${offer.daysCount} أيام',
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (isMyOrder) ...[
                        if (offer.status == 'accepted') ...[
                          Row(
                            children: [
                              Expanded(
                                child: BlocBuilder<CancelOfferCubit,
                                    CancelOfferState>(
                                  builder: (context, state) {
                                    if (state is CancelOfferLoading) {
                                      return const Center(
                                        child: CustomProgressIndcator(
                                          color: AppColors.primary,
                                        ),
                                      );
                                    }
                                    return CustomButton(
                                      text: 'إلغاء قبول العرض',
                                      onPressed: () {
                                        context
                                            .read<CancelOfferCubit>()
                                            .cancelOffer(
                                                orderDetails.id, offer.id);
                                      },
                                      backgroundColor: Colors.red,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ] else if (!hasAcceptedOffer) ...[
                          // إظهار زر القبول فقط إذا لم يكن هناك عرض مقبول
                          Row(
                            children: [
                              Expanded(
                                child: BlocBuilder<AcceptOfferCubit,
                                    AcceptOfferState>(
                                  builder: (context, state) {
                                    if (state is AcceptOfferLoading) {
                                      return const Center(
                                        child: CustomProgressIndcator(
                                          color: AppColors.primary,
                                        ),
                                      );
                                    }
                                    return CustomButton(
                                      text: 'قبول العرض',
                                      onPressed: () {
                                        context
                                            .read<AcceptOfferCubit>()
                                            .acceptOffer(
                                                orderDetails.id, offer.id);
                                      },
                                      backgroundColor: AppColors.success,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                if (offer.status == 'accepted')
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[700],
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'تم القبول',
                            style: getMediumStyle(
                              color: Colors.green[700],
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Widget _buildCancelOfferButton(
      BuildContext context, OrderDetails orderDetails) {
    final acceptedOffers = orderDetails.offers
        .where((offer) => offer.status == 'accepted')
        .toList();

    if (acceptedOffers.isEmpty) return const SizedBox();

    return CustomButton(
      backgroundColor: Colors.red,
      onPressed: () {
        context
            .read<CancelOfferCubit>()
            .cancelOffer(orderDetails.id, acceptedOffers.first.id);
      },
      text: 'إلغاء قبول العرض',
    );
  }
}
