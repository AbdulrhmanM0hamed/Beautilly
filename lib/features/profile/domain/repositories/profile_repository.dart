import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/profile_model.dart';
import 'dart:io';

abstract class ProfileRepository {
  // جلب بيانات الملف الشخصي
  Future<Either<Failure, ProfileModel>> getProfile();

  // تحديث الصورة الشخصية
  Future<Either<Failure, String>> updateAvatar(File image);

  // تحديث البيانات الشخصية
  Future<Either<Failure, ProfileModel>> updateProfile({
    String? name,
    String? email,
    String? phone,
  });

  // تحديث العنوان
  Future<Either<Failure, ProfileModel>> updateAddress({
    required int cityId,
    required int stateId,
  });

  // تغيير كلمة المرور
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  // تحديث إعدادات الإشعارات
  Future<Either<Failure, bool>> updateNotificationSettings({
    required bool enabled,
  });

  // التحقق من البريد الإلكتروني
  Future<Either<Failure, String>> verifyEmail();

  // إعادة إرسال رمز التحقق
  Future<Either<Failure, String>> resendVerificationCode();

  // حذف الحساب
  Future<Either<Failure, String>> deleteAccount({
    required String password,
  });
} 