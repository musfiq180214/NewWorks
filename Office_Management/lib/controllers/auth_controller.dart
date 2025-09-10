import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers/auth_repository.dart';
import '../utils/storage.dart';

// State class for Auth
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

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final resp = await repo.login(email, password);
      final userJson = resp['user'] ?? resp;
      final token = resp['token'] ?? resp['access_token'] ?? userJson['token'];
      final user = User.fromJson({...userJson, 'token': token ?? ''});
      if (token != null) await Storage.saveToken(token);
      state = state.copyWith(user: user, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> logout() async {
    await Storage.clear();
    state = AuthState();
  }
}

// Riverpod provider for AuthRepository and AuthController
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    return AuthController(repo: repo);
  },
);
