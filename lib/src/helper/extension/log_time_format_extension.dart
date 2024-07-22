import 'package:intl/intl.dart';
import 'package:isolate_logger/isolate_logger.dart';

DateFormat _kUserFriendlyDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

/// An extension for the [LogTimeFormat] enum providing utility methods.
extension LogTimeFormatX on LogTimeFormat {
  /// Formats the current time based on the specified log time format.
  ///
  /// Returns a formatted string representing the current time.
  ///
  /// Example usage:
  /// ```dart
  /// final formattedTime = LogTimeFormat.userFriendly.formatTimeLog;
  /// ```
  String get formatTimeLog {
    final now = DateTime.now();
    return switch (this) {
      LogTimeFormat.userFriendly => _kUserFriendlyDateFormat.format(now),
      LogTimeFormat.timestamp => now.millisecondsSinceEpoch.toString(),
    };
  }
}
