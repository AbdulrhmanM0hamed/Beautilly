import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/features/profile/domain/repositories/profile_repository.dart';
import 'profile_state.dart';
import 'dart:io';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  ProfileModel? _profile; // تخزين آخر بيانات

  ProfileCubit({required this.repository}) : super(ProfileInitial()) {
    // لا نحتاج إلى تحميل البيانات عند إنشاء الـ cubit
    // loadProfile();
  }

  ProfileModel? get currentProfile => _profile;

  Future<void> loadProfile() async {
    if (isClosed) return;

    try {
      emit(ProfileLoading());
      final result = await repository.getProfile();
      if (isClosed) return;

      result.fold(
        (failure) {
          emit(ProfileError(failure.message));
          // في حالة الفشل، نعيد المحاولة بعد ثانية واحدة
          Future.delayed(const Duration(seconds: 1), () {
            if (!isClosed) loadProfile();
          });
        },
        (profile) {
          if (profile.name != null && profile.name.isNotEmpty) {
            _profile = profile;
            emit(ProfileLoaded(profile));
          } else {
            emit(ProfileError('بيانات الملف الشخصي غير صالحة'));
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(e.toString()));
        // في حالة الخطأ، نعيد المحاولة بعد ثانية واحدة
        Future.delayed(const Duration(seconds: 1), () {
          if (!isClosed) loadProfile();
        });
      }
    }
  }

  void clearProfile() {
    _profile = null;
    if (!isClosed) {
      emit(ProfileInitial());
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (isClosed) return;

    try {
      emit(ProfileLoading());

      final result = await repository.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );

      result.fold(
        (failure) {
          emit(ProfileError(failure.message));
          // إعادة تحميل البيانات بعد الخطأ
          loadProfile();
        },
        (profile) {
          _profile = profile;
          emit(const ProfileSuccess('تم تحديث البيانات بنجاح'));
          emit(ProfileLoaded(profile));
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(e.toString()));
        // إعادة تحميل البيانات بعد الخطأ
        loadProfile();
      }
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (isClosed) return;

    try {
      emit(ProfileLoading());

      final result = await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      result.fold(
        (failure) {
          emit(ProfileError(failure.message));
          // إعادة تحميل البيانات بعد الخطأ لإظهار الحالة الصحيحة
          loadProfile();
        },
        (message) {
          emit(ProfileSuccess(message));
          // إعادة تحميل البيانات بعد النجاح
          loadProfile();
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(e.toString()));
        // إعادة تحميل البيانات بعد الخطأ
        loadProfile();
      }
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
      if (!isClosed) loadProfile(); // إعادة تحميل في حالة الخطأ
    }
  }

  Future<void> updateAddress({
    required int cityId,
    required int stateId,
  }) async {
    if (isClosed) return;

    try {
      emit(ProfileLoading());

      final result = await repository.updateAddress(
        cityId: cityId,
        stateId: stateId,
      );

      result.fold(
        (failure) {
          emit(ProfileError(failure.message));
        },
        (profile) {
          _profile = profile;
          emit(const ProfileSuccess('تم تحديث العنوان بنجاح'));
          emit(ProfileLoaded(profile));
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(e.toString()));
      }
    }
  }
}
