import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:isolate_logger/isolate_logger.dart';
import 'package:isolate_logger/src/helper/constants.dart';
import 'package:isolate_logger/src/services/log_service.dart';
import 'package:isolate_logger/src/services/log_service_impl.dart';
import 'package:path/path.dart' as path;

import '../../app_mocks.dart';

void main() {
  late ILogService logServiceSUT;

  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProvider();
    logServiceSUT = LogServiceImpl();
    await logServiceSUT.clearAllLogs();
  });

  test(
    "appLogsDirectory_whenCalled_returnsLogsDirectoryPath",
    () async {
      final logsDirectory = await logServiceSUT.appLogsDirectory;
      expect(logsDirectory, isA<Directory>());
      expect(logsDirectory, isNotNull);
      expect(
        logsDirectory.path,
        equals(path.join("app-support-dir", kLogFilesFolderName)),
      );
    },
  );

  test(
    "appLogsZipDirectory_whenCalled_returnsLogsZipDirectoryPath",
    () async {
      final logsDirectory = await logServiceSUT.appLogsZipDirectory;
      expect(logsDirectory, isA<Directory>());
      expect(logsDirectory, isNotNull);
      expect(
        logsDirectory.path,
        equals(path.join("temp-dir", kLogFilesFolderName)),
      );
    },
  );

  test(
    "exportLogFiles_whenDirNotExist_returnsNull",
    () async {
      final zipFilePath = await logServiceSUT.exportLogFiles(
        LogsExportType.all,
      );
      expect(zipFilePath, isA<String?>());
      expect(zipFilePath, isNull);
    },
  );

  test(
    "exportLogFiles_whenDirExistsButNoLogAdded_returnsNull",
    () async {
      final logsDirectory = await logServiceSUT.appLogsDirectory;
      await logsDirectory.create(recursive: true);
      final zipFilePath = await logServiceSUT.exportLogFiles(
        LogsExportType.all,
      );
      expect(zipFilePath, isA<String?>());
      expect(zipFilePath, isNull);
    },
  );

  test(
    "log_whenCalledWithData_shallCompletesTheProcess",
    () async {
      expect(
        logServiceSUT.log(
          fileName: "test.txt",
          message: "This is the test message",
        ),
        completes,
      );
    },
  );

  test(
    "exportLogFilesForTodayData_whenDirExistsWithData_shallReturnZipFilePath",
    () async {
      final logsDirectory = await logServiceSUT.appLogsDirectory;
      await logsDirectory.create(recursive: true);
      final zipFilePath = await logServiceSUT.exportLogFiles(
        LogsExportType.today,
      );
      expect(zipFilePath, isA<String?>());
      expect(zipFilePath, isNotNull);
      expect(zipFilePath, isNotEmpty);
      expect(
        zipFilePath,
        equals(
          "temp-dir/AppLogs/${DateFormat(kZipFileNameDateFormat).format(DateTime.now())}.zip",
        ),
      );
    },
  );

  test(
    "exportLogFilesForAllData_whenDirExistsWithData_shallReturnZipFilePath",
    () async {
      final logsDirectory = await logServiceSUT.appLogsDirectory;
      await logsDirectory.create(recursive: true);
      final zipFilePath = await logServiceSUT.exportLogFiles(
        LogsExportType.all,
      );
      expect(zipFilePath, isA<String?>());
      expect(zipFilePath, isNotNull);
      expect(zipFilePath, isNotEmpty);
      expect(
        zipFilePath,
        equals(
          "temp-dir/AppLogs/${DateFormat(kZipFileNameDateFormat).format(DateTime.now())}.zip",
        ),
      );
    },
  );

  test(
    "exportLogFilesForAllData_whenDirExistsAndConsumerProvidedPrefix_shallReturnZipFilePathWithPrefix",
    () async {
      const String kZipFileNamePrefix = "testPrefix";
      final logsDirectory = await logServiceSUT.appLogsDirectory;
      await logsDirectory.create(recursive: true);
      final zipFilePath = await logServiceSUT.exportLogFiles(
        LogsExportType.all,
        logZipFilePrefix: kZipFileNamePrefix,
      );
      expect(zipFilePath, isA<String?>());
      expect(zipFilePath, isNotNull);
      expect(zipFilePath, isNotEmpty);
      expect(
        zipFilePath,
        equals(
          "temp-dir/AppLogs/${kZipFileNamePrefix}_${DateFormat(kZipFileNameDateFormat).format(DateTime.now())}.zip",
        ),
      );
    },
  );

  test(
    "clearAllLogs_whenCalled_shallRemoveAllLogFilesAndStoredZipFilesAsWell",
    () async {
      await logServiceSUT.clearAllLogs();

      final logsDirectory = await logServiceSUT.appLogsDirectory;
      await logsDirectory.create(recursive: true);
      final zipFilePath = await logServiceSUT.exportLogFiles(
        LogsExportType.all,
      );
      expect(zipFilePath, isA<String?>());
      expect(zipFilePath, isNull);
    },
  );

  group("clearLogsFor tests", () {
    test(
      "clearLogsFor_whenDirNotExist_completes",
      () async {
        expectLater(
          logServiceSUT.clearLogsBefore(days: 2),
          completes,
        );
      },
    );

    test(
      "log_whenCalledWithDataForClearingLogsFor_shallCompletesTheProcess",
      () async {
        expect(
          logServiceSUT.log(
            fileName: "test.txt",
            message: "This is the test message",
          ),
          completes,
        );
      },
    );

    test(
      "exportLogFilesForTodayData_whenDirExistsWithDataForClearingLogsFor_shallReturnZipFilePath",
      () async {
        final logsDirectory = await logServiceSUT.appLogsDirectory;
        await logsDirectory.create(recursive: true);
        final zipFilePath = await logServiceSUT.exportLogFiles(
          LogsExportType.today,
        );
        expect(zipFilePath, isA<String?>());
        expect(zipFilePath, isNotNull);
        expect(zipFilePath, isNotEmpty);
        expect(
          zipFilePath,
          equals(
            "temp-dir/AppLogs/${DateFormat(kZipFileNameDateFormat).format(DateTime.now())}.zip",
          ),
        );
      },
    );

    test(
      "clearLogsFor_whenDirExist_shallClearTheFiles",
      () async {
        await logServiceSUT.clearLogsBefore(days: 0);
        final logsDirectory = await logServiceSUT.appLogsDirectory;
        await logsDirectory.create(recursive: true);
        final zipFilePath = await logServiceSUT.exportLogFiles(
          LogsExportType.all,
        );
        expect(zipFilePath, isA<String?>());
        expect(zipFilePath, isNull);
      },
    );
  });

  tearDownAll(() async {
    await logServiceSUT.clearAllLogs();
  });
}
