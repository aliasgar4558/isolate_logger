import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_logger/isolate_logger.dart';
import 'package:isolate_logger/src/enum/log_type.dart';
import 'package:isolate_logger/src/logger_utility.dart';
import 'package:isolate_logger/src/services/log_service.dart';
import 'package:mocktail/mocktail.dart';

import '../app_mocks.dart';

void main() {
  late ILogService logService;
  late LoggerUtility loggerUtilitySUT;

  setUpAll(() {
    logService = MockLogService();
    loggerUtilitySUT = LoggerUtility(
      logService: logService,
    );

    registerFallbackValue(LogsExportType.all);
  });

  test(
    "whenInitialized_serviceShallBeInitializedAndDefaultValuesShallBeIntact",
    () {
      loggerUtilitySUT.initLogger();
      expect(logService, isNotNull);
      expect(loggerUtilitySUT, isNotNull);
    },
  );

  group("logMessage test", () {
    test(
      "logMessage_toCallForLoggingInfoAndDoNotWantLogIntoFile_logServiceNotCalled",
      () async {
        loggerUtilitySUT.initLogger(
          logIntoFile: false,
        );

        loggerUtilitySUT.logMessage(
          type: LogType.info,
          tag: "tag",
          message: "message",
        );

        verifyNever(
          () => logService.log(
            fileName: any(named: "fileName"),
            message: any(named: "message"),
          ),
        );
      },
    );

    test(
      "logMessage_toCallForLoggingWarningAndDoNotWantLogIntoFile_logServiceNotCalled",
      () async {
        loggerUtilitySUT.logMessage(
          type: LogType.warning,
          tag: "tag",
          message: "message",
        );

        verifyNever(
          () => logService.log(
            fileName: any(named: "fileName"),
            message: any(named: "message"),
          ),
        );
      },
    );

    test(
      "logMessage_toCallForLoggingErrorAndDoNotWantLogIntoFile_completesTheProcess",
      () async {
        expect(
          loggerUtilitySUT.logMessage(
            type: LogType.error,
            tag: "tag",
            message: "message",
            subTag: "subTag",
            stackTrace: StackTrace.fromString("fake-string"),
          ),
          completes,
        );
      },
    );

    test(
      "logMessage_toCallForLoggingSevereAndDoNotWantLogIntoFile_completesTheProcess",
      () async {
        expect(
          loggerUtilitySUT.logMessage(
            type: LogType.severe,
            tag: "tag",
            message: "message",
            subTag: "subTag",
            stackTrace: StackTrace.current,
          ),
          completes,
        );
      },
    );

    test(
      "logMessage_toCallForLoggingInfoAndDoWantLogIntoFile_completesTheProcess",
      () async {
        loggerUtilitySUT.initLogger(
          logIntoFile: true,
        );
        expect(
          loggerUtilitySUT.logMessage(
            type: LogType.info,
            tag: "tag",
            message: "message",
          ),
          completes,
        );
      },
    );

    test(
      "logMessage_toCallForLoggingWarningAndDoWantLogIntoFile_completesTheProcess",
      () async {
        loggerUtilitySUT.initLogger(
          logIntoFile: true,
        );
        expect(
          loggerUtilitySUT.logMessage(
            type: LogType.warning,
            tag: "tag",
            message: "message",
          ),
          completes,
        );
      },
    );
  });

  test(
    "clearAllLogs_whenCalled_shallCallServiceMethodToClearLogs",
    () async {
      when(
        () => logService.clearAllLogs(),
      ).thenAnswer((_) => Future.value());

      await loggerUtilitySUT.clearAllLogs();

      verify(
        () => logService.clearAllLogs(),
      ).called(1);
    },
  );

  test(
    "exportLogs_whenCalledAndNoFileFound_shallCallServiceMethodAndReturnsNull",
    () async {
      when(
        () => logService.exportLogFiles(any()),
      ).thenAnswer((_) => Future.value(null));

      final result = await loggerUtilitySUT.exportLogs(
        type: LogsExportType.all,
      );

      expect(result, isA<String?>());
      expect(result, isNull);

      verify(
        () => logService.exportLogFiles(any()),
      ).called(1);
    },
  );

  test(
    "exportLogs_whenCalledAndFileFound_shallCallServiceMethodAndReturnsPath",
    () async {
      when(
        () => logService.exportLogFiles(any()),
      ).thenAnswer((_) => Future.value("fake-path"));

      final result = await loggerUtilitySUT.exportLogs(
        type: LogsExportType.all,
      );

      expect(result, isA<String?>());
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, equals("fake-path"));

      verify(
        () => logService.exportLogFiles(any()),
      ).called(1);
    },
  );

  test(
    "clearLogsFor_whenCalledWithDate_shallCallServiceMethod",
    () async {
      when(
        () => logService.clearLogsBefore(days: any(named: "days")),
      ).thenAnswer((_) => Future.value());

      expectLater(
        loggerUtilitySUT.clearLogsBefore(3),
        completes,
      );

      verify(
        () => logService.clearLogsBefore(days: any(named: "days")),
      ).called(1);
    },
  );
}
