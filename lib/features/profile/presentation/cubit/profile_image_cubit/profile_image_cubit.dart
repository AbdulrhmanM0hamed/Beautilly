import 'dart:io';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/splash/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/profile_repository.dart';
import 'profile_image_state.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  final ProfileRepository repository;

  ProfileImageCubit({required this.repository}) : super(ProfileImageInitial());

  Future<void> updateProfileImage(File image) async {
    if (isClosed) return;

    try {
      emit(ProfileImageLoading());

      final result = await repository.updateAvatar(image);

      if (isClosed) return;

      result.fold(
        (failure) => emit(ProfileImageError(failure.message)),
        (success) {
          emit(ProfileImageSuccess(
              imageUrl: success, message: 'تم تحديث الصورة بنجاح'));
          // تحديث البيانات في ProfileCubit
          if (!GetIt.I<ProfileCubit>().isClosed) {
            GetIt.I<ProfileCubit>().loadProfile();
          }
          Future.delayed(const Duration(seconds: 2), _navigateToSplash);
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(const ProfileImageError('حدث خطأ في تحديث الصورة'));
      }
    }
  }

  void _navigateToSplash() {
    try {
      final context = GetIt.I<GlobalKey<NavigatorState>>().currentContext;
      if (context != null && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              SplashView.routeName,
              (route) => false,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error navigating to splash: $e');
    }
  }

  Future<void> pickImage() async {
    if (isClosed) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null && !isClosed) {
        await updateProfileImage(File(image.path));
      }
    } catch (e) {
      if (!isClosed) {
        emit(const ProfileImageError('حدث خطأ في اختيار الصورة'));
      }
    }
  }
}
