import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_logger/src/helper/extension/string_extension.dart';

void main() {
  test(
    "isNullOrEmpty_whenStringIsNull_itShouldReturnTrue",
    () {
      String? inputValue;
      final result = inputValue.isNullOrEmpty;
      expect(result, isTrue);
    },
  );

  test(
    "isNullOrEmpty_whenStringIsEmpty_itShouldReturnTrue",
    () {
      String inputValue = "";
      final result = inputValue.isNullOrEmpty;
      expect(result, isTrue);
    },
  );

  test(
    "isNullOrEmpty_whenStringIsNeitherNullOrEmpty_itShouldReturnFalse",
    () {
      String inputValue = "String validation testing";
      final result = inputValue.isNullOrEmpty;
      expect(result, isFalse);
    },
  );
}
