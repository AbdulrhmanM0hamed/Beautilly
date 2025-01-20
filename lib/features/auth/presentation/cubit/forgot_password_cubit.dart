import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';
import 'package:beautilly/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository) : super(ForgotPasswordInitial());

  Future<void> forgotPassword(String email) async {
    emit(ForgotPasswordLoading());
    
    final result = await _authRepository.forgotPassword(email);
    
    result.fold(
      (failure) => emit(ForgotPasswordError(failure.message)),
      (message) => emit(ForgotPasswordSuccess(message)),
    );
  }

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ForgotPasswordLoading());
    
    final result = await _authRepository.resetPassword(
      token: token,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    
    result.fold(
      (failure) => emit(ForgotPasswordError(failure.message)),
      (message) => emit(ForgotPasswordSuccess(message)),
    );
  }
} 