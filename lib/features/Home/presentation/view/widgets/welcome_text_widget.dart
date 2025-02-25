import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/notifications/presentation/view/notifications_page.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/notifications/presentation/cubit/notifications_cubit.dart';

class WelcomeTextWidget extends StatefulWidget {
  const WelcomeTextWidget({super.key});

  @override
  State<WelcomeTextWidget> createState() => _WelcomeTextWidgetState();
}

class _WelcomeTextWidgetState extends State<WelcomeTextWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) => current is ProfileLoaded,
          listener: (context, state) {
            if (state is ProfileLoaded) {
              setState(() {}); // تحديث الواجهة
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) {
          return current is ProfileLoaded || current is ProfileLoading;
        },
        builder: (context, state) {
          
          String userName = 'مستخدم';
          String? userImage;

          if (state is ProfileLoaded) {
            userName = state.profile.name;
            userImage = state.profile.image;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: userImage != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: userImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 30,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'مرحباً بك',
                            style: getBoldStyle(
                              color: AppColors.grey,
                              fontSize: FontSize.size16,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                          const Spacer(),
                          _buildNotificationButton(context)
                        ],
                      ),
                      Text(
                        userName,
                        style: getBoldStyle(
                          fontSize: FontSize.size18,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildNotificationButton(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRoutes.fadeScale(
            page: BlocProvider(
              create: (context) =>
                  sl<NotificationsCubit>()..loadNotifications(),
              child:  NotificationsPage(),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 33,
        height: 33,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.15),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.006),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            AppAssets.notificationIcon,
            height: 30,
            width: 30,
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

class CustomSearch extends StatelessWidget {
  const CustomSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: Center(
        child: Image.network(
          AppAssets.searchIcon,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
