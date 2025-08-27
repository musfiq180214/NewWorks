import 'package:flutter/material.dart';
import 'package:my_json_app/features/auth/domain/user_entity.dart';
import '../data/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final _repo = AuthRepository();
  UserEntity? _user;
  bool _isLoading = false;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;

  /// Returns null on success, or error message string
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _repo.login(email, password);

    _isLoading = false;

    if (result == null) {
      notifyListeners();
      return "No registered user found.";
    }

    if (result.id == -1) {
      notifyListeners();
      return "Incorrect password.";
    }

    _user = result;
    notifyListeners();
    return null;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
