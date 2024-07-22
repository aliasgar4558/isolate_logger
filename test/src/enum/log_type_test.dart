import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_logger/src/enum/log_type.dart';

void main() {
  test(
    "typeTag tests",
        () {
      LogType logType = LogType.error;
      String result = logType.typeTag;
      expect(result, isA<String>());
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, equals(logType.name.toUpperCase()));

      logType = LogType.warning;
      result = logType.typeTag;
      expect(result, isA<String>());
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, equals(logType.name.toUpperCase()));

      logType = LogType.info;
      result = logType.typeTag;
      expect(result, isA<String>());
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, equals(logType.name.toUpperCase()));

      logType = LogType.severe;
      result = logType.typeTag;
      expect(result, isA<String>());
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, equals(logType.name.toUpperCase()));
    },
  );
}
