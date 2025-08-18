import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:base_setup/core/constants/urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/core/navigation/app_navigator.dart';
import 'package:base_setup/core/service/internet_service.dart';
import 'package:base_setup/core/utils/logger.dart';

final dioProvider = Provider((ref) => ref.watch(apiClientProvider).dio);

final apiClientProvider = Provider<ApiClient>((ref) {
  final token =
      ""; // CAN WATCH FOR TOKEN HERE. LIKE : ref.watch(authTokenProvider);
  AppLogger.i("Token: $token");
  return ApiClient(token);
});

class ApiClient {
  final Dio _dio;

  ApiClient(String? token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: kDebugMode ? baseUrlDevelopment : baseUrlProduction,
            headers: token == null || token.isEmpty
                ? null
                : {'Authorization': 'Bearer $token'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final context = AppNavigator.navigatorKey.currentContext!;
          final container = ProviderScope.containerOf(context, listen: true);
          // Fetch the latest connectivity status from the cached provider
          final connectivityStatus = container.read(connectivityStatusProvider);

          if (connectivityStatus == ConnectivityResult.none) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }

          if (kDebugMode) {
            AppLogger.i('🔹 REQUEST: ${options.method} ${options.uri}');
            AppLogger.d('Headers: ${jsonEncode(options.headers)}');

            if (options.data is FormData) {
              final formDataMap = <String, dynamic>{};
              for (var field in (options.data as FormData).fields) {
                formDataMap[field.key] = field.value;
              }
              AppLogger.d('Form Fields: ${jsonEncode(formDataMap)}');

              for (var file in (options.data as FormData).files) {
                AppLogger.d('📎 File: ${file.key} => ${file.value.filename}');
              }
            } else if (options.data != null) {
              AppLogger.d('Body: ${_prettifyJson(options.data.toString())}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            AppLogger.i(
              '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
            );
            AppLogger.d('Response Body: ${_prettifyJson(response.data)}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
            AppLogger.e(
              '❌ ERROR: ${e.response?.statusCode} ${e.requestOptions.uri}',
            );
            AppLogger.d('Error Message: ${e.message}');
            if (e.response?.data != null) {
              AppLogger.d('Error Response: ${_prettifyJson(e.response?.data)}');
            }
          }

          if (e.response?.statusCode == 401) {
            AppLogger.e('🔒 Unauthorized - Redirecting to login');

            final context = AppNavigator.navigatorKey.currentContext!;

            // ADD LOGIC TO REDIRECT TO LOGIN OR AS REQUIRED
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  String _prettifyJson(dynamic data) {
    try {
      final jsonData = data is String ? jsonDecode(data) : data;
      return const JsonEncoder.withIndent('  ').convert(jsonData);
    } catch (e) {
      return data.toString();
    }
  }
}
