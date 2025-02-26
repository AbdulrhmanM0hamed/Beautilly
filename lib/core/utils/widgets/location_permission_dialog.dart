import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_colors.dart';
import '../constant/font_manger.dart';
import '../constant/styles_manger.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onGranted;
  
  const LocationPermissionDialog({
    super.key,
    required this.onGranted,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'السماح بالوصول للموقع',
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size18,
        ),
      ),
      content: Text(
        'نحتاج إذن الوصول لموقعك لنتمكن من عرض المحلات القريبة منك',
        style: getMediumStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size14,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'لاحقاً',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.grey,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            final permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.always || 
                permission == LocationPermission.whileInUse) {
              onGranted();
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(
            'السماح',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
} 