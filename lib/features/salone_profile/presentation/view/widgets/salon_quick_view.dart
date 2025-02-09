import 'package:beautilly/core/utils/common/arrow_back_widget.dart';
import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/cart_of_booking.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalonQuickView extends StatefulWidget {
  const SalonQuickView({super.key});

  @override
  State<SalonQuickView> createState() => _SalonQuickViewState();
}

class _SalonQuickViewState extends State<SalonQuickView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < -300) {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: const SalonProfileView(),
                );
              },
            ),
          );
        }
      },
    
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/salon_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Top Actions
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    const ArrowBackWidget(),

                    // Favorite and Map Buttons
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: IconButton(
                            icon: const Icon(Icons.favorite_border,
                                color: Colors.red),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: SvgPicture.asset(AppAssets.map,
                              color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Center Card
            const CartOfBooking(),

            // Bottom Text
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text('اسحبى لرؤية المزيد',
                      style: getRegularStyle(
                        color: AppColors.white,
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                      )),
                  const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
