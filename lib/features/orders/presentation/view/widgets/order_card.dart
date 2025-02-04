import 'package:beautilly/features/orders/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final bool isMyRequest;

  const OrderCard({
    super.key,
    required this.order,
    required this.isMyRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: order.mainImage.medium,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 140,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 140,
                    color: Colors.grey[100],
                    child: const Icon(Icons.error_outline),
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
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
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Text(
                        order.user.name[0].toUpperCase(),
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          color: AppColors.primary,
                          fontSize: FontSize.size14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.user.name,
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              color: Colors.white,
                              fontSize: FontSize.size14,
                            ),
                          ),
                          Text(
                            'طلب #${order.id}',
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
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  order.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    color: Colors.black87,
                    fontSize: FontSize.size14,
                  ),
                ),
                const SizedBox(height: 12),

                // Measurements & Fabrics
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.height,
                      '${order.height} سم',
                      AppColors.primary.withOpacity(0.1),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.monitor_weight_outlined,
                      '${order.weight} كجم',
                      AppColors.primary.withOpacity(0.1),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.straighten,
                      order.size,
                      AppColors.primary.withOpacity(0.1),
                    ),
                  ],
                ),
                if (order.fabrics.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 28,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: order.fabrics.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final fabric = order.fabrics[index];
                        final color = Color(
                          int.parse(fabric.color.replaceAll('#', '0xFF')),
                        );
                        return _buildInfoChip(
                          Icons.format_paint_outlined,
                          fabric.type,
                          color.withOpacity(0.1),
                          textColor: color,
                        );
                      },
                    ),
                  ),
                ],

                // Actions
                if (isMyRequest) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined),
                        color: AppColors.primary,
                        tooltip: 'تعديل',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline),
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
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    IconData statusIcon;
    
    switch (order.status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            order.statusLabel,
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

  Widget _buildInfoChip(IconData icon, String label, Color backgroundColor, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
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
}
