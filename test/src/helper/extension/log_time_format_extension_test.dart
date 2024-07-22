import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:isolate_logger/src/enum/log_time_format.dart';
import 'package:isolate_logger/src/helper/extension/log_time_format_extension.dart';

void main() {
  test(
    "formatTimeLog_whenUserFriendlyFormatChosen_shallFormatTheDate",
    () {
      final now = DateTime.now();
      final result = LogTimeFormat.userFriendly.formatTimeLog;
      expect(result, isA<String>());
      expect(result, isNotNull);
      expect(
        result,
        equals(DateFormat("yyyy-MM-dd HH:mm:ss").format(now)),
      );
    },
  );

  test(
    "formatTimeLog_whenTimeStampFormatChosen_returnsMillisecondsSinceEpochInString",
    () {
      final now = DateTime.now();
      final result = LogTimeFormat.timestamp.formatTimeLog;
      expect(result, isA<String>());
      expect(result, isNotNull);
      expect(result, now.millisecondsSinceEpoch.toString());
    },
  );
}
