import 'package:equatable/equatable.dart';

class ChangePasswordModel extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String passwordConfirmation;

  const ChangePasswordModel({
    required this.currentPassword,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': passwordConfirmation,
    };
  }

  @override
  List<Object?> get props => [currentPassword, newPassword, passwordConfirmation];
}

class ChangePasswordValidationError extends Equatable {
  final List<String>? currentPassword;
  final List<String>? newPassword;
  final List<String>? passwordConfirmation;

  const ChangePasswordValidationError({
    this.currentPassword,
    this.newPassword,
    this.passwordConfirmation,
  });

  factory ChangePasswordValidationError.fromJson(Map<String, dynamic> json) {
    return ChangePasswordValidationError(
      currentPassword: json['current_password']?.cast<String>(),
      newPassword: json['new_password']?.cast<String>(),
      passwordConfirmation: json['password_confirmation']?.cast<String>(),
    );
  }

  bool get hasErrors => currentPassword != null || 
                       newPassword != null || 
                       passwordConfirmation != null;

  String? get firstError {
    if (currentPassword?.isNotEmpty ?? false) return currentPassword!.first;
    if (newPassword?.isNotEmpty ?? false) return newPassword!.first;
    if (passwordConfirmation?.isNotEmpty ?? false) return passwordConfirmation!.first;
    return null;
  }

  @override
  List<Object?> get props => [currentPassword, newPassword, passwordConfirmation];
}
