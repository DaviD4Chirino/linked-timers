import 'package:flutter/material.dart';

abstract class Utils {
  static double getPercentage(num value, num min, num max) {
    if (max == min) return 0.0; // Avoid division by zero
    final percent = (value - min) / (max - min);
    return percent.clamp(0.0, 1.0);
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
}
