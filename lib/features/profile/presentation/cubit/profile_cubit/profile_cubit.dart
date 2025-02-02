import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/features/profile/domain/repositories/profile_repository.dart';
import 'profile_state.dart';
import 'dart:io';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  ProfileModel? _profile; // تخزين آخر بيانات

  ProfileCubit({required this.repository}) : super(ProfileInitial()) {
    // تحميل البيانات عند إنشاء الـ cubit
    loadProfile();
  }

  ProfileModel? get currentProfile => _profile;

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());
      final result = await repository.getProfile();
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (profile) {
          _profile = profile; // تحديث البيانات المخزنة
          emit(ProfileLoaded(profile));
        },
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    try {
      emit(ProfileLoading());
      final result = await repository.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );
      
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (profile) {
          _profile = profile; // تحديث البيانات المخزنة
          emit(ProfileLoaded(profile));
        },
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      loadProfile(); // إعادة تحميل في حالة الخطأ
    }
  }

  Future<void> changePassword({
  //  required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      emit(ProfileLoading());
      final result = await repository.changePassword(
 //       currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (_) => loadProfile(), // تحديث البيانات بعد تغيير كلمة المرور
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      loadProfile();
    }
  }

  Future<void> updateAvatar(File image) async {
    try {
      emit(ProfileLoading());
      final result = await repository.updateAvatar(image);
      
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (_) => loadProfile(), // تحديث البيانات بعد تغيير الصورة
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      loadProfile();
    }
  }

  Future<void> updateAddress({
    required int cityId,
    required int stateId,
  }) async {
    try {
      emit(ProfileLoading());
      final result = await repository.updateAddress(
        cityId: cityId,
        stateId: stateId,
      );
      
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (profile) {
          _profile = profile;
          emit(ProfileLoaded(profile));
        },
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      loadProfile();
    }
  }
} 