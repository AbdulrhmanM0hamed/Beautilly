import 'package:beautilly/core/services/service_locator.dart';
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
  late EditProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = EditProfileController(widget.profile);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => 
          current is ProfileSuccess || current is ProfileError,
        listener: (context, state) {
          if (state is ProfileSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
            // مسح حقول كلمة المرور فقط عند نجاح تغيير كلمة المرور
            if (state.message.contains('كلمة المرور')) {
              controller.clearPasswordFields();
            }
          } else if (state is ProfileError) {
            CustomSnackbar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
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
                          profile: widget.profile,
                          nameController: controller.nameController,
                          emailController: controller.emailController,
                          phoneController: controller.phoneController,
                        ),
                        const SizedBox(height: 16),
                        ChangePasswordForm(
                          currentPasswordController: controller.currentPasswordController,
                          newPasswordController: controller.newPasswordController,
                          confirmPasswordController: controller.confirmPasswordController,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressed: state is! ProfileLoading 
                              ? () => controller.updateProfile(context)
                              : null,
                            text: 'حفظ التغييرات',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is ProfileLoading)
                  Container(
                    color: Colors.black.withOpacity(0.1),
                    child: const Center(
                      child: CustomProgressIndcator(color: AppColors.primary),
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
