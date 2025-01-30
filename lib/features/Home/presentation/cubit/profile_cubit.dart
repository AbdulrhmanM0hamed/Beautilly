import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/features/profile/domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    
    final result = await repository.getProfile();
    
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    try {
      final result = await repository.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );
      
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (profile) => emit(ProfileLoaded(profile)),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final result = await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (message) => loadProfile(),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
} 