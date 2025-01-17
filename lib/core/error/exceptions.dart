class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message = 'لا يوجد اتصال بالإنترنت';
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);
}

// رسائل الخطأ العربية
class AuthExceptions {
  static const String invalidEmail = 'البريد الإلكتروني غير صالح';
  static const String invalidPassword =
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
  static const String emptyField = 'هذا الحقل مطلوب';
  static const String loginFailed = 'فشل تسجيل الدخول';
  static const String registerFailed = 'فشل إنشاء الحساب';
  static const String userNotFound = 'المستخدم غير موجود';
  static const String wrongPassword = 'كلمة المرور غير صحيحة';
  static const String emailAlreadyInUse = 'البريد الإلكتروني مستخدم بالفعل';
  static const String weakPassword = 'كلمة المرور ضعيفة';
  static const String networkError = 'لا يوجد اتصال بالإنترنت';
  static const String serverError = 'حدث خطأ في الخادم';
  static const String unknownError = 'حدث خطأ غير متوقع';
}