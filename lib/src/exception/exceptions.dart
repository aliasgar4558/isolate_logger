/// An exception that indicates the `IsolateLogger` is not supported on the web platform.
///
/// This exception is thrown when attempting to use the `IsolateLogger`
/// on a platform where isolates are not supported, such as in a Flutter web application.
class WebNotSupportedException implements Exception {
  @override
  String toString() => "IsolateLogger does not support web platform.";
}
