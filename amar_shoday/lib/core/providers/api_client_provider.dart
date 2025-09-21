import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';

// Logger provider
final appLoggerProvider = Provider<AppLogger>((ref) {
  return AppLogger.getLogger("ApiClient");
});

// GitHub token provider
final githubTokenProvider = Provider<String>((ref) {
  // ⚠️ Replace with your real GitHub PAT
  return githubToken;
});

// ApiClient provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final token = ref.watch(githubTokenProvider);
  final logger = ref.watch(appLoggerProvider);
  return ApiClient(token, logger);
});
