import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:beautilly/features/notifications/presentation/view/notifications_page.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_state.dart';
import 'package:beautilly/features/profile/presentation/view/edit_profile/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import '../../../../../core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/features/profile/presentation/view/edit_address/edit_address_view.dart';
import 'package:beautilly/features/profile/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import 'package:beautilly/features/profile/presentation/view/favorites/favorites_view.dart';
import 'package:beautilly/features/profile/presentation/view/dashboard_webview.dart';
import 'package:beautilly/core/cubits/theme/theme_cubit.dart';
import 'package:beautilly/core/cubits/theme/theme_state.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileCubit>().loadProfile();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is ProfileLoaded) {
          final profile = state.profile;
          if (profile.name == null || profile.name!.isEmpty) {
            context.read<ProfileCubit>().loadProfile();
            return const Center(child: CircularProgressIndicator());
          }

          final bool isNotClient = profile.role?.name != 'client';
          String userType = '';
          if (isNotClient) {
            switch (profile.role?.name) {
              case 'salon_manager':
                userType = 'مدير صالون';
                break;
              case 'tailor_manager':
                userType = 'مدير دار أزياء';
                break;
              case 'super_admin':
                userType = 'مدير نظام';
                break;
              default:
                userType = profile.role?.name ?? '';
            }
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNotClient) ...[
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أنت مسجل كـ $userType',
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardWebView(),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          icon: const Icon(Icons.dashboard_outlined),
                          label: Text(
                            'الذهاب إلى لوحة التحكم',
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
                _buildMenuGroup(
                  title: "إعدادات الحساب",
                  items: [
                    MenuItem(
                      icon: Icons.person_outline,
                      title: "تعديل الملف الشخصي",
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRoutes.fadeScale(
                            page: EditProfileView(profile: state.profile),
                          ),
                        );
                      },
                    ),
                    MenuItem(
                      icon: Icons.location_on_outlined,
                      title: "العنوان",
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRoutes.fadeScale(
                            page: EditAddressView(profile: state.profile),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _buildMenuGroup(
                  title: "المظهر",
                  items: [
                    MenuItem(
                      icon: Icons.dark_mode_outlined,
                      title: "المظهر الليلي",
                      trailing: _buildThemeSwitch(context),
                      onTap: () {},
                    ),
                  ],
                ),
                _buildMenuGroup(
                  title: "التفضيلات",
                  items: [
                    MenuItem(
                      icon: Icons.notifications_outlined,
                      title: "الإشعارات",
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRoutes.fadeScale(
                            page: NotificationsPage(),
                          ),
                        );
                      },
                    ),
                    MenuItem(
                      icon: Icons.favorite_border_outlined,
                      title: "المفضلة",
                      onTap: () {
                        final favoritesCubit = sl<FavoritesCubit>();
                        if (!favoritesCubit.isClosed) {
                          favoritesCubit.loadFavorites();
                        }

                        Navigator.push(
                          context,
                          PageRoutes.fadeScale(
                            page: BlocProvider.value(
                              value: favoritesCubit,
                              child: const FavoritesView(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _buildMenuGroup(
                  title: "الدعم",
                  items: [
                    MenuItem(
                      icon: Icons.help_outline,
                      title: "مركز المساعدة",
                      onTap: () {},
                    ),
                    MenuItem(
                      icon: Icons.policy_outlined,
                      title: "الشروط والأحكام",
                      onTap: () {},
                    ),
                    MenuItem(
                      icon: Icons.logout,
                      title: "تسجيل الخروج",
                      onTap: () => _handleLogout(context),
                      isDestructive: true,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            'تسجيل الخروج',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
            ),
          ),
          content: Text(
            'هل أنت متأكد من تسجيل الخروج؟',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'إلغاء',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.grey,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: Text(
                'تسجيل الخروج',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (shouldLogout != true || !context.mounted) {
      return;
    }

    try {
      await context.read<AuthCubit>().logout();

      if (!context.mounted) return;

      if (!context.read<ProfileCubit>().isClosed) {
        context.read<ProfileCubit>().clearProfile();
      }

      await Navigator.pushNamedAndRemoveUntil(
        context,
        SigninView.routeName,
        (route) => false,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تسجيل الخروج بنجاح',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      await Navigator.pushNamedAndRemoveUntil(
        context,
        SigninView.routeName,
        (route) => false,
      );
    }
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark =
            state is ThemeChanged && state.themeMode == ThemeMode.dark;

        return Switch(
          value: isDark,
          activeColor: AppColors.primary,
          onChanged: (value) {
            context.read<ThemeCubit>().setTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
          },
        );
      },
    );
  }

  Widget _buildMenuGroup({
    required String title,
    required List<MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(item)),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: item.isDestructive ? Colors.red : null,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: item.isDestructive ? Colors.red : null,
        ),
      ),
      trailing: item.trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: item.onTap,
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing;

  MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
  });
}
