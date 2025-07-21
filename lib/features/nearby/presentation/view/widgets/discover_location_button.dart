import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DiscoverLocationButton extends StatelessWidget {
  const DiscoverLocationButton({
    super.key,
    required this.mapController,
    required this.center,
    required this.onLocationPressed,
  });

  final GoogleMapController mapController;
  final LatLng center;
  final Function() onLocationPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onLocationPressed,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppAssets.detectLocation,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
