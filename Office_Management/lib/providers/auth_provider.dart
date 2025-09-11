import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/data/auth_repository.dart';
import '../domain/user.dart';
import '../utils/storage.dart';

/// State class for Auth
class AuthState {
  final bool loading;
  final User? user;
  final String? error;

  AuthState({this.loading = false, this.user, this.error});

  AuthState copyWith({bool? loading, User? user, String? error}) => AuthState(
    loading: loading ?? this.loading,
    user: user ?? this.user,
    error: error,
  );
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository repo;

  AuthController({required this.repo}) : super(AuthState());

  /// Login using User model
  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await repo.login(email, password);

      // Save token locally
      await Storage.saveToken(user.token);

      // Update state
      state = state.copyWith(user: user, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Logout
  Future<void> logout() async {
    await repo.logout();
    await Storage.clear();
    state = AuthState();
  }
}

/// Riverpod provider for AuthRepository and AuthController
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    return AuthController(repo: repo);
  },
);
