import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/cache/cache_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final CacheService _cacheService;

  AuthCubit(this.authRepository, this._cacheService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    
    final result = await authRepository.login(email, password);
    
    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (data) {
        _cacheService.saveToken(data['token'] ?? '');
        emit(AuthSuccess(
          user: data['user'],
          token: data['token'] ?? '',
          message: data['message'] ?? 'تم تسجيل الدخول بنجاح',
        ));
      },
    );
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
}
