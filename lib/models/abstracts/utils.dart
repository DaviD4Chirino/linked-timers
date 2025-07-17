import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/widgets/edit_timer_list_wheel.dart';

abstract class Utils {
  static double getPercentage(num value, num min, num max) {
    if (max == min) return 0.0; // Avoid division by zero
    final percent = (value - min) / (max - min);
    return percent.clamp(0.0, 1.0);
  }

  static Future<Timer?> timerAlert({
    Timer? timerToEdit, // If null, a new timer will be created
    required BuildContext context,
    String titleText = "Add timer",
    String buttonText = "Accept",
  }) async {
    Timer? timer =
        timerToEdit != null
            ? timerToEdit.copyWith(id: timerToEdit.id)
            : Timer();
    bool canceled = true;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titleText),
          content: Container(
            constraints: BoxConstraints(maxHeight: 500),
            child: EditTimerListWheel(
              timer: timer,
              onChanged: (
                label,
                hours,
                minutes,
                seconds,
                notify,
              ) {
                timer.label = label;
                timer.hours = hours;
                timer.minutes = minutes;
                timer.seconds = seconds;
                timer.notify = notify;
              },
            ),
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (timer.timeAsMilliseconds < 1000) {
                    Fluttertoast.showToast(
                      msg:
                          "Make sure the timer is at least 1 second long",
                    );

                    return;
                  }
                  canceled = false;
                  Navigator.pop(context);
                },
                child: Text(buttonText),
              ),
            ),
          ],
        );
      },
    );
    return canceled ? null : timer;
  }

  static Future<bool> consentAlert(
    BuildContext context, {
    String? titleText,
    String? contentText,
    Widget Function(BuildContext)? builder,
  }) async {
    bool consented = false;

    await showDialog(
      context: context,
      builder:
          builder ??
          (context) {
            return AlertDialog(
              title: Text(titleText ?? "Are you sure?"),
              content: Text(
                contentText ?? "You will make a decision",
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      consented = true;
                      Navigator.of(context).pop();
                    },
                    child: Text("Accept"),
                  ),
                ),
              ],
            );
          },
    );
    return consented;
  }

  static String getDurationAsString(int milliSeconds) {
    int totalSeconds = milliSeconds ~/ 1000;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  static void log(List<Object?> elements) {
    if (kDebugMode) {
      // ignore: avoid_print
      elements.forEach(print);
      print("At: ${DateTime.now().toIso8601String()}");
    }
  }
}
