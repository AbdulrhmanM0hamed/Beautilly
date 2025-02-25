import 'package:beautilly/features/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../domain/usecases/logout.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final CacheService _cacheService;
  final Logout _logout;
  final ProfileCubit _profileCubit;

  AuthCubit(this.authRepository, this._cacheService, this._profileCubit)
      : _logout = Logout(authRepository),
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    try {
      final result = await authRepository.login(email, password);
      
      result.fold(
        (failure) {
          emit(AuthError(failure.message));
        },
        (data) async {
          final token = data['token'] as String;

          
          // حفظ التوكن
          await _cacheService.saveToken(token);
          
          // التحقق من حفظ التوكن
          final savedToken = await _cacheService.getToken();
          
          if (savedToken != token) {
            emit(AuthError('خطأ في حفظ بيانات الجلسة'));
            return;
          }
          
          emit(AuthSuccess(
            user: data['user'],
            token: token,
            message: data['message'] ?? 'تم تسجيل الدخول بنجاح',
          ));
        },
      );
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    emit(AuthLoading());

    final result = await authRepository.register(userData);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (data) {
        if (data['token'] != null) {
          _cacheService.saveToken(data['token']);
        }
        emit(AuthSuccess(
          user: data['user'],
          token: data['token'] ?? '',
          message: data['message'] ?? 'تم التسجيل بنجاح',
        ));
      },
    );
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());
      final result = await _logout.call();

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) {
          GetIt.I<EditProfileController>().clearControllers();
          GetIt.I<ProfileCubit>().clearProfile();
          emit(AuthInitial());
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void handleAuthError(String message) {
    if (message.contains('انتهت صلاحية الجلسة') || 
        message.contains('الرجاء إعادة تسجيل الدخول')) {
      logout();
      // يمكنك إضافة توجيه المستخدم لشاشة تسجيل الدخول هنا
    }
    emit(AuthError(message));
  }
}
