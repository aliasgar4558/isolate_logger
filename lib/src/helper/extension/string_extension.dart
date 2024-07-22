extension StringX on String? {
  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    } else {
      return this?.trim().isEmpty ?? true;
    }
  }
}
