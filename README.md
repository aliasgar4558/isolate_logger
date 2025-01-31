# Isolate Logger

![coverage][coverage_badge]
[![The 3-Clause BSD License][license_badge]][license_link]
[![Pub.dev - Isolate Logger][pub_pkg_badge]][pub_pkg_link]

#### Supported Platforms.
![Android][android_badge]
![iOS][ios_badge]
![macOS][macos_badge]
![Linux][linux_badge]
![Windows][windows_badge]

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
// Use this method to log info. [Check other types as well for logging effectively]
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

- **Information** : `any information like app events/navigation info etc`
- **Warning** : `any warnings that needs to be logged`
- **Error** : `any error or exception - also has stackTrace as optional param`
- **Severe** : `any severe exception - with mandatory stackTrace to log`


## 💡 Feedback & Contributions
I’d love to hear your feedback on this package! If you encounter any bugs or have feature requests, please [open an issue](https://github.com/aliasgar4558/isolate_logger/issues).

If you’d like to contribute, feel free to fork the repo, make your improvements, and submit a pull request. Let’s build something amazing together! 🚀

[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-bsd-3.svg
[license_link]: https://pub.dev/packages/isolate_logger/license
[android_badge]: https://img.shields.io/badge/Android-808080
[ios_badge]: https://img.shields.io/badge/iOS-808080
[macos_badge]: https://img.shields.io/badge/macOS-808080
[linux_badge]: https://img.shields.io/badge/Linux-808080
[windows_badge]: https://img.shields.io/badge/Windows-808080
[pub_pkg_badge]: https://img.shields.io/badge/pub.dev-isolate_logger-blue
[pub_pkg_link]: https://pub.dev/packages/isolate_logger
