import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/core/provider/user_profile_provider.dart';
import 'package:tempproject/data/user_repository.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;

  const RegisterState({this.status = RegisterStatus.initial, this.errorMessage});

  RegisterState copyWith({RegisterStatus? status, String? errorMessage}) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(UserRepository(), ref), // <-- pass ref as 2nd argument
);


class RegisterNotifier extends StateNotifier<RegisterState> {
  final UserRepository _userRepository;
  final Ref _ref; // Add Ref

  RegisterNotifier(this._userRepository, this._ref) : super(const RegisterState());

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String contact,
    required int age,
  }) async {
    state = state.copyWith(status: RegisterStatus.loading, errorMessage: null);

    // Basic validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      state = state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: "Invalid email",
      );
      return;
    }

    if (password.length < 6) {
      state = state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: "Password must be at least 6 characters",
      );
      return;
    }

    if (name.isEmpty || contact.isEmpty || age <= 0) {
      state = state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: "Please fill all fields correctly",
      );
      return;
    }

    final success = _userRepository.registerUser(
      email: email,
      password: password,
      name: name,
      contact: contact,
      age: age,
    );

    if (success) {
      // ✅ Update UserProfile
      final user = _userRepository.getUserByEmail(email);
      if (user != null) {
        _ref.read(userProfileProvider.notifier).setUser(user);
      }

      state = state.copyWith(status: RegisterStatus.success);
    } else {
      state = state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: "Email already exists",
      );
    }
  }
}