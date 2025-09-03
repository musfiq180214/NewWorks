import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';

class LoginProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String _error = '';
  String get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late final ApiClient _apiClient;

  LoginProvider() {
    _apiClient = ApiClient(githubToken, AppLogger.getLogger("ApiClient"));
  }

  Future<void> login(String username) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Try fetching repos for username to verify if user exists
      await _apiClient.getUserRepos(username);
      _isAuthenticated = true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _error = "GitHub user not found.";
      } else if (e.type == DioExceptionType.connectionError) {
        _error = "No Internet Connection";
      } else {
        _error = "Error: ${e.message}";
      }
      _isAuthenticated = false;
    } catch (e) {
      _error = "Unexpected error: $e";
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
