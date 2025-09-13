import 'package:dio/dio.dart';
import 'constants.dart';

class APIClient {
  final Dio _dio;
  final Duration timeout;

  APIClient({Dio? dio, this.timeout = const Duration(seconds: 60)})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: timeout, // Duration directly
              receiveTimeout: timeout, // Duration directly
              responseType: ResponseType.json,
              headers: {'Content-Type': 'application/json'},
            ),
          );

  String _build(String path) => '${EndPoints.baseUrl}$path';

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        _build(path),
        data: body,
        options: Options(headers: headers),
      );
      return _process(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        _build(path),
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _process(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Map<String, dynamic> _process(Response resp) {
    final code = resp.statusCode ?? 0;
    if (code >= 200 && code < 300) {
      if (resp.data == null) return {};
      return Map<String, dynamic>.from(resp.data);
    } else {
      String message = resp.data != null && resp.data['message'] != null
          ? resp.data['message']
          : 'HTTP $code';
      throw APIException(code, message);
    }
  }

  APIException _handleDioException(DioException e) {
    if (e.response != null) {
      final code = e.response?.statusCode ?? 0;
      final message =
          e.response?.data != null && e.response!.data['message'] != null
          ? e.response!.data['message']
          : e.message ?? 'Unknown error';
      return APIException(code, message);
    } else {
      return APIException(-1, e.message ?? 'Unknown error');
    }
  }
}

class APIException implements Exception {
  final int code;
  final String message;

  APIException(this.code, this.message);

  @override
  String toString() => 'APIException($code): $message';
}
