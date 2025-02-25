import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_state.dart';
import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:beautilly/features/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:beautilly/features/profile/presentation/view/edit_profile/widgets/change_password_form.dart';
import 'package:beautilly/features/profile/presentation/view/edit_profile/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    try {
      final cubit = context.read<ProfileCubit>();

      // تحميل البيانات مباشرة
      await cubit.loadProfile();

      if (!mounted) return;

      // التحقق من الحالة
      final currentState = cubit.state;

      if (currentState is ProfileLoaded) {
        setState(() => _isLoading = false);
      } else if (currentState is ProfileError) {
        CustomSnackbar.showError(
          context: context,
          message: currentState.message,
        );
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context: context,
          message: 'حدث خطأ في تحميل البيانات',
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        
        if (state is ProfileSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: state.message,
          );
        } else if (state is ProfileError) {
          Future.microtask(() {
            if (mounted && context.mounted) {
              CustomSnackbar.showError(
                context: context,
                message: state.message,
              );
            }
          });
          setState(() => _isLoading = false);
        }
      },
      builder: (context, state) {

        if (state is ProfileInitial || _isLoading || state is ProfileLoading) {
          return const Scaffold(
            appBar: CustomAppBar(
              title: 'تعديل المعلومات الشخصية',
            ),
            body: Center(
              child: CustomProgressIndcator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        // استخدام البيانات المحملة أو البيانات الأصلية
        final profile = (state is ProfileLoaded) ? state.profile : widget.profile;
        final controller = EditProfileController(profile);

        return Scaffold(
          appBar: const CustomAppBar(
            title: 'تعديل المعلومات الشخصية',
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      EditProfileForm(
                        profile: profile,
                        nameController: controller.nameController,
                        emailController: controller.emailController,
                        phoneController: controller.phoneController,
                      ),
                      const SizedBox(height: 16),
                      ChangePasswordForm(
                        currentPasswordController:
                            controller.currentPasswordController,
                        newPasswordController:
                            controller.newPasswordController,
                        confirmPasswordController:
                            controller.confirmPasswordController,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: state is! ProfileLoading
                              ? () {
                                  setState(() => _isLoading = true);
                                  controller.updateProfile(context);
                                }
                              : null,
                          text: 'حفظ التغييرات',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is ProfileLoading)
                const Center(
                  child: CustomProgressIndcator(
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
