import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_logger/src/helper/extension/date_time_extension.dart';

void main() {
  group("isValid tests", () {
    test(
      "isValid_whenDateIsNull_shallReturnFalse",
      () {
        DateTime? nullDate;
        final result = nullDate.isValid;
        expect(result, isA<bool>());
        expect(result, isFalse);
      },
    );

    test(
      "isValid_whenDateIsValid_shallReturnTrue",
      () {
        DateTime? validDate = DateTime(2023);
        final result = validDate.isValid;
        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );
  });

  group("equalsTo tests", () {
    test(
      "equalsTo_whenOtherDateIsNull_returnsFalse",
      () {
        final result = DateTime(2023).equalsTo(null);
        expect(result, isA<bool>());
        expect(result, isFalse);
      },
    );

    test(
      "equalsTo_whenOtherDateIsSmaller_returnsFalse",
      () {
        final result = DateTime(2023).equalsTo(DateTime(1000));
        expect(result, isA<bool>());
        expect(result, isFalse);
      },
    );

    test(
      "equalsTo_whenOtherDateIsGreater_returnsFalse",
      () {
        final result = DateTime(2023).equalsTo(DateTime(3000));
        expect(result, isA<bool>());
        expect(result, isFalse);
      },
    );

    test(
      "equalsTo_whenOtherDateIsEqual_returnsTrue",
      () {
        final value = DateTime(2023);
        final result = value.equalsTo(value);
        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );
  });

  group("isEqualOrSmallerThan tests", () {
    test(
      "isEqualOrSmallerThan_whenOtherDateIsNull_returnsFalse",
      () {
        final result = DateTime(2023).isEqualOrSmallerThan(null);
        expect(result, isA<bool>());
        expect(result, isFalse);
      },
    );

    test(
      "isEqualOrSmallerThan_whenOtherDateIsSmaller_returnsTrue",
      () {
        final result = DateTime(2023).isEqualOrSmallerThan(
          DateTime(1000),
        );
        expect(result, isA<bool>());
        expect(result, isFalse);
      },
    );

    test(
      "isEqualOrSmallerThan_whenOtherDateIsGreater_returnsFalse",
      () {
        final result = DateTime(2023).isEqualOrSmallerThan(
          DateTime(3000),
        );
        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );

    test(
      "isEqualOrSmallerThan_whenOtherDateIsEqual_returnsTrue",
      () {
        final value = DateTime(2023);
        final result = value.isEqualOrSmallerThan(value);
        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );
  });
}
