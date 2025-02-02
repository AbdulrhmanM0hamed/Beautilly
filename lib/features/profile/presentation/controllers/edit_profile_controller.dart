import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';

class EditProfileController {
  final ProfileModel profile;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
 // late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  EditProfileController(this.profile) {
    _initControllers();
  }

  void _initControllers() {
    nameController = TextEditingController(text: profile.name);
    emailController = TextEditingController(text: profile.email);
    phoneController = TextEditingController(text: profile.phone);
   // currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  //  currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> updateProfile(BuildContext context) async {
    // نتحقق من صحة الحقول المطلوبة فقط
    bool isProfileDataValid = true;
    bool isPasswordValid = true;

    // إذا تم تغيير البيانات الشخصية، نتحقق من صحتها
    if (_isProfileDataChanged()) {
      isProfileDataValid = _validateProfileData();
    }

    // إذا تم طلب تغيير كلمة المرور، نتحقق من صحتها
    if (_isPasswordChangeRequested()) {
      isPasswordValid = _validatePasswordData();
    }

    // إذا كان هناك أي خطأ في البيانات المطلوب تغييرها، نتوقف
    if (!isProfileDataValid || !isPasswordValid) return;

    bool dataChanged = false;

    try {
      // تحديث المعلومات الشخصية
      if (_isProfileDataChanged()) {
        await sl<ProfileCubit>().updateProfile(
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
        );
        dataChanged = true;
      }

      // تغيير كلمة المرور
      if (_isPasswordChangeRequested()) {
        await sl<ProfileCubit>().changePassword(
          newPassword: newPasswordController.text,
          confirmPassword: confirmPasswordController.text,
        );
        dataChanged = true;
      }

      if (dataChanged) {
        await sl<ProfileCubit>().loadProfile();
        _showSuccessMessage(context);
        _clearPasswordFields();
      } else {
        _showNoChangesMessage(context);
      }
    } catch (e) {
      _showErrorMessage(context, e.toString());
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
        ) == null;
  }

  bool _isProfileDataChanged() {
    return nameController.text != profile.name ||
        emailController.text != profile.email ||
        phoneController.text != profile.phone;
  }

  bool _isPasswordChangeRequested() {
    return //currentPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool get isPasswordsMatch => 
      !_isPasswordChangeRequested() || // إذا لم يتم إدخال كلمات مرور أصلاً
      (newPasswordController.text == confirmPasswordController.text); // أو إذا كانت متطابقة

  void _clearPasswordFields() {
  //  currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void _showSuccessMessage(BuildContext context) {
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