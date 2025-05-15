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

  int timerIndex = 0;

  // set timerIndex(int count) {
  //   if (count > timers.length - 1) {
  //     setState(() {
  //       _timerIndex = 0;
  //     });
  //     return;
  //   }
  //   setState(() {
  //     _timerIndex = count;
  //   });
  // }

  // int get timerIndex => _timerIndex;

  StopWatchTimer currentTimer = StopWatchTimer();

  get fetchEnded => currentTimer.fetchEnded.listen(null);

  onTimerEnded(StopWatchTimer timer) {
    timer.onStopTimer();
    timer.onResetTimer();
    setState(() {
      timerIndex = (timerIndex + 1) % timers.length;
      currentTimer = timers[timerIndex];
      currentTimer.onStartTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    for (StopWatchTimer timer in timers) {
      timer.fetchEnded.listen((data) {
        onTimerEnded(timer);
      });
    }

    setState(() {
      currentTimer = timers[0];
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (var timer in timers) {
      timer.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: timers.length,
          itemBuilder: (context, idx) {
            return StreamBuilder(
              stream: timers[idx].rawTime,
              builder: (context, data) {
                if (data.hasData == false) {
                  return Container();
                }
                return Center(
                  child: Text(
                    StopWatchTimer.getDisplayTime(data.data!),
                    style: TextStyle(fontSize: 36),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: StreamBuilder(
        stream: currentTimer.rawTime,
        builder: (context, snap) {
          if (!snap.hasData) return Container();
          return FloatingActionButton(
            onPressed:
                currentTimer.isRunning
                    ? currentTimer.onStopTimer
                    : currentTimer.onStartTimer,
            tooltip: 'Increment',
            child: Icon(
              currentTimer.isRunning ? Icons.pause : Icons.play_arrow,
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
