import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../domain/usecases/logout.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final CacheService _cacheService;
  final Logout _logout;

  AuthCubit(this.authRepository, this._cacheService)
      : _logout = Logout(authRepository),
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    try {
      final result = await authRepository.login(email, password);
      
      result.fold(
        (failure) {
          print('Debug - Login Error: ${failure.message}');
          emit(AuthError(failure.message));
        },
        (data) async {
          final token = data['token'] as String;
          print('Debug - Login Success:');
          print('Token: $token');
          print('User: ${data['user']}');
          
          // حفظ التوكن
          await _cacheService.saveToken(token);
          
          // التحقق من حفظ التوكن
          final savedToken = await _cacheService.getToken();
          print('Debug - Saved Token: $savedToken');
          
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
      print('Debug - Unexpected Error: $e');
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
    emit(AuthLoading());
    
    final result = await _logout();
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        _cacheService.clearCache();
        emit(AuthInitial());
      },
    );
  }
}
