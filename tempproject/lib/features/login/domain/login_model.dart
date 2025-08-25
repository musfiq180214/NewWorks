// login_model.dart
enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;      // general (e.g., wrong credentials)
  final String? emailError;        // field-level error for email
  final String? passwordError;     // field-level error for password

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.emailError,
    this.passwordError,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? emailError,
    String? passwordError,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  /// Convenient helper to clear all errors
  LoginState clearedErrors() => copyWith(
        errorMessage: null,
        emailError: null,
        passwordError: null,
      );
}
