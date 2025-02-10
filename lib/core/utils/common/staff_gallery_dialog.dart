import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import '../constant/styles_manger.dart';
import '../constant/font_manger.dart';
import '../theme/app_colors.dart';
import 'dart:ui';

class StaffGalleryDialog extends StatefulWidget {
  final List<Staff> staff;
  final int initialIndex;

  const StaffGalleryDialog({
    super.key,
    required this.staff,
    required this.initialIndex,
  });

  @override
  State<StaffGalleryDialog> createState() => _StaffGalleryDialogState();
}

class _StaffGalleryDialogState extends State<StaffGalleryDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Main Content
              PageView.builder(
                controller: _pageController,
                itemCount: widget.staff.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final member = widget.staff[index];
                  return Column(
                    children: [
                      // Safe Area for top padding
                      const SizedBox(height: 80),
                      
                      // Staff Image
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: PhotoView(
                            imageProvider: CachedNetworkImageProvider(member.image),
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered * 2.5,
                            backgroundDecoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),

                      // Staff Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              member.name,
                              style: getBoldStyle(
                                fontSize: FontSize.size18,
                                fontFamily: FontConstant.cairo,
                        
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              member.role,
                              style: getMediumStyle(
                                fontSize: FontSize.size16,
                                fontFamily: FontConstant.cairo,
                          
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Space for bottom thumbnails
                      const SizedBox(height: 80),
                    ],
                  );
                },
              ),

              // Top Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          '${_currentIndex + 1}/${widget.staff.length}',
                          style: getBoldStyle(
                            color: Colors.white,
                            fontSize: FontSize.size16,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Thumbnail Strip
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: widget.staff.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _currentIndex == index
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: widget.staff[index].image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 