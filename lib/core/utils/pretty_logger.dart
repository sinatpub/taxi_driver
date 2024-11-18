import 'package:logger/logger.dart';

final Logger _logger = Logger(
  printer: PrettyPrinter(
    colors: true, // Enable colors
    printEmojis: true, // Show emojis in the logs
  ),
);

// Utility function for logging
void tlog(String message, {LogLevel level = LogLevel.debug}) {
  switch (level) {
    case LogLevel.debug:
      _logger.d(message);
      break;
    case LogLevel.info:
      _logger.i(message);
      break;
    case LogLevel.warning:
      _logger.w(message);
      break;
    case LogLevel.error:
      _logger.e(message);
      break;
    case LogLevel.wtf:
      _logger.f(message);
      break;
  }
}

// Enum for log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
  wtf,
}
