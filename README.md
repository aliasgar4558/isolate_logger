# Isolate Logger

`Isolate Logger` is a dart based flutter package utility designed to simplify logging messages into the console and files. It aids developers in tracking user events, exceptions, and other relevant information within their flutter applications.
With Isolate Logger, you can efficiently monitor your application's behavior, identify issues, and improve user experience.

## Features :

- **Console Logging:** Easily log messages directly into the console for real-time monitoring and debugging.
- **File Logging:** Store log messages in files for persistent tracking and analysis, helping you identify patterns and potential problems.
- **Isolate Support:** Isolate Logger supports logging in Flutter isolates, making it suitable for applications with complex asynchronous workflows.
- **Customization:** Configure log levels, formats, and file storage locations according to your specific needs.
- **Disposal Mechanism:** Which helps to clear all references to prevent any memory leak.
- **Logs cleanup for specific date** Which helps users to setup auto cleanup service after some specific period of time.

## Installation :

To use Isolate Logger in your Flutter project, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  isolate_logger: any
```

## Usage :

``` dart
import 'package:isolate_logger/isolate_logger.dart';
```

``` dart
// Initialize the logger
IsolateLogger.instance.initLogger(
    timeFormat: LogTimeFormat.userFriendly,
    logIntoFile: false,
    // check for other optional params as well to customize
);
```

``` dart
// Use this method to log info.
IsolateLogger.instance.logInfo(
    tag: "{tag here}",
    message: "{message here}",
    subTag: "{sub tag here}", // optional param
);
```

``` dart
// To clear all logs and its associated files :
IsolateLogger.instance.clearAllLogs();
```

``` dart
// To export log files as ZIP, use this :
final result = await IsolateLogger.instance.exportLogs(
    exportType: LogsExportType.all, // All & Today are the options for `exportType`
    logZipFilePrefix: "zipFilePrefix", // Optional prefix to be consider in zip file name.
);
```

``` dart
// To dispose all utility references
IsolateLogger.instance.dispose();
```

``` dart
// To cleanup the logs for some specific date
IsolateLogger.instance.clearLogsFor(DateTime.now().subtract(
  const Duration(days: 1),
));
```

## Logger message types :

- **Information** : `simple message`
- **Warning** : `any warnings that needs to be logged`
- **Error** : `any error or exception - also has stackTrace as optional param`
- **Severe** : `any severe exception - also has stackTrace as optional param`


