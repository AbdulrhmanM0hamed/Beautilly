import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/Home/presentation/cubit/profile_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/profile_state.dart';
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
  late final EditProfileController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = EditProfileController(widget.profile);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ProfileCubit>(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: _handleStateChanges,
        child: Stack(
          children: [
            if (!_isLoading) _buildContent(),
            if (_isLoading) _buildLoadingIndicator(),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ProfileState state) {
    if (state is ProfileLoading) {
      setState(() => _isLoading = true);
    } else {
      setState(() => _isLoading = false);
      if (state is ProfileError) {
        CustomSnackbar.showError(
          context: context,
          message: state.message,
        );
      }
    }
  }

  Widget _buildContent() {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'تعديل المعلومات الشخصية',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            EditProfileForm(
              profile: widget.profile,
              formKey: _controller.formKey,
              nameController: _controller.nameController,
              emailController: _controller.emailController,
              phoneController: _controller.phoneController,
            ),
            const SizedBox(height: 16),
            ChangePasswordForm(
              currentPasswordController: _controller.currentPasswordController,
              newPasswordController: _controller.newPasswordController,
              confirmPasswordController: _controller.confirmPasswordController,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () => _controller.updateProfile(context),
                text: 'حفظ التغييرات',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Scaffold(
      body: Center(
        child: CustomProgressIndcator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
