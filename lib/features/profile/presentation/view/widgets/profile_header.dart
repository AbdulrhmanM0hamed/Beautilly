import 'dart:io';

import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_image_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_image_state.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/profile_model.dart';
import '../../../../Home/presentation/cubit/profile_cubit.dart';
import '../../../../Home/presentation/cubit/profile_state.dart';

import 'package:image_picker/image_picker.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileImageCubit>(),
      child: BlocConsumer<ProfileImageCubit, ProfileImageState>(
        listener: (context, state) {
          if (state is ProfileImageSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
            // تحديث الـ profile cubit لتحديث الواجهة
            context.read<ProfileCubit>().loadProfile();
          } else if (state is ProfileImageError) {
            CustomSnackbar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, imageState) {
          return MultiBlocListener(
            listeners: [
              BlocListener<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileLoaded) {
                    // تم تحديث البيانات
                    setState(() {}); // إعادة بناء الواجهة
                  }
                },
              ),
            ],
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (state is ProfileLoaded) {
                  final profile = state.profile;
                  return _buildProfileInfo(context, profile, imageState);
                }

                if (state is ProfileError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                return const SizedBox(); // حالة ProfileInitial
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, ProfileModel profile,
      ProfileImageState imageState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 90, 90, 90).withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // الصورة الشخصية
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: profile.image != null && profile.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: profile.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primary,
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      if (context.mounted) {
                        context.read<ProfileImageCubit>().updateProfileImage(
                              File(image.path),
                            );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: imageState is ProfileImageLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الاسم
          Text(
            profile.name,
            style: getBoldStyle(
              fontSize: FontSize.size20,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 8),

          // البريد الإلكتروني
          Text(
            profile.email,
            style: getMediumStyle(
              color: AppColors.grey,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),

          // رقم الهاتف
          if (profile.phone != null)
            Text(
              profile.phone!,
              style: getMediumStyle(
                color: AppColors.grey,
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
              ),
            ),

          const SizedBox(height: 4),

          // الموقع
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                '${profile.city.name}، ${profile.state.name}',
                style: getMediumStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
