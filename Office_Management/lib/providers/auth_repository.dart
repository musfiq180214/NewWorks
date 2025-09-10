import '../core/api_client.dart';
import '../core/constants.dart';

class AuthRepository {
  final APIClient api;
  AuthRepository({APIClient? apiClient}) : api = apiClient ?? APIClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await api.post(
      EndPoints.loginPath,
      body: {'email': email, 'password': password},
    );
  }
}
