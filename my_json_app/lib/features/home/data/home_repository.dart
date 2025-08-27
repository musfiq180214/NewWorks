import '../../auth/domain/user_entity.dart';

class HomeRepository {
  Future<UserEntity> getUserProfile(UserEntity user) async {
    // In real apps, call backend with token/userId here
    return user;
  }
}
