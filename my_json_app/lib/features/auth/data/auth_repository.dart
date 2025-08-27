

import 'package:my_json_app/features/auth/domain/user_entity.dart';
import 'package:my_json_app/features/user/data/user_reposotory.dart';

class AuthRepository {
  final UserRepository _userRepository = UserRepository();

  /// Returns:
  /// - UserEntity on success
  /// - null if email not found
  /// - id = -1 marker in UserEntity if password wrong
  Future<UserEntity?> login(String email, String password) async {
    final user = await _userRepository.getUserByEmail(email);
    if (user == null) return null;

    final storedPassword = await _userRepository.getPasswordByEmail(email);
    if (storedPassword == password) {
      return user; // success
    } else {
      return UserEntity(id: -1, name: user.name, email: user.email); // wrong password marker
    }
  }

  Future<bool> checkEmailExists(String email) async {
    final user = await _userRepository.getUserByEmail(email);
    return user != null;
  }
}
