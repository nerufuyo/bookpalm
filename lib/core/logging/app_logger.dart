import 'package:logger/logger.dart';

class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._();

  AppLogger._();

  late final Logger _logger;

  void initialize() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: Level.debug,
    );
  }

  void debug(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.d(
      _formatMessage(message, tag),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void info(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.i(
      _formatMessage(message, tag),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void warning(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.w(
      _formatMessage(message, tag),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      _formatMessage(message, tag),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void fatal(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.f(
      _formatMessage(message, tag),
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _formatMessage(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }
}

// Extension for easier usage
extension LoggerExtension on Object {
  void logDebug(String message, {dynamic error, StackTrace? stackTrace}) {
    AppLogger.instance.debug(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logInfo(String message, {dynamic error, StackTrace? stackTrace}) {
    AppLogger.instance.info(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logWarning(String message, {dynamic error, StackTrace? stackTrace}) {
    AppLogger.instance.warning(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logError(String message, {dynamic error, StackTrace? stackTrace}) {
    AppLogger.instance.error(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logFatal(String message, {dynamic error, StackTrace? stackTrace}) {
    AppLogger.instance.fatal(
      message,
      tag: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
