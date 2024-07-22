/// An enum representing different types of log messages.
///
/// - [info]: Indicates an informational log message.
/// - [error]: Indicates an error log message.
/// - [warning]: Indicates a warning log message.
/// - [severe]: Indicates a severe log message.
enum LogType {
  info("INFO"),
  error("ERROR"),
  warning("WARNING"),
  severe("SEVERE");

  final String typeTag;

  const LogType(this.typeTag);
}
