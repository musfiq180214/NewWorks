import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/login_model.dart';
import '../../../core/provider/is_logged_in_provider.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final Ref ref;
  LoginNotifier(this.ref) : super(LoginState());

  void login(String email, String password) async {
    state = state.copyWith(status: LoginStatus.loading);

    await Future.delayed(const Duration(seconds: 1)); // simulate network

    // Hardcoded user
    if (email == "musfiq677@gmail.com" && password == "11111111") {
      state = state.copyWith(status: LoginStatus.success);
      ref.read(isLoggedInProvider.notifier).state = true; // update global login
    } else {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: "Invalid credentials",
      );
    }
  }

  void logout() {
    ref.read(isLoggedInProvider.notifier).state = false;
    state = LoginState();
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});
