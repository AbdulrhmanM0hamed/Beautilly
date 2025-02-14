import 'package:flutter/material.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double? height;

  const StatusBadge({
    super.key,
    required this.status,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final badgeHeight = height ?? (size.width > 800 ? 28.0 : 20.0);
    final fontSize = size.width > 800 ? FontSize.size12 : FontSize.size13;
    final iconSize = size.width > 800 ? 16.0 : 16.0;
    final horizontalPadding = size.width > 800 ? 20.9 : 8.0;

    Color color;
    String text;
    IconData icon;

    switch (status) {
      case 'completed':
        color = Colors.green;
        text = 'مكتمل';
        icon = Icons.check_circle_rounded;
        break;
      case 'pending':
        color = Colors.orange;
        text = 'انتظار';
        icon = Icons.schedule_rounded;
        break;
      case 'confirmed':
        color = Colors.blue;
        text = 'مؤكد';
        icon = Icons.verified_rounded;
        break;
      case 'canceled':
        color = Colors.red;
        text = 'ملغي';
        icon = Icons.cancel_rounded;
        break;
      default:
        color = Colors.grey;
        text = 'غير معروف';
        icon = Icons.help_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: iconSize,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: getMediumStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
} 