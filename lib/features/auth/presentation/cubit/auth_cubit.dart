import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await authRepository.login(email, password);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (data) => emit(AuthSuccess(
        user: data['user'],
        token: data['token'],
        message: data['message'],
      )),
    );
  }

  Future<void> register(Map<String, dynamic> userData) async {
    emit(AuthLoading());

    final result = await authRepository.register(userData);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (data) => emit(AuthSuccess(
        user: data['user'],
        token: data['token'],
        message: data['message'],
      )),
    );
  }
}
