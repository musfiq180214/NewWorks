// import '../core/api_client.dart';
// import '../core/constants.dart';

// class AuthRepository {
//   final APIClient api;
//   AuthRepository({APIClient? apiClient}) : api = apiClient ?? APIClient();

//   Future<Map<String, dynamic>> login(String email, String password) async {
//     return await api.post(
//       EndPoints.loginPath,
//       body: {'email': email, 'password': password},
//     );
//   }
// }

// auth_repository.dart
import '../domain/user.dart';

class AuthRepository {
  // Dummy login using User model
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    // Only allow dummy user
    if (email == 'admin@gmail.com' && password == 'admin') {
      // Return a User object
      return User(
        id: '1',
        name: 'admin',
        email: 'admin@gmail.com',
        token: 'dummy-token-123',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  // For future logout/token clearing
  Future<void> logout() async {
    // Normally clear token from storage
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
