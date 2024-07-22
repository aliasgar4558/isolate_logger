import 'dart:io';

import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:isolate_logger/src/helper/extension/string_extension.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../enum/logs_export_type.dart';
import '../helper/constants.dart';
import '../helper/extension/date_time_extension.dart';
import '../helper/extension/list_extension.dart';
import 'log_service.dart';

class LogServiceImpl implements ILogService {
  @override
  Future<Directory> get appLogsDirectory async {
    final supportDir = await getApplicationSupportDirectory();
    return Directory(path.join(
      supportDir.path,
      kLogFilesFolderName,
    ));
  }

  @override
  Future<Directory> get appLogsZipDirectory async {
    final tempDir = await getTemporaryDirectory();
    return Directory(path.join(
      tempDir.path,
      kLogFilesFolderName,
    ));
  }

  @override
  Future<void> log({
    required String fileName,
    required String message,
  }) async {
    // Create a File object from the provided file path
    File file = File(path.join(
      (await appLogsDirectory).path,
      fileName,
    ));

    // If the file does not exist, create it
    if (!file.existsSync()) {
      file = await file.create(recursive: true);
    }

    // Write the log message into the file, appending it to the existing content
    await file.writeAsString(
      "$message\n",
      mode: FileMode.append,
    );
  }

  @override
  Future<void> clearAllLogs() async {
    final Directory appLogsFolderDir = await appLogsDirectory;
    final Directory appLogsZipDir = await appLogsZipDirectory;
    if (appLogsFolderDir.existsSync()) {
      appLogsFolderDir.deleteSync(recursive: true);
    }
    if (appLogsZipDir.existsSync()) {
      appLogsZipDir.deleteSync(recursive: true);
    }
  }

  @override
  Future<String?> exportLogFiles(
    LogsExportType exportType, {
    String? logZipFilePrefix,
  }) async {
    final logsDirectory = await appLogsDirectory;
    if (logsDirectory.existsSync()) {
      final systemEntityListing = logsDirectory.listSync();

      if (systemEntityListing.isNotEmpty) {
        final List<File> fileList = [];
        final List<ArchiveFile> archiveFiles = [];

        if (!systemEntityListing.isNullOrEmpty) {
          switch (exportType) {
            case LogsExportType.today:
              final index = systemEntityListing.indexWhere((entity) {
                return entity.statSync().modified.equalsTo(DateTime.now());
              });

              if (!index.isNegative) {
                fileList.add(File(systemEntityListing[index].path));
              }
              break;
            case LogsExportType.all:
              for (var element in systemEntityListing) {
                fileList.add(File(element.path));
              }
              break;
          }
        }
        if (!fileList.isNullOrEmpty) {
          for (var file in fileList) {
            final fileContentInBytes = await file.readAsBytes();
            String fileNameWithExtension = path.basename(file.path);
            archiveFiles.add(
              ArchiveFile(
                fileNameWithExtension,
                fileContentInBytes.length,
                fileContentInBytes,
              ),
            );
          }
        }
        if (!archiveFiles.isNullOrEmpty) {
          final Archive archive = Archive();
          for (var archiveFile in archiveFiles) {
            archive.addFile(archiveFile);
          }

          final ZipEncoder encoder = ZipEncoder();
          final encodedArchive = encoder.encode(archive);
          if (encodedArchive != null && encodedArchive.isNotEmpty) {
            // common file name is extracted for reuse
            final zipFileNameWithoutPrefix =
                "${DateFormat(kZipFileNameDateFormat).format(DateTime.now())}.zip";

            // based upon prefix's availability, we save zip file.
            String effectiveZipFileName = (logZipFilePrefix.isNullOrEmpty)
                ? zipFileNameWithoutPrefix
                : "${logZipFilePrefix}_$zipFileNameWithoutPrefix";

            File createdZipFile = await File(path.join(
              (await appLogsZipDirectory).path,
              effectiveZipFileName,
            )).create(recursive: true);
            createdZipFile = await createdZipFile.writeAsBytes(
              encodedArchive,
              flush: true,
            );
            return createdZipFile.path;
          }
        }
      }
    }
    return null;
  }

  @override
  Future<void> clearLogsBefore({required int days}) async {
    final logsDirectory = await appLogsDirectory;
    final logsZipDirectory = await appLogsZipDirectory;
    if (logsDirectory.existsSync()) {
      final systemEntityListing = logsDirectory.listSync();
      if (!systemEntityListing.isNullOrEmpty) {
        final List<File> filesToRemove = [];
        final doCleanUpFrom = DateTime.now().subtract(
          Duration(days: days),
        );
        for (var entity in systemEntityListing) {
          if (entity.statSync().modified.isEqualOrSmallerThan(doCleanUpFrom)) {
            filesToRemove.add(File(entity.path));
          }
        }

        if (filesToRemove.isNotEmpty) {
          for (var file in filesToRemove) {
            file.deleteSync();
          }
        }
      }
    }

    if (logsZipDirectory.existsSync()) {
      logsZipDirectory.deleteSync(recursive: true);
    }
  }
}
