import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:beautilly/features/profile/presentation/view/edit_profile/widgets/section_title.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/custom_profile_field.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const ChangePasswordForm({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'تغيير كلمة المرور',
          icon: Icons.lock_outline,
        ),
        const SizedBox(height: 24),
        CustomProfileField(
          controller: currentPasswordController,
          label: 'كلمة المرور الحالية',
          hint: 'أدخل كلمة المرور الحالية',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          onChanged: (_) {
            context.findAncestorStateOfType<FormState>()?.validate();
          },
        ),
        const SizedBox(height: 2),
        CustomProfileField(
          controller: newPasswordController,
          label: 'كلمة المرور الجديدة',
          hint: 'أدخل كلمة المرور الجديدة',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          validator: (value) {
            if (currentPasswordController.text.isNotEmpty) {
              if (value == null || value.isEmpty) {
                return 'يجب إدخال كلمة المرور الجديدة';
              }
              return FormValidators.validatePassword(value);
            }
            return null;
          },
          onChanged: (_) {
            context.findAncestorStateOfType<FormState>()?.validate();
          },
        ),
        const SizedBox(height: 2),
        CustomProfileField(
          controller: confirmPasswordController,
          label: 'تأكيد كلمة المرور',
          hint: 'أعد إدخال كلمة المرور الجديدة',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          validator: (value) {
            if (currentPasswordController.text.isNotEmpty) {
              if (value == null || value.isEmpty) {
                return 'يجب تأكيد كلمة المرور الجديدة';
              }
              return FormValidators.validateConfirmPassword(
                value,
                newPasswordController.text,
              );
            }
            return null;
          },
          onChanged: (_) {
            context.findAncestorStateOfType<FormState>()?.validate();
          },
        ),
      ],
    );
  }
}
