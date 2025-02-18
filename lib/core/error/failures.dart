abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('لا يوجد اتصال بالإنترنت');
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(String message) : super(message);
}
