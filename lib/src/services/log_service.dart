import 'dart:io';

import '../enum/logs_export_type.dart';

abstract class ILogService {
  Future<Directory> get appLogsDirectory;

  Future<Directory> get appLogsZipDirectory;

  Future<void> log({
    required String fileName,
    required String message,
  });

  Future<void> clearAllLogs();

  Future<String?> exportLogFiles(
    LogsExportType exportType, {
    String? logZipFilePrefix,
  });

  Future<void> clearLogsBefore({required int days});
}
