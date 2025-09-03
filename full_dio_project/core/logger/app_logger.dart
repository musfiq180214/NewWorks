import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  // Internal Logger instance
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
      noBoxingByDefault: true,
    ),
  );

  // Optional tag for logger (like your old logger name)
  final String tag;

  AppLogger._(this.tag);

  /// Factory to get a logger with a specific tag
  static AppLogger getLogger(String tag) => AppLogger._(tag);

  // Internal log method
  void _log(
    void Function(dynamic) logFunction,
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final taggedMessage = tag.isNotEmpty ? "[$tag] $message" : message;
      if (error != null) {
        _logger.e(
          "🚨 ERROR: $taggedMessage",
          error: error,
          stackTrace: stackTrace ?? StackTrace.current,
        );
      } else {
        logFunction(taggedMessage);
      }
    }
  }

  // Info log
  void i(dynamic message) => _log(_logger.i, message);

  // Debug log
  void d(dynamic message) => _log(_logger.d, message);

  // Warning log
  void w(dynamic message) => _log(_logger.w, message);

  // Error log
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _log(_logger.e, message, error: error, stackTrace: stackTrace);

  // Trace log
  void t(dynamic message) => _log(_logger.t, message);

  /// Optional: global initialization
  static void init({bool isProduction = false}) {
    if (isProduction) {
      Logger.level = Level.warning;
    } else {
      Logger.level = Level.trace;
    }
  }
}
