import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/Home/presentation/cubit/profile_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/profile_model.dart';
import './widgets/custom_profile_field.dart';


class EditProfileView extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProfileCubit>(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
            
            if (state is ProfileLoaded) {
              // تحديث البيانات في الشاشة السابقة
              Navigator.pop(context, true);
            } else if (state is ProfileError) {
              CustomSnackbar.showError(
                context: context,
                message: state.message,
              );
            }
          }
        },
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(
                  'تعديل المعلومات الشخصية',
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size18,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('المعلومات الشخصية', Icons.person_outline),
                        const SizedBox(height: 16),
                        CustomProfileField(
                          controller: _nameController,
                          label: 'الاسم',
                          hint: 'أدخل اسمك',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الاسم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 2),
                        CustomProfileField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          hint: 'أدخل بريدك الإلكتروني',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'البريد الإلكتروني غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 2),
                        CustomProfileField(
                          controller: _phoneController,
                          label: 'رقم الهاتف',
                          hint: 'أدخل رقم هاتفك',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildSectionTitle('تغيير كلمة المرور', Icons.lock_outline),
                        const SizedBox(height: 24),
                        CustomProfileField(
                          controller: _currentPasswordController,
                          label: 'كلمة المرور الحالية',
                          hint: 'أدخل كلمة المرور الحالية',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 2),
                        CustomProfileField(
                          controller: _newPasswordController,
                          label: 'كلمة المرور الجديدة',
                          hint: 'أدخل كلمة المرور الجديدة',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 2),
                        CustomProfileField(
                          controller: _confirmPasswordController,
                          label: 'تأكيد كلمة المرور',
                          hint: 'أعد إدخال كلمة المرور الجديدة',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 8),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CustomProgressIndcator(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: _updateProfile,
        text: 'حفظ التغييرات',
      ),
    );
  }

  void _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // تحديث المعلومات الشخصية
    if (_nameController.text != widget.profile.name ||
        _emailController.text != widget.profile.email ||
        _phoneController.text != widget.profile.phone) {
      await context.read<ProfileCubit>().updateProfile(
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
          );
    }

    // تغيير كلمة المرور
    if (_currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      await context.read<ProfileCubit>().changePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
    }

    // تحديث البيانات في الـ cubit
    if (mounted) {
      context.read<ProfileCubit>().loadProfile();
    }
  }
}
