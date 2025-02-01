import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:beautilly/features/profile/presentation/view/edit_profile/widgets/section_title.dart';
import 'package:beautilly/features/profile/presentation/view/widgets/custom_profile_field.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  final ProfileModel profile;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const EditProfileForm({
    super.key,
    required this.profile,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
     
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'المعلومات الشخصية',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          CustomProfileField(
            controller: nameController,
            label: 'الاسم',
            hint: 'أدخل اسمك',
            prefixIcon: Icons.person_outline,
            validator: FormValidators.validateName,
          ),
          const SizedBox(height: 2),
          CustomProfileField(
            controller: emailController,
            label: 'البريد الإلكتروني',
            hint: 'أدخل بريدك الإلكتروني',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
          ),
          const SizedBox(height: 2),
          CustomProfileField(
            controller: phoneController,
            label: 'رقم الهاتف',
            hint: 'أدخل رقم هاتفك',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: FormValidators.validatePhone,
          ),
        ],
      ),
    );
  }
}
