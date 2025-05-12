import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/config/theme.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final timers = [
    StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(5),
    ),
    StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(5),
    ),
  ];
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(5),
  );
  final StopWatchTimer stopWatchTimer2 = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(5),
  );

  int loops = 0;

  var _currentTimer = StopWatchTimer();

  StreamSubscription<bool> get endedStream =>
      timers.first.fetchEnded.listen(null);

  set currentTimer(StopWatchTimer timer) {
    _currentTimer = timer;
    
    endedStream.onData((data) {
      
    });
  }

  @override
  void initState() {
    super.initState();
    stopWatchTimer.fetchEnded.listen((data) {
      if (data) {
        stopWatchTimer.onStopTimer();
        stopWatchTimer.onResetTimer();
        stopWatchTimer2.onResetTimer();
        stopWatchTimer2.onStartTimer();
      }
    });
    stopWatchTimer2.fetchEnded.listen((data) {
      if (data) {
        stopWatchTimer.onStopTimer();
        stopWatchTimer.onStartTimer();
        stopWatchTimer2.onStopTimer();
        stopWatchTimer2.onResetTimer();
        setState(() {
          loops++;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopWatchTimer.dispose();
    stopWatchTimer2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: stopWatchTimer.rawTime,
              builder: (context, snap) {
                if (!snap.hasData) return Container();
                final value = snap.data;
                final displayTime = StopWatchTimer.getDisplayTime(value!);
                return Text(
                  displayTime,
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            StreamBuilder(
              stream: stopWatchTimer2.rawTime,
              builder: (context, snap) {
                if (!snap.hasData) return Container();
                final value = snap.data;
                final displayTime = StopWatchTimer.getDisplayTime(value!);
                return Text(
                  displayTime,
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder(
        stream: stopWatchTimer.rawTime,
        builder: (context, snap) {
          if (!snap.hasData) return Container();
          return FloatingActionButton(
            onPressed:
                stopWatchTimer.isRunning
                    ? stopWatchTimer.onStopTimer
                    : stopWatchTimer.onStartTimer,
            tooltip: 'Increment',
            child: Icon(
              stopWatchTimer.isRunning ? Icons.pause : Icons.play_arrow,
            ),
          );
        },
      ),
    );
  }
}

extension ListExtensions on List {
  next(Object element) {
    int index = indexOf(element);
    int nextIndex = index + 1;
    if (nextIndex > length) {
      return first;
    }
    // if (index < 0) {
    //   return first;
    // }
    return this[index + 1];
  }
}
