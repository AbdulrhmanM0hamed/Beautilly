import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileController {
  final ProfileModel profile;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  EditProfileController(this.profile) {
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController.text = profile.name;
    emailController.text = profile.email;
    phoneController.text = profile.phone!;
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void updateControllers(ProfileModel profile) {
    nameController.text = profile.name;
    emailController.text = profile.email;
    phoneController.text = profile.phone!;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  void updateProfile(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // التحقق من تغيير البيانات الأساسية
    final hasBasicChanges = name != profile.name ||
        email != profile.email ||
        phone != profile.phone;

    // التحقق من إدخال كلمة مرور جديدة
    final hasPasswordChanges = newPassword.isNotEmpty || confirmPassword.isNotEmpty;

    if (!hasBasicChanges && !hasPasswordChanges) {
      CustomSnackbar.showError(
        context: context,
        message: 'لم يتم إجراء أي تغييرات',
      );
      return;
    }

    // تحديث البيانات الأساسية إذا تم تغييرها
    if (hasBasicChanges) {
      context.read<ProfileCubit>().updateProfile(
        name: name,
        email: email,
        phone: phone,
      );
    }

    // تحديث كلمة المرور فقط إذا تم إدخال كلمة مرور جديدة
    if (hasPasswordChanges) {
      if (currentPassword.isEmpty) {
        CustomSnackbar.showError(
          context: context,
          message: 'يجب إدخال كلمة المرور الحالية',
        );
        return;
      }

      if (newPassword != confirmPassword) {
        CustomSnackbar.showError(
          context: context,
          message: 'كلمة المرور الجديدة غير متطابقة',
        );
        return;
      }

      context.read<ProfileCubit>().changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
    }
  }

  // التحقق من صحة البيانات الشخصية فقط
  bool _validateProfileData() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        FormValidators.validateEmail(emailController.text) == null &&
        (phoneController.text.isEmpty ||
            FormValidators.validatePhone(phoneController.text) == null);
  }

  // التحقق من صحة بيانات كلمة المرور فقط
  bool _validatePasswordData() {
    if (!_isPasswordChangeRequested()) return true;

    return FormValidators.validatePassword(newPasswordController.text) == null &&
        FormValidators.validateConfirmPassword(
              confirmPasswordController.text,
              newPasswordController.text,
            ) ==
            null;
  }

  bool _isProfileDataChanged() {
    return nameController.text != profile.name ||
        emailController.text != profile.email ||
        phoneController.text != profile.phone;
  }

  bool _isPasswordChangeRequested() {
    return currentPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool get isPasswordsMatch =>
      !_isPasswordChangeRequested() || // إذا لم يتم إدخال كلمات مرور أصلاً
      (newPasswordController.text == confirmPasswordController.text); // أو إذا كانت متطابقة

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void _showSuccessMessage(BuildContext context) {
    print('🔄 Showing success message for user: ${profile.email}');
    CustomSnackbar.showSuccess(
      context: context,
      message: 'تم تحديث البيانات بنجاح',
    );
  }

  void _showNoChangesMessage(BuildContext context) {
    CustomSnackbar.showError(
      context: context,
      message: 'لم يتم إجراء أي تغييرات',
    );
  }

  void _showErrorMessage(BuildContext context, String error) {
    CustomSnackbar.showError(
      context: context,
      message: 'حدث خطأ: $error',
    );
  }
}