import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_image_state.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  final ProfileRepository repository;

  ProfileImageCubit(this.repository) : super(ProfileImageInitial());

  Future<void> updateProfileImage(File image) async {
    emit(ProfileImageLoading());
    
    final result = await repository.updateAvatar(image);
    
    result.fold(
      (failure) => emit(ProfileImageError(failure.message)),
      (imageUrl) => emit(ProfileImageSuccess(
        imageUrl: imageUrl,
        message: 'تم تحديث الصورة الشخصية بنجاح',
      )),
    );
  }
} 