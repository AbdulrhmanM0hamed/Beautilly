import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/orders/domain/entities/order_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../cubit/accept_offer_cubit/accept_offer_cubit.dart';
import '../cubit/accept_offer_cubit/accept_offer_state.dart';
import '../cubit/order_details_cubit/order_details_cubit.dart';
import '../cubit/order_details_cubit/order_details_state.dart';

class OrderDetailsView extends StatelessWidget {
  static const String routeName = '/order-details';
  final OrderDetails orderDetails;
  final bool isMyOrder;

  const OrderDetailsView({
    super.key,
    required this.orderDetails,
    required this.isMyOrder,
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
                CustomSnackbar.showSuccess(
                  context: context,
                  message: 'تم قبول العرض بنجاح',
                );
                context
                    .read<OrderDetailsCubit>()
                    .updateOfferStatus(state.offerId);
              } else if (state is AcceptOfferError) {
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
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'order_${orderDetails.id}',
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: orderDetails.images.large,
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // معلومات العميل
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  imageUrl: orderDetails.customer.images.medium,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.1),
                                    child: Text(
                                      orderDetails.customer.name[0]
                                          .toUpperCase(),
                                      style: getBoldStyle(
                                        color: AppColors.primary,
                                        fontSize: FontSize.size20,
                                        fontFamily: FontConstant.cairo,
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
                                      orderDetails.customer.name,
                                      style: getBoldStyle(
                                        fontSize: FontSize.size18,
                                        fontFamily: FontConstant.cairo,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${orderDetails.customer.address.city}، ${orderDetails.customer.address.state}',
                                          style: getRegularStyle(
                                            color: Colors.grey[600],
                                            fontSize: FontSize.size12,
                                            fontFamily: FontConstant.cairo,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              _buildStatusChip(orderDetails.status,
                                  orderDetails.statusLabel),
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
                          if (detailsState is OrderDetailsSuccess) ...[
                            if (detailsState
                                .orderDetails.offers.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Text(
                                'العروض المقدمة',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size18,
                                ),
                              ),
                              const SizedBox(height: 22),
                              _buildOffersSection(
                                context,
                                detailsState.orderDetails,
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
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
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orderDetails.offers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final offer = orderDetails.offers[index];
        final bool isAccepted = offer.status == 'accepted';
        final bool canAcceptOffer = isMyOrder &&
            !orderDetails.offers.any((o) => o.status == 'accepted');

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.07),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              imageUrl:
                                  (offer.shop as ShopWithDetails).images.medium,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
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
                                    fontSize: FontSize.size16,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${offer.price} ريال',
                                style: getBoldStyle(
                                  color: AppColors.primary,
                                  fontSize: FontSize.size18,
                                  fontFamily: FontConstant.cairo,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (isAccepted)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'تم القبول',
                                        style: getMediumStyle(
                                          fontSize: FontSize.size12,
                                          color: Colors.green,
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
                      if (offer.notes != null || offer.daysCount != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                          
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[400]!,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (offer.daysCount != null) ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.timer_outlined,
                                      size: 16,
                                 
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'مدة التنفيذ: ${offer.daysCount} أيام',
                                      style: getRegularStyle(
                                        fontSize: FontSize.size14,
                                        fontFamily: FontConstant.cairo,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (offer.notes != null) ...[
                                if (offer.daysCount != null)
                                  const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.note_outlined,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        offer.notes!,
                                        style: getRegularStyle(
                                   
                                          fontSize: FontSize.size14,
                                          fontFamily: FontConstant.cairo,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      if (canAcceptOffer && !isAccepted) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                backgroundColor: AppColors.success,
                                onPressed: () => _showAcceptConfirmation(
                                  context,
                                  orderDetails.id,
                                  offer.id,
                                ),
                                text: 'قبول العرض',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAcceptConfirmation(BuildContext context, int orderId, int offerId) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<AcceptOfferCubit>(context),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'تأكيد قبول العرض',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
            ),
          ),
          content: Text(
            'هل أنت متأكد من قبول هذا العرض؟',
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
                    child: CustomButton(
                      text: 'إلغاء',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.grey[200],
                      textColor: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'قبول',
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AcceptOfferCubit>().acceptOffer(orderId, offerId);
                      },
                      backgroundColor: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}
