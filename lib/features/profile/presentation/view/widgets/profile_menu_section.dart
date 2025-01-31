import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/Home/presentation/cubit/profile_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/profile_state.dart';
import 'package:beautilly/features/profile/presentation/view/edit_profile/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../core/utils/navigation/custom_page_route.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Column(
            children: [
              _buildMenuGroup(
                title: "الحساب",
                items: [
                  MenuItem(
                    icon: Icons.person_outline,
                    title: "المعلومات الشخصية",
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
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: Icons.favorite_border_outlined,
                    title: "المفضلة",
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: Icons.dark_mode_outlined,
                    title: "المظهر",
                    onTap: () {},
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
                    onTap: () async {
                      // عرض مربع حوار التأكيد
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
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
                      );

                      // إذا تم تأكيد تسجيل الخروج
                      if (shouldLogout == true && context.mounted) {
                        try {
                          final repository = context.read<AuthRepository>();
                          final result = await repository.logout();

                          if (!context.mounted) return;

                          result.fold(
                            (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(failure.message)),
                              );
                            },
                            (_) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                SigninView.routeName,
                                (route) => false,
                              );
                              CustomSnackbar.showSuccess(
                                context: context,
                                message: "تم تسجيل الخروج بنجاح",
                              );
                            },
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('حدث خطأ أثناء تسجيل الخروج')),
                          );
                        }
                      }
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox();
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
        color: item.isDestructive ? AppColors.error : null,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: item.isDestructive ? AppColors.error : null,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: item.onTap,
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}
