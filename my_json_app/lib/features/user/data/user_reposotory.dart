
import 'package:my_json_app/data/users_data.dart';
import 'package:my_json_app/features/auth/domain/user_entity.dart';

class UserRepository {
  Future<UserEntity?> getUserByEmail(String email) async {
    for (var u in usersData) {
      if (u['email'] == email) {
        return UserEntity.fromJson(u);
      }
    }
    return null;
  }

  Future<String?> getPasswordByEmail(String email) async {
    for (var u in usersData) {
      if (u['email'] == email) {
        return u['password'] as String;
      }
    }
    return null;
  }
}
