import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/discover_bottom_sheet.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/discover_filter_chips.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/discover_location_button.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/discover_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _markers.add(
        const Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(24.7136, 46.6753),
          infoWindow: InfoWindow(title: 'موقعك الحالي'),
        ),
      );
      _isMapLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Google Map
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 14.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),

        // Loading Indicator
        if (_isMapLoading)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
          ),

        // Search Bar
        const Positioned(
          top: 50,
          left: 16,
          right: 16,
          child: DiscoverSearchBar(),
        ),

        // Service Type Filter
        const Positioned(
          top: 110,
          left: 16,
          right: 16,
          child: DiscoverFilterChips(),
        ),

        // Bottom Sheet with Nearby Services
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return DiscoverBottomSheet(
              scrollController: scrollController,
            );
          },
        ),

        // Current Location Button
        if (mapController != null)
          Positioned(
            bottom: 280,
            right: 16,
            child: DiscoverLocationButton(
              mapController: mapController!,
              center: _center,
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
