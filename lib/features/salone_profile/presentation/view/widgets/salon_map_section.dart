import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/outline_with_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SalonMapSection extends StatelessWidget {
  final String googleMapsUrl;
  final Location location;

  const SalonMapSection({
    super.key,
    required this.googleMapsUrl,
    required this.location,
  });

  // Extrae las coordenadas de la URL de Google Maps
  String? _extractStaticMapUrl() {
    if (googleMapsUrl.isEmpty) {
      return null;
    }
    
    try {
      // Intenta extraer coordenadas de diferentes formatos de URL
      String coords = "";
      
      // Formato: ?q=lat,lng
      Uri uri = Uri.parse(googleMapsUrl);
      String? query = uri.queryParameters['q'];
      if (query != null && query.contains(',')) {
        coords = query;
      } 
      // Formato: ?center=lat,lng
      else if (uri.queryParameters['center'] != null) {
        coords = uri.queryParameters['center']!;
      }
      // Formato: @lat,lng,zoom
      else {
        RegExp regExp = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
        Match? match = regExp.firstMatch(googleMapsUrl);
        if (match != null && match.groupCount >= 2) {
          coords = "${match.group(1)},${match.group(2)}";
        }
      }
      
      if (coords.isNotEmpty) {
        // Construir URL para la API de Google Static Maps
        return 'https://maps.googleapis.com/maps/api/staticmap?center=$coords&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7C$coords&key=AIzaSyCCeOakAj_XDYDMfHKA3K6VZ0D29r8RmlA';
      }
    } catch (e) {
      print('Error al extraer coordenadas: $e');
    }
    
    return null;
  }

  Future<void> _launchMapUrl() async {
    if (googleMapsUrl.isEmpty) {
      return;
    }
    
    final Uri url = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (googleMapsUrl.isEmpty) {
      return const SizedBox();
    }

    // Intenta obtener la URL de la imagen estática del mapa
    final String? staticMapUrl = _extractStaticMapUrl();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OutlineWithIcon(
            icon: Icons.location_on,
            title: 'الموقع على الخريطة',
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _launchMapUrl,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
                image: staticMapUrl != null
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(staticMapUrl),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/map_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
              ),
              child: Stack(
                children: [
                  // Solo muestra el marcador si no tenemos la imagen del mapa estático
                  if (staticMapUrl == null)
                    const Center(
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 42,
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'اضغط للانتقال إلى خرائط Google',
                            style: getMediumStyle(
                              color: Colors.white,
                              fontSize: FontSize.size14,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${location.city}, ${location.state}',
                    style: getRegularStyle(
                      color: AppColors.textPrimary,
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 