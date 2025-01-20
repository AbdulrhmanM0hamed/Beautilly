abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final dynamic user;
  final String token;
  final String message;

  AuthSuccess({
    required this.user,
    required this.token,
    required this.message,
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
