import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/nearby/presentation/view/widgets/location_permission_dialog.dart';
import 'package:beautilly/features/nearby/presentation/view/widgets/discover_bottom_sheet.dart';
import 'package:beautilly/features/nearby/presentation/view/widgets/discover_filter_chips.dart';
import 'package:beautilly/features/nearby/presentation/view/widgets/discover_location_button.dart';
import 'package:beautilly/features/nearby/presentation/view/widgets/discover_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class DiscoverViewBody extends StatefulWidget {
  const DiscoverViewBody({super.key});

  @override
  State<DiscoverViewBody> createState() => _DiscoverViewBodyState();
}

class _DiscoverViewBodyState extends State<DiscoverViewBody> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  final LatLng _center = const LatLng(24.7136, 46.6753);
  bool _isMapLoading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LocationPermissionDialog(),
    ).then((_) {
      _getCurrentLocation();
    });
  }

  void _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );

        // تحديث الماركر للموقع الحالي
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'موقعك الحالي'),
          ),
        );
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    // تحديث الماركر الافتراضي إذا لم يكن هناك موقع حالي
    if (_currentPosition == null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _center,
          infoWindow: const InfoWindow(title: 'موقعك الحالي'),
        ),
      );
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isMapLoading = false;
        });
      }
    });
  }

  void _showLocationOnMap(double latitude, double longitude) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('shop_location'),
          position: LatLng(latitude, longitude),
          infoWindow: const InfoWindow(title: 'موقع المتجر'),
        ),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentPosition != null
                ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                : _center,
            zoom: 14.0,
            tilt: 0.0,
            bearing: 0.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
          buildingsEnabled: true,
          indoorViewEnabled: true,
          mapType: MapType.normal,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          trafficEnabled: true,
          minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
          padding: EdgeInsets.zero,
        ),
        if (_isMapLoading)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(
              child: CustomProgressIndcator(
                size: 50.0,
                color: AppColors.primary,
                speed: Duration(milliseconds: 900),
              ),
            ),
          ),
        const Positioned(
          top: 50,
          left: 16,
          right: 16,
          child: DiscoverSearchBar(),
        ),
        const Positioned(
          top: 110,
          left: 16,
          right: 16,
          child: DiscoverFilterChips(),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.1,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return DiscoverBottomSheet(
              scrollController: scrollController,
              onLocationSelect: _showLocationOnMap,
            );
          },
        ),
        if (mapController != null)
          Positioned(
            bottom: 280,
            right: 16,
            child: DiscoverLocationButton(
              mapController: mapController!,
              center: _currentPosition != null
                  ? LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude)
                  : _center,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
