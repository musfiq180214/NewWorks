import 'package:amar_shoday/core/api_client.dart';
import 'package:amar_shoday/core/logger/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Logger provider
final appLoggerProvider = Provider<AppLogger>((ref) {
  return AppLogger.getLogger("ApiClient");
});

// ApiClient provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return ApiClient(logger);
});
