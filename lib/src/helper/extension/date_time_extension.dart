extension DateTimeX on DateTime? {
  bool get isValid {
    return (this != null);
  }

  bool equalsTo(DateTime? other) {
    if (isValid && other.isValid) {
      return (this!.day == other!.day &&
          this!.month == other.month &&
          this!.year == other.year);
    }
    return false;
  }

  bool isEqualOrSmallerThan(DateTime? other) {
    if (isValid && other.isValid) {
      return (equalsTo(other) || this!.isBefore(other!));
    }
    return false;
  }
}
