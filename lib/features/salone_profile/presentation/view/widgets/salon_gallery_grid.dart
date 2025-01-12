import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';

class SalonGalleryGrid extends StatelessWidget {
  const SalonGalleryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery Header with View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'معرض الصور',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'المزيد',
                  style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 8,
          ),

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
            itemCount: 6, // Show only 6 images initially
            itemBuilder: (context, index) {
              return _buildGalleryItem(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(int index) {
    return GestureDetector(
      onTap: () {
        // Handle image tap
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage('assets/images/salon_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // If it's the last item and there are more images
        child: index == 5
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Center(
                  child: Text(
                    '+24',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
