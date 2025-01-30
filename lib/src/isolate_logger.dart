import 'dart:async';

import 'package:isolate_logger/src/enum/logs_export_type.dart';
import 'package:isolate_logger/src/helper/constants.dart';
import 'package:isolate_logger/src/logger_utility.dart';
import 'package:isolate_logger/src/services/log_service_impl.dart';

import 'enum/log_time_format.dart';
import 'enum/log_type.dart';

// coverage:ignore-file
/// A logger utility for handling application logs.
class IsolateLogger {
  late final LoggerUtility _utility;

  /// Private constructor to enforce the singleton pattern.
  IsolateLogger._() {
    _utility = LoggerUtility(
      logService: LogServiceImpl(),
    );
  }

  /// Singleton instance of the RSPLLogger class.
  static final IsolateLogger instance = IsolateLogger._();

  /// Initializes the logger with specified configurations.
  ///
  /// - [timeFormat]: The format for log timestamps. Defaults to [LogTimeFormat.timestamp].
  /// - [wantConsoleLog]: Whether to log messages to the console. Defaults to `true`.
  /// - [logIntoFile]: Whether to log messages into a file. Defaults to `true`.
  /// - [logSystemCrashes]: Whether to log system crashes. Defaults to `true`.
  /// - [logFileNamePrefix]: The prefix for log file names. Defaults to `kDefaultLogFileNamePrefix`.
  void initLogger({
    LogTimeFormat timeFormat = LogTimeFormat.timestamp,
    bool wantConsoleLog = true,
    bool logIntoFile = true,
    bool logSystemCrashes = true,
    String logFileNamePrefix = kDefaultLogFileNamePrefix,
  }) =>
      _utility.initLogger(
        wantConsoleLog: wantConsoleLog,
        logFileNamePrefix: logFileNamePrefix,
        logIntoFile: logIntoFile,
        logSystemCrashes: logSystemCrashes,
        timeFormat: timeFormat,
      );

  /// Logs an informational message.
  ///
  /// This method records an information-level log entry, typically used for
  /// general application events, debugging, or status updates.
  ///
  /// - [tag]: A required identifier for categorizing the log message.
  /// - [message]: The actual log content that describes the event.
  /// - [subTag]: An optional secondary tag for further categorization.
  ///
  /// Example usage:
  /// ```dart
  /// logInfo(tag: "Network", message: "API request successful");
  /// logInfo(tag: "Auth", subTag: "Login", message: "User logged in");
  /// ```
  void logInfo({
    required String tag,
    required String message,
    String? subTag,
  }) =>
      _utility.logMessage(
        type: LogType.info,
        tag: tag,
        message: message,
        subTag: subTag,
      );

  /// Logs an error message with an optional stack trace.
  ///
  /// This method records an error-level log entry, typically used for
  /// exceptions, failures, or critical issues that need attention.
  ///
  /// - [tag]: A required identifier for categorizing the log message.
  /// - [message]: The error description or message.
  /// - [subTag]: An optional secondary tag for further categorization.
  /// - [stackTrace]: An optional stack trace for debugging purposes.
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   throw Exception("Something went wrong");
  /// } catch (e, stackTrace) {
  ///   logError(tag: "Database", message: e.toString(), stackTrace: stackTrace);
  /// }
  /// ```
  void logError({
    required String tag,
    required String message,
    String? subTag,
    StackTrace? stackTrace,
  }) =>
      _utility.logMessage(
        type: LogType.error,
        tag: tag,
        message: message,
        subTag: subTag,
        stackTrace: stackTrace,
      );

  /// Logs a severe error message with stack trace.
  ///
  /// This method records a critical error-level log entry, typically used for
  /// system failures, fatal errors, or unrecoverable issues.
  ///
  /// - [tag]: A required identifier for categorizing the log message.
  /// - [message]: The critical error description or message.
  /// - [subTag]: An optional secondary tag for further categorization.
  /// - [stackTrace]: A stack trace for debugging purposes.
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   throw Exception("Critical system failure");
  /// } catch (e, stackTrace) {
  ///   logSevere(tag: "System", message: e.toString(), stackTrace: stackTrace);
  /// }
  /// ```
  void logSevere({
    required String tag,
    required String message,
    required StackTrace stackTrace,
    String? subTag,
  }) =>
      _utility.logMessage(
        type: LogType.severe,
        tag: tag,
        message: message,
        subTag: subTag,
        stackTrace: stackTrace,
      );

  /// Logs a warning message.
  ///
  /// This method records a warning-level log entry, typically used for
  /// potential issues, deprecations, or unexpected behavior that isn't
  /// necessarily an error but should be noted.
  ///
  /// - [tag]: A required identifier for categorizing the log message.
  /// - [message]: The warning description or message.
  /// - [subTag]: An optional secondary tag for further categorization.
  ///
  /// Example usage:
  /// ```dart
  /// logWarning(tag: "Network", message: "Slow response time detected");
  /// logWarning(tag: "Auth", subTag: "Token", message: "JWT token is close to expiration");
  /// ```
  void logWarning({
    required String tag,
    required String message,
    String? subTag,
  }) =>
      _utility.logMessage(
        type: LogType.warning,
        tag: tag,
        message: message,
        subTag: subTag,
      );

  /// Clears all stored log files.
  ///
  /// This method deletes all logs from the application's log directory,
  /// freeing up storage and resetting the logging system.
  ///
  /// **Note:** This action is irreversible and will remove all log data.
  ///
  /// Example usage:
  /// ```dart
  /// await clearAllLogs();
  /// ```
  Future<void> clearAllLogs() async => await _utility.clearAllLogs();

  /// Exports the log files based on the given [exportType].
  ///
  /// This method collects log files and exports them, typically as a
  /// compressed ZIP file for sharing or backup purposes.
  ///
  /// - [exportType]: Specifies the type of logs to export.
  /// - [logZipFilePrefix]: An optional prefix for the exported log ZIP file name.
  ///
  /// Returns the file path of the exported log ZIP file, or `null` if the export fails.
  ///
  /// Example usage:
  /// ```dart
  /// String? exportedPath = await exportLogs(
  ///   exportType: LogsExportType.all,
  ///   logZipFilePrefix: "app_logs",
  /// );
  /// if (exportedPath != null) {
  ///   print("Logs exported to: $exportedPath");
  /// }
  /// ```
  FutureOr<String?> exportLogs({
    required LogsExportType exportType,
    String? logZipFilePrefix,
  }) =>
      _utility.exportLogs(
        type: exportType,
        logZipFilePrefix: logZipFilePrefix,
      );

  /// Utility to clean up the files modified before given no. of days from today.
  ///
  /// It will clear all [ZIP] files which are stored.
  /// It will clear all [TXT] (log files) modified before given no. of days.
  Future<void> clearLogsBefore(int days) async =>
      await _utility.clearLogsBefore(days);

  /// Disposes resources associated with the logger utility.
  ///
  /// The `dispose` method is responsible for releasing and disposing of resources
  /// used by the logger utility. It should be called when the logger is no longer needed
  /// to ensure proper cleanup of resources.
  void dispose() => _utility.dispose();
}
