import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  Future<Position?> _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تفعيل خدمة تحديد الموقع'),
        ),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم رفض إذن الوصول للموقع'),
          ),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تفعيل إذن الوصول للموقع من إعدادات التطبيق'),
        ),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Location Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppAssets.detect_location,
                width: 48,
                height: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'تحديد موقعك',
              style: getBoldStyle(
                fontSize: FontSize.size20,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'نحتاج إلى تحديد موقعك لنتمكن من عرض الخدمات القريبة منك',
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                // Skip Button
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'تخطي',
                      style: getMediumStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Enable Location Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      final position = await _getCurrentLocation(context);
                      print(position);
                      if (position != null) {
                        // TODO: Send location to backend
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم تحديد موقعكم بنجاح'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'تفعيل الموقع',
                      style: getBoldStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
