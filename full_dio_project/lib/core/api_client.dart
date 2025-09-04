import 'package:dio/dio.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';

class ApiClient {
  final Dio _dio;
  final AppLogger _logger; // <- changed to AppLogger

  ApiClient(String githubToken, this._logger)
    : _dio = Dio(
        BaseOptions(
          baseUrl: "https://api.github.com",
          headers: {
            "Authorization": "token $githubToken",
            "Accept": "application/vnd.github.v3+json",
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i("➡️ [REQUEST] ${options.method} ${options.uri}");
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i("✅ [RESPONSE] ${response.statusCode} ${response.realUri}");
          handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.type == DioExceptionType.connectionError) {
            _logger.e("❌ [NO INTERNET] ${e.message}");
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: "No Internet Connection",
                type: DioExceptionType.connectionError,
              ),
            );
          }

          if (e.response != null) {
            final errorData = e.response?.data;
            final message = errorData is Map ? errorData['message'] : e.message;
            _logger.w("⚠️ [API ERROR] ${e.response?.statusCode} - $message");
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                message: "Error ${e.response?.statusCode}: $message",
                error: "Error ${e.response?.statusCode}: $message",
                response: e.response,
              ),
            );
          }

          _logger.e("❌ [UNKNOWN ERROR] ${e.message}");
          handler.next(e);
        },
      ),
    );
  }

  // Fetch a user's repositories
  Future<List<dynamic>> getUserRepos(String username) async {
    final res = await _dio.get("/users/$username/repos");
    return res.data;
  }

  // Fetch a user's profile info
  Future<Map<String, dynamic>> getUserInfo(String username) async {
    final res = await _dio.get("/users/$username");
    return res.data;
  }
}
