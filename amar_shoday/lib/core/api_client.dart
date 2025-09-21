import 'dart:convert';

import 'package:amar_shoday/core/logger/app_logger.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  final AppLogger _logger; // <- changed to AppLogger

  ApiClient(this._logger)
      : _dio = Dio(
          BaseOptions(
            baseUrl: "https://api.github.com",
            headers: {
              // "Authorization": "token $githubToken",
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

  Future<List<dynamic>> getPublicRepos({
    int since = 0,
    int perPage = 20,
  }) async {
    final res = await _dio.get(
      "/repositories",
      queryParameters: {"since": since, "per_page": perPage},
    );
    return res.data;
  }

  Future<List<dynamic>> getRepoContents({
    required String owner,
    required String repo,
    String path = '',
  }) async {
    final res = await _dio.get("/repos/$owner/$repo/contents/$path");
    return res.data;
  }

  Future<String> getFileContent({
    required String owner,
    required String repo,
    required String path,
  }) async {
    try {
      final response = await _dio.get(
        '/repos/$owner/$repo/contents/$path',
        options: Options(
          headers: {
            // "Authorization": "token $githubToken",
            "Accept": "application/vnd.github.v3+json",
          },
        ),
      );

      final data = response.data;

      if (data['encoding'] == 'base64') {
        final contentEncoded = data['content'].replaceAll('\n', '');
        return utf8.decode(base64.decode(contentEncoded));
      } else {
        return data['content'] ?? '';
      }
    } catch (e) {
      rethrow; // let the UI handle the error
    }
  }

  // In your ApiClient class
  Future<Map<String, dynamic>> getAuthenticatedUser() async {
    final response = await _dio.get(
      'https://api.github.com/user', // GitHub endpoint for authenticated user
      options: Options(
        headers: {
          // 'Authorization': 'token $githubToken',
          'Accept': 'application/vnd.github.v3+json',
        },
      ),
    );

    return response.data as Map<String, dynamic>;
  }

  // Get all starred repos of authenticated user
  Future<List<dynamic>> getStarredRepos() async {
    final res = await _dio.get("/user/starred");
    return res.data;
  }

  // Star a repo
  Future<void> starRepo({required String owner, required String repo}) async {
    await _dio.put("/user/starred/$owner/$repo");
  }

  // Unstar a repo
  Future<void> unstarRepo({required String owner, required String repo}) async {
    await _dio.delete("/user/starred/$owner/$repo");
  }

  Future<List<dynamic>> searchRepos(
    String query, {
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      '/search/repositories',
      queryParameters: {'q': query, 'per_page': perPage, 'page': page},
    );
    return response.data['items'] as List<dynamic>;
  }
}
