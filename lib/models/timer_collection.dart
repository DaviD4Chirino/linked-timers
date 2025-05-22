// I might as well track the isInfinite bool here
import 'package:myapp/models/timer.dart';

class TimerCollection {
  TimerCollection({
    required this.timers,
    required this.title,
    this.laps = 1,
    this.isInfinite = false,
  });
  
  List<Timer> timers = [];
  int laps = 5;
  bool isInfinite = false;

  /// The title works as its id
  String title;
}
