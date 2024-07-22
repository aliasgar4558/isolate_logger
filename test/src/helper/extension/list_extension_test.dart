import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_logger/src/helper/extension/list_extension.dart';

void main() {
  test("isNullOrEmpty_whenListIsNull_itShouldReturnTrue", () {
    const List<dynamic>? listing = null;
    final result = listing.isNullOrEmpty;
    expect(result, isTrue);
  });

  test("isNullOrEmpty_whenListIsEmpty_itShouldReturnTrue", () {
    final listing = [];
    final result = listing.isNullOrEmpty;
    expect(result, isTrue);
  });

  test("isNullOrEmpty_whenListIsValidAndHasItems_itShouldReturnTrue", () {
    final listing = ["5DAY", "PRODUCT"];
    final result = listing.isNullOrEmpty;
    expect(result, isFalse);
  });
}
