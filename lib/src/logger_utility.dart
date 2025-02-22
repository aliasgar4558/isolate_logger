import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isolate_logger/isolate_logger.dart';
import 'package:isolate_logger/src/helper/extension/log_time_format_extension.dart';
import 'package:isolate_logger/src/helper/extension/string_extension.dart';
import 'package:isolate_logger/src/services/log_service.dart';

import 'enum/log_type.dart';
import 'helper/constants.dart';
import 'isolate_utility/log_isolate_entry_point.dart';
import 'models/isolate_entry_point_payload.dart';

/// Utility class for managing logging functionality in the application.
///
/// The [LoggerUtility] class provides methods for initializing the logger and handling
/// different types of log entries. It supports logging to the console, writing logs
/// to a file, and capturing system crashes.
class LoggerUtility {
  final ILogService _logService;

  LogTimeFormat _timeFormat = LogTimeFormat.timestamp;
  bool _wantConsoleLog = true;
  bool _wantFileLogEntry = true;
  bool _logSystemCrashes = true;
  String _logFileNamePrefix = kDefaultLogFileNamePrefix;
  StreamController<String>? _logsStreamController;
  StreamSubscription<String>? _logsStreamSub;
  Isolate? _eventLoggerIsolate;

  // Constructor with the required dependencies
  LoggerUtility({
    required ILogService logService,
  }) : _logService = logService;

  /// Initializes the logger with specified configuration options.
  void initLogger({
    LogTimeFormat timeFormat = LogTimeFormat.timestamp,
    bool wantConsoleLog = true,
    bool logIntoFile = true,
    bool logSystemCrashes = true,
    String logFileNamePrefix = kDefaultLogFileNamePrefix,
  }) {
    if (kIsWeb) {
      throw WebNotSupportedException();
    }

    _timeFormat = timeFormat;
    _wantConsoleLog = wantConsoleLog;
    _wantFileLogEntry = logIntoFile;
    _logSystemCrashes = logSystemCrashes;
    _logFileNamePrefix = logFileNamePrefix;
    // coverage:ignore-start
    if (_logSystemCrashes) {
      FlutterError.onError = (details) {
        logMessage(
          type: LogType.error,
          tag: "FlutterError",
          message: details.exceptionAsString(),
          stackTrace: details.stack,
        );
      };
    }
    // coverage:ignore-end
  }

  /// Utility to initialize the isolate related references & setup things for it.
  Future<void> _initiateIsolateForLoggingEvents() async {
    // Create a ReceivePort to listen to messages from the spawned isolate
    final ReceivePort mainIsolateReceivePort = ReceivePort();

    // Get the root isolate token
    final rootIsolateToken = RootIsolateToken.instance!;

    // Spawn an isolate to handle logging into the file
    _eventLoggerIsolate = await Isolate.spawn(
      logIntoFileViaIsolate,
      IsolateEntryPointPayload(
        isolateToken: rootIsolateToken,
        logService: _logService,
        mainSendPort: mainIsolateReceivePort.sendPort,
        logFileNamePrefix: _logFileNamePrefix,
      ),
      onExit: mainIsolateReceivePort.sendPort,
      onError: mainIsolateReceivePort.sendPort,
      debugName: kEventLoggingIsolateDebugName,
    );

    mainIsolateReceivePort.listen((data) {
      if (data is SendPort) {
        // if send port is received - we will bind the stream to that
        // log isolate's `SendPort` - to send any event updates to isolate thread.
        if (_logsStreamController != null) {
          _bindLogStreamListener(data);
        }
      }
    });
  }

  /// Binds a listener to the log stream using the provided logs isolate send port.
  ///
  /// The `_bindLogStreamListener` method establishes a connection with the logs isolate
  /// by using the provided [logsIsolateSendPort] and sets up a listener to receive log events.
  ///
  /// - [logsIsolateSendPort]: The send port used to communicate with the logs isolate.
  void _bindLogStreamListener(
    SendPort logsIsolateSendPort,
  ) {
    _logsStreamSub?.cancel();
    _logsStreamSub = _logsStreamController?.stream.listen((message) {
      logsIsolateSendPort.send(message);
    });
  }

  /// Logs a message with the specified type, tag, and content.
  Future<void> logMessage({
    required LogType type,
    required String tag,
    required String message,
    String? subTag,
    StackTrace? stackTrace,
  }) async {
    if (kIsWeb) {
      throw WebNotSupportedException();
    }

    String consolidatedLog = _generateConsolidatedLog(
      type: type,
      tag: tag,
      message: message,
      subTag: subTag,
      stackTrace: stackTrace,
    );

    // Log the message based on log type and user preferences.
    if (type == LogType.severe || type == LogType.error) {
      log(consolidatedLog);
      _logMessageIntoFile(consolidatedLog);
    } else {
      // Log based on user preferences.
      if (_wantConsoleLog) {
        // Log to console if enabled.
        log(consolidatedLog);
      }
      if (_wantFileLogEntry) {
        // Log to file if enabled.
        _logMessageIntoFile(consolidatedLog);
      }
    }
  }

  /// Generates a consolidated log message based on the provided parameters.
  String _generateConsolidatedLog({
    required LogType type,
    required String tag,
    required String message,
    String? subTag,
    StackTrace? stackTrace,
  }) {
    final logBuffer = StringBuffer();
    logBuffer.write(_timeFormat.formatTimeLog);
    logBuffer.write(" : ${type.typeTag}");
    logBuffer.write(" : $tag");
    if (!subTag.isNullOrEmpty) {
      logBuffer.write(" : $subTag");
    }
    logBuffer.write(" : $message");
    if (stackTrace != null) {
      logBuffer.write(" : ");
      logBuffer.write(stackTrace.toString());
    }

    // Return the consolidated log message
    return logBuffer.toString();
  }

  /// Logs the consolidated log message into a file using an isolate.
  ///
  /// This function spawns a new isolate to handle logging the provided
  /// consolidated log message into a file asynchronously. It communicates
  /// with the isolate using a result port.
  ///
  /// Parameters:
  /// - [consolidatedLog]: The consolidated log message to be logged into the file.
  Future<void> _logMessageIntoFile(
    String consolidatedLog,
  ) async {
    if (_eventLoggerIsolate == null || _logsStreamController == null) {
      _logsStreamController = StreamController<String>.broadcast();
      await _initiateIsolateForLoggingEvents();
    }

    _logsStreamController?.add(consolidatedLog);
  }

  /// Clears all logs from the log storage asynchronously.
  FutureOr<void> clearAllLogs() {
    if (kIsWeb) {
      throw WebNotSupportedException();
    }

    return _logService.clearAllLogs();
  }

  /// Exports the logs from the log storage asynchronously.
  FutureOr<String?> exportLogs({
    required LogsExportType type,
    String? logZipFilePrefix,
  }) {
    if (kIsWeb) {
      throw WebNotSupportedException();
    }

    return _logService.exportLogFiles(
      type,
      logZipFilePrefix: logZipFilePrefix,
    );
  }

  FutureOr<void> clearLogsBefore(
    int days,
  ) {
    if (kIsWeb) {
      throw WebNotSupportedException();
    }

    return _logService.clearLogsBefore(days: days);
  }

  // coverage:ignore-start
  /// Disposes resources associated with the event logging functionality.
  void dispose() {
    if (kIsWeb) {
      throw WebNotSupportedException();
    }

    _logsStreamSub?.cancel();
    _logsStreamController?.close();
    _eventLoggerIsolate?.kill();
    _eventLoggerIsolate = null;
    _logsStreamSub = null;
    _logsStreamController = null;
  }
// coverage:ignore-end
}
