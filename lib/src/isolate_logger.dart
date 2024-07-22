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
  /// [timeFormat]: The format for log timestamps. Defaults to [LogTimeFormat.timestamp].
  ///
  /// [wantConsoleLog]: Whether to log messages to the console. Defaults to `true`.
  ///
  /// [logIntoFile]: Whether to log messages into a file. Defaults to `true`.
  ///
  /// [logSystemCrashes]: Whether to log system crashes. Defaults to `true`.
  ///
  /// [logFileNamePrefix]: The prefix for log file names. Defaults to `kDefaultLogFileNamePrefix`.
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

  /// Logs an information message.
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

  /// Logs an error message - with optional stackTrace
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

  /// Logs a severe error message - with optional stackTrace
  void logSevere({
    required String tag,
    required String message,
    String? subTag,
    StackTrace? stackTrace,
  }) =>
      _utility.logMessage(
        type: LogType.severe,
        tag: tag,
        message: message,
        subTag: subTag,
        stackTrace: stackTrace,
      );

  /// Logs a warning message.
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

  /// Clears all logs.
  Future<void> clearAllLogs() async => await _utility.clearAllLogs();

  /// Exports the logs.
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
