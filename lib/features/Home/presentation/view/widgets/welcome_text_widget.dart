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
import 'package:beautilly/core/services/notification/notification_service.dart';

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
  final bool isGuest = context.read<ProfileCubit>().isGuestUser;
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRoutes.fadeScale(
            page: BlocProvider(
              create: (context) => sl<NotificationsCubit>()..loadNotifications(),
              child: NotificationsPage(),
            ),
          ),
        ).then((_) {
          sl<NotificationService>().markAllAsRead();
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
           if (!isGuest)
          Container(
            width: 33,
            height: 33,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppAssets.notificationIcon,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          StreamBuilder<int>(
            stream: sl<NotificationService>().unreadCount,
            initialData: sl<NotificationService>().currentUnreadCount,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
            //  print('🏷️ Badge count: $count');
              
              if (count == 0) return const SizedBox.shrink();
              
              return Positioned(
                top: -5,
                right: -5,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
