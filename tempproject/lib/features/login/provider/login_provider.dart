import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/core/provider/user_profile_provider.dart';
import 'package:tempproject/data/user_repository.dart';
import '../domain/login_model.dart';
import '../../../core/provider/is_logged_in_provider.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final Ref ref;
  final UserRepository userRepository;
  String? _loggedInEmail; // store logged-in email

  LoginNotifier(this.ref, this.userRepository) : super(const LoginState());

  static final _emailRegex =
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');

  bool _validate(String email, String password) {
    String? emailError;
    String? passwordError;

    if (email.trim().isEmpty) {
      emailError = 'Email is required';
    // ignore: curly_braces_in_flow_control_structures
    } else if (!_emailRegex.hasMatch(email.trim())) emailError = 'Enter a valid email address';
    if (password.isEmpty) {
      passwordError = 'Password is required';
    } else if (password.length < 8) passwordError = 'Password must be at least 8 characters';

    if (emailError != null || passwordError != null) {
      state = state.copyWith(
        status: LoginStatus.initial,
        errorMessage: null,
        emailError: emailError,
        passwordError: passwordError,
      );
      return false;
    }

    state = state.clearedErrors();
    return true;
  }

  void login(String email, String password) async {
    final ok = _validate(email, password);
    if (!ok) return;

    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);
    await Future.delayed(const Duration(seconds: 1));

    final success = userRepository.authenticate(email, password);

    if (success) {

      final user = userRepository.getUserByEmail(email)!;

      // Update UserProfileProvider
      ref.read(userProfileProvider.notifier).setUser(user);



      _loggedInEmail = email;
      state = state.copyWith(status: LoginStatus.success);
      ref.read(isLoggedInProvider.notifier).state = true;
    } else {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: "Invalid credentials",
      );
    }
  }

  String? get loggedInEmail => _loggedInEmail;

  void clearEmailError() {
    if (state.emailError != null) state = state.copyWith(emailError: null);
  }

  void clearPasswordError() {
    if (state.passwordError != null) state = state.copyWith(passwordError: null);
  }

  void logout() {
    _loggedInEmail = null;
    ref.read(isLoggedInProvider.notifier).state = false;
    state = const LoginState();
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final repo = UserRepository();
  return LoginNotifier(ref, repo);
});
