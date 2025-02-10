import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/common/image_gallery_dialog.dart';

class SalonGalleryGrid extends StatelessWidget {
  final SalonImages images;

  const SalonGalleryGrid({
    super.key,
    required this.images,
  });

  void _openImageGallery(BuildContext context, int index) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => ImageGalleryDialog(
        images: images.gallery,
        initialIndex: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery Header with View All
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(.9),
                      AppColors.primary.withOpacity(.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.collections_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'معرض الصور',
                style: getBoldStyle(
                  fontSize: FontSize.size20,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const Spacer(),
              if (images.gallery.length > 6)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full gallery
                  },
                  child: Text(
                    'المزيد',
                    style: getMediumStyle(
                      color: AppColors.primary,
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Gallery Grid
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: images.gallery.length > 6 ? 6 : images.gallery.length,
            itemBuilder: (context, index) {
              final isLastItem = index == 5 && images.gallery.length > 6;
              return GestureDetector(
                onTap: isLastItem
                    ? () {
                        // TODO: Navigate to full gallery
                      }
                    : () => _openImageGallery(context, index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: images.gallery[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/salon_image.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Overlay for last item showing remaining count
                      if (isLastItem)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Text(
                              '+${images.gallery.length - 6}',
                              style: getBoldStyle(
                                color: Colors.white,
                                fontSize: FontSize.size18,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
