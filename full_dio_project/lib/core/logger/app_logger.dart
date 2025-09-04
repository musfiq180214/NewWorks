import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
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

  final String tag;

  /// Default constructor
  AppLogger({this.tag = ''});

  /// Factory for tagged logger
  factory AppLogger.getLogger(String tag) => AppLogger(tag: tag);

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

  void i(dynamic message) => _log(_logger.i, message);
  void d(dynamic message) => _log(_logger.d, message);
  void w(dynamic message) => _log(_logger.w, message);
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _log(_logger.e, message, error: error, stackTrace: stackTrace);
  void t(dynamic message) => _log(_logger.t, message);

  static void init({bool isProduction = false}) {
    Logger.level = isProduction ? Level.warning : Level.trace;
  }
}
