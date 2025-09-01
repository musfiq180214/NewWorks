import 'package:apiflutter/domain/usecase/check_user_exists.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final CheckUserExists checkUserExistsUseCase;

  LoginProvider({required this.checkUserExistsUseCase});

  bool _loading = false;
  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> login(String username) async {
    loading = true;
    try {
      final exists = await checkUserExistsUseCase(username);
      loading = false;
      return exists;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }
}
