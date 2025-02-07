import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/features/orders/domain/entities/order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../domain/entities/order_details.dart';
import 'widgets/image_viewer.dart';

class OrderDetailsView extends StatelessWidget {
  static const String routeName = '/order-details';
  final OrderDetails order;
  final bool isMyOrder;

  const OrderDetailsView({
    super.key, 
    required this.order,
    required this.isMyOrder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // انتظار لمدة ثانية
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomProgressIndcator(
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // صورة الطلب مع الـ Header
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
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
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'order_${order.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 1. الصورة أولاً
                        CachedNetworkImage(
                          imageUrl: order.images.large,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CustomProgressIndcator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        // 2. التدرج فوق الصورة
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
                        // 3. GestureDetector في الأعلى
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewer(
                                  imageUrl: order.images.large,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // تفاصيل الطلب
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          // معلومات العميل
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  imageUrl: order.customer.images.medium,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors.primary.withOpacity(0.1),
                                    child: Text(
                                      order.customer.name[0].toUpperCase(),
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
                                      order.customer.name,
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
                                          '${order.customer.address.city}، ${order.customer.address.state}',
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
                              _buildStatusChip(order.status, order.statusLabel),
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
                            order.description,
                            style: getRegularStyle(
                              fontSize: FontSize.size16,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // العروض المقدمة
                          if (order.offers.isNotEmpty) ...[
                            Text(
                              'العروض المقدمة',
                              style: getBoldStyle(
                                fontSize: FontSize.size18,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: order.offers.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final offer = order.offers[index];
                                return _buildOfferCard(offer);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
          value: '${order.height} سم',
        ),
        _buildMeasurementCard(
          icon: Icons.monitor_weight_outlined,
          title: 'الوزن',
          value: '${order.weight} كجم',
        ),
        _buildMeasurementCard(
          icon: Icons.straighten,
          title: 'المقاس',
          value: order.size,
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
      children: order.fabrics.map((fabric) {
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

  Widget _buildOfferCard(OfferWithDetails offer) {
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
                          imageUrl: (offer.shop as ShopWithDetails).images.medium,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
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
                                fontSize: FontSize.size16,
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
                        ],
                      ),
                    ],
                  ),
                  if (offer.notes != null || offer.daysCount != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[200]!,
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
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'مدة التنفيذ: ${offer.daysCount} أيام',
                                  style: getRegularStyle(
                                    color: Colors.grey[700],
                                    fontSize: FontSize.size14,
                                    fontFamily: FontConstant.cairo,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (offer.notes != null) ...[
                            if (offer.daysCount != null) const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.note_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    offer.notes!,
                                    style: getRegularStyle(
                                      color: Colors.grey[700],
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
                  const SizedBox(height: 16),
                  if (isMyOrder) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('قبول العرض'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.close),
                            label: const Text('رفض العرض'),
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
