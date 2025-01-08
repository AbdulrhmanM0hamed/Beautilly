import 'package:beautilly/core/utils/animations/dot_spinner.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/discover_bottom_sheet.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/discover_filter_chips.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/discover_location_button.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/discover_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload map style when theme changes
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    try {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final stylePath = isDark ? 'assets/map_style_dark.json' : 'assets/map_style_light.json';
      final style = await rootBundle.loadString(stylePath);
      
      setState(() {
        _mapStyle = style;
      });

      // Update map style if controller exists
      if (mapController != null && _mapStyle != null) {
        await mapController!.setMapStyle(_mapStyle);
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    
    // Apply custom map style
    if (_mapStyle != null) {
      await controller.setMapStyle(_mapStyle);
    }

    _markers.add(
      const Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(24.7136, 46.6753),
        infoWindow: InfoWindow(title: 'موقعك الحالي'),
      ),
    );
    
    // Delay hiding the loading indicator for better UX
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isMapLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        // Google Map
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
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
          buildingsEnabled: false,
          mapType: MapType.normal,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
          padding: const EdgeInsets.only(bottom: 100), // Add padding for bottom sheet
        ),

        // Loading Indicator
        if (_isMapLoading)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(
              child: DotSpinner(
                size: 50.0,
                color: AppColors.primary,
                speed: Duration(milliseconds: 900),
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
