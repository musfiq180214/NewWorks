import 'package:flutter/foundation.dart';
// gives us kDebugMode which tells if the app is running in debug mode.
import 'package:logger/logger.dart';
// gives support for logging messeges with different styles mainly colors, emojis and structured messeges.

// Logging = sendind messeges to the terminal or console
// to inform me about what my app is doing 

class AppLogger {

  // wrapper for Logger library 
  // standardize logging across app and add extra features
  // like conditional logging, structured logging, and custom formatting.

  static final Logger _logger = Logger( // handles the actual logging to the console
    printer: PrettyPrinter( // customizes the appearance of the logs
      methodCount: 0, // No method calls in logs
      errorMethodCount: 8, // Show 8 method calls in the stack trace for errors
      lineLength: 120, // Wide logs for better readability
      colors: true, // use colors for better clarity
      printEmojis: true, // use emojis for better visual appea
      dateTimeFormat: DateTimeFormat.none, // do not print data or time in logs
      noBoxingByDefault: true, // don't wrap log messages in boxes
    ),
  );

  // this log function can basically log messege with an optional error and an optional stack trace

  static void _log(
    void Function(dynamic) logFunction, // it can be _logger,i, _logger.d, _logger.w, _logger.e, _logger.t
    // info, debug, warning, error, or trace
    dynamic message, // the text/object you want to log
    {
      // as Object and StackTrace are optional parameters so they are inside {}
    Object? error,  // the actual error object, if any
    StackTrace? stackTrace, // the stack trace of the error (where actually error happened), if available
    }
  ) {
    if (kDebugMode) {   // constant from Flutter that tells if the app is running in debug mode  and not in release mode
      if (error != null) { // if caller passed an error object
        _logger.e( // log an error message using the Logger package.
          "🚨 ERROR: $message",
          error: error, // the actualy exception or error object to attach to this log.
          stackTrace: stackTrace ?? StackTrace.current, // if the caller didn't provive a stackTrace, it defaults to current location.
        );
      } else {
        logFunction(message); // if not error, still normal messeges are passed
      }
    }
  }

  static void i(dynamic message) => _log(_logger.i, message);
  static void d(dynamic message) => _log(_logger.d, message);
  static void w(dynamic message) => _log(_logger.w, message);
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _log(_logger.e, message, error: error, stackTrace: stackTrace);
  static void t(dynamic message) => _log(_logger.t, message);


  /*
  we have 5 types of logging functions:
  - i() for info messages
  - d() for debug messages
  - w() for warning messages
  - e() for error messages
  - t() for trace messages

  AppLogger.i("✅ App started successfully");

  AppLogger.d("🔍 Fetching user profile from API endpoint: /users/42");

  AppLogger.w("⚠️ User entered invalid email format, showing error message");

  try {
  int result = 10 ~/ 0; // division by zero
  } catch (error, stackTrace) {
  AppLogger.e("🔥 Failed to calculate result", error, stackTrace);
  }

  AppLogger.t("➡️ Entering LoginPage -> validating form -> sending request");

  
  */

}
