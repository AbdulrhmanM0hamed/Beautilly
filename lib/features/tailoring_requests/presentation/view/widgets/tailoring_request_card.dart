import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/tailoring_requests/data/models/tailoring_request.dart';
import 'package:flutter/material.dart';

class TailoringRequestCard extends StatelessWidget {
  final TailoringRequest request;

  const TailoringRequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.grey.withOpacity(0.1),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with client info
          ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(request.clientImage),
            ),
            title: Text(
              request.clientName,
              style: getBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
              ),
            ),
            subtitle: Text(
              'منذ ${_getTimeAgo(request.createdAt)}',
              style: getMediumStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: _buildStatusChip(request.status),
          ),

          // Design Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.asset(
              request.designImage,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Size and execution time
                Row(
                  children: [
                    _buildDetailChip(
                      Icons.straighten,
                      'المقاس: ${request.size}',
                    ),
                    const SizedBox(width: 8),
                    _buildDetailChip(
                      Icons.timer_outlined,
                      '${request.executionDays} يوم',
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Fabrics
                Wrap(
                  spacing: 8,
                  children: request.fabrics.map((fabric) {
                    return _buildFabricChip(fabric);
                  }).toList(),
                ),

                const SizedBox(height: 8),
                Text(
                  request.description,
                  style: getMediumStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'قيد الانتظار';
        break;
      case 'accepted':
        color = Colors.green;
        text = 'مقبول';
        break;
      default:
        color = Colors.grey;
        text = 'غير معروف';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: getMediumStyle(
          fontSize: FontSize.size12,
          fontFamily: FontConstant.cairo,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: getMediumStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFabricChip(FabricDetail fabric) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(int.parse(fabric.color)).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Color(int.parse(fabric.color)),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            fabric.type,
            style: getMediumStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
