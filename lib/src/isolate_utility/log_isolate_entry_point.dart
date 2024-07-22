import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:isolate_logger/src/models/isolate_entry_point_payload.dart';
import 'package:isolate_logger/src/services/log_service.dart';

part 'file_data_entry_helper.dart';

Future<void> logIntoFileViaIsolate(
  IsolateEntryPointPayload payload,
) async {
  // Create a ReceivePort to receive messages from the main thread
  final isolateReceivePort = ReceivePort();
  payload.mainSendPort.send(isolateReceivePort.sendPort);

  BackgroundIsolateBinaryMessenger.ensureInitialized(
    payload.isolateToken,
  );

  // listening to all data streamed from main thread, via isolate's send port
  isolateReceivePort.listen((dataFromMain) async {
    // here, we will get data which is sent from main thread
    if (dataFromMain is String) {
      final fileNameToLogMessageInto = await _fileNameToLogMessageInto(
        logService: payload.logService,
        fileNamePrefix: payload.logFileNamePrefix,
      );
      await payload.logService.log(
        fileName: fileNameToLogMessageInto,
        message: dataFromMain,
      );
    }
  });
}
