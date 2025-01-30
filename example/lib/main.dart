import 'package:flutter/material.dart';
import 'package:isolate_logger/isolate_logger.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  IsolateLogger.instance.initLogger(
    timeFormat: LogTimeFormat.userFriendly,
    wantConsoleLog: true,
    logFileNamePrefix: "EXAMPLE_APP",
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    IsolateLogger.instance.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolate Logger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Isolate Logger Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    IsolateLogger.instance.logInfo(
      tag: "EXAMPLE",
      subTag: "_incrementCounter",
      message: "Previous count : $_counter, New count : ${_counter + 1}",
    );
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () => throw (Exception("Fake-Error")),
                child: const Text("Throw fake-exception"),
              ),
              TextButton(
                onPressed: () => IsolateLogger.instance.clearAllLogs(),
                child: const Text("Clear logs"),
              ),
              TextButton(
                onPressed: () async {
                  final result = await IsolateLogger.instance.exportLogs(
                    exportType: LogsExportType.all,
                  );
                  if (result?.isNotEmpty ?? false) {
                    await Share.shareXFiles([XFile(result!)]);
                  }
                },
                child: const Text("Export logs"),
              ),
              TextButton(
                onPressed: () async {
                  final result = await IsolateLogger.instance.exportLogs(
                    exportType: LogsExportType.all,
                    logZipFilePrefix: "myPersonalDeviceID_QA",
                  );
                  if (result?.isNotEmpty ?? false) {
                    await Share.shareXFiles([XFile(result!)]);
                  }
                },
                child: const Text("Export logs with prefix"),
              ),
              TextButton(
                onPressed: () => IsolateLogger.instance.dispose(),
                child: const Text("Dispose isolate"),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}
