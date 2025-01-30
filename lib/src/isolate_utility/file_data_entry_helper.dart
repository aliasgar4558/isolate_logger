part of 'log_isolate_entry_point.dart';

DateFormat _logFileDateFormat = DateFormat("dd_MM_yyyy");

/// Retrieves the file path for today's log file based on the provided prefix.
///
/// This function calculates the file path for the log file by combining the
/// application's support directory today's formatted log file name, and the
/// provided [fileNamePrefix].
///
/// [fileNamePrefix]: The prefix to be used for the log file name.
///
/// Returns a `Future` that completes with the file path for today's log file.
Future<String> _fileNameToLogMessageInto({
  required ILogService logService,
  required String fileNamePrefix,
}) async {
  // Format the current date using the specified date format
  String formattedDate = _logFileDateFormat.format(DateTime.now());

  // Combine the formatted date and the prefix to create the log file name
  return '${fileNamePrefix}_$formattedDate.log';
}
