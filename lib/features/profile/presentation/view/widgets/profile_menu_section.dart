import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuGroup(
          title: "الحساب",
          items: [
            MenuItem(
              icon: Icons.person_outline,
              title: "المعلومات الشخصية",
              onTap: () {},
            ),
            MenuItem(
              icon: Icons.location_on_outlined,
              title: "العنوان",
              onTap: () {},
            ),
            MenuItem(
              icon: Icons.payment_outlined,
              title: "طرق الدفع",
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
              icon: Icons.language_outlined,
              title: "اللغة",
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
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('تسجيل الخروج'),
                    content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('تأكيد'),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true && context.mounted) {
                  final result = await context.read<AuthRepository>().logout();
                  
                  result.fold(
                    (failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(failure.message)),
                      );
                    },
                    (_) {
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          SigninView.routeName,
                          (route) => false,
                        );
                      }
                    },
                  );
                }
              },
              isDestructive: true,
            ),
          ],
        ),
      ],
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
