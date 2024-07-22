extension ListX on List? {
  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    } else {
      return this?.isEmpty ?? true;
    }
  }
}
