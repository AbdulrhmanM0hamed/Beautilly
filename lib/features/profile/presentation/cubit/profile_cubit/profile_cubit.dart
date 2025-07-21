import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:beautilly/features/splash/view/splash_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/features/profile/domain/repositories/profile_repository.dart';
import 'profile_state.dart';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  final CacheService cacheService;
  ProfileModel? _profile;
  bool _isGuest = false;

  ProfileCubit({
    required this.repository,
    required this.cacheService,
  }) : super(ProfileInitial()) {
    _initGuestStatus();
  }

  bool get isGuestUser => _isGuest;

  Future<void> _initGuestStatus() async {
    _isGuest = await cacheService.isGuestMode();
    emit(ProfileInitial()); // إعادة تهيئة الحالة
    loadProfile();
  }

  ProfileModel? get currentProfile => _profile;

  Future<void> loadProfile() async {
    if (isClosed) return;

    try {
      emit(ProfileLoading());
      _isGuest = await cacheService.isGuestMode(); // تحديث حالة الزائر قبل تحميل الملف الشخصي

      final result = await repository.getProfile();

      if (isClosed) {
        return;
      }

      result.fold(
        (failure) {
          emit(ProfileError(failure.message));
        },
        (profile) {
          _profile = profile;
          emit(ProfileLoaded(profile));
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(const ProfileError('حدث خطأ في تحميل البيانات'));
      }
    }
  }

  void clearProfile() {
    _profile = null;
    _isGuest = false;
    cacheService.setGuestMode(false);
    if (!isClosed) {
      emit(ProfileInitial());
    }
  }

  // دالة مساعدة للتنقل الآمن
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

      if (isClosed) return;

      result.fold(
        (failure) {
          emit(ProfileError(failure.message));
          loadProfile();
        },
        (profile) {
          _profile = profile;
          emit(const ProfileSuccess('تم تحديث البيانات بنجاح'));

          // استخدام التنقل الآمن
          Future.delayed(const Duration(seconds: 2), _navigateToSplash);

          emit(ProfileLoaded(profile));
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(e.toString()));
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

      if (isClosed) return;

      result.fold(
        (failure) {
          emit(ProfileError(failure.message));
        },
        (message) {
          emit(ProfileSuccess(message));

          // نتأكد من أن الـ cubit لم يتم إغلاقه
          if (!isClosed) {
            // استخدام التنقل الآمن بعد النجاح فقط
            Future.delayed(const Duration(seconds: 2), _navigateToSplash);
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(const ProfileError('حدث خطأ في تغيير كلمة المرور'));
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
    if (isClosed) {
      return;
    }

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
          Future.delayed(const Duration(seconds: 2), () {
            // إعادة فتح التطبيق من Splash
            Navigator.of(GetIt.I<GlobalKey<NavigatorState>>().currentContext!)
                .pushNamedAndRemoveUntil(
              SplashView.routeName,
              (route) => false,
            );
          });

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
