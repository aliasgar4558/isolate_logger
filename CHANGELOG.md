## 1.0.6

- FIX : "Bad state: Stream has already been listened to."

## 1.0.5

- Prefix can be provided for logs archive to identify them in a better way while exporting it.

## 1.0.4

- Dependencies upgraded to latest.

## 1.0.3

- Auto cleanup mechanism added for the logger.
- User can now cleanup the files based on date.
    - All logs/zips modified on/before provided date will be cleaned up.
- Code optimised.

## 1.0.2

- Isolate mechanism upgraded, now single isolate will be responsible for logging events throughout the app life cycle.
- Reference disposal mechanism added to prevent any memory leaks.
- Code optimised.

## 1.0.1

- FIX : Time format not considered.

## 1.0.0

- Initial component commit.
- Features :
    - Helps to log events into the file & in console as well.
    - Fully customizable in context to log info.
    - Message will be logged into file via isolates to enhance user experience.
    - User can clear all logs.
    - Has an option to export all log files as ZIP for users.
- Component's unit test cases added.
- Documentation added for better user experience & component usage understandings.
