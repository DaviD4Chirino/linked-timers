import 'package:flutter/material.dart';

class DisplayTime extends StatelessWidget {
  const DisplayTime(
    this.value, {
    super.key,
    this.hours = true,
    this.minutes = true,
    this.seconds = true,
    this.milliSeconds = true,
  });
  final int value;
  final bool hours;
  final bool minutes;
  final bool seconds;
  final bool milliSeconds;

  int get hoursValue => value ~/ 3600000;
  int get minutesValue => (value % 3600000) ~/ 60000;
  int get secondsValue => (value % 60000) ~/ 1000;
  int get milliSecondsValue => value % 1000;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.ltr,

      children: [
        if (hours) Text(hoursValue.toString()),
        if (hours) Text("h "),
        if (minutes) Text(minutesValue.toString()),
        if (minutes) Text("m "),
        if (seconds) Text(secondsValue.toString()),
        if (seconds) Text("s "),
        if (milliSeconds) Text(milliSecondsValue.toString()),
      ],
    );
  }
}
