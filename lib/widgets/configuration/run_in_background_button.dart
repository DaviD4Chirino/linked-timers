import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:linked_timers/services/notification_service.dart';

class RunInBackgroundButton extends StatefulWidget {
  const RunInBackgroundButton({super.key});

  @override
  State<RunInBackgroundButton> createState() =>
      _RunInBackgroundButtonState();
}

class _RunInBackgroundButtonState
    extends State<RunInBackgroundButton> {
  Future<void> setBackgroundExecution(bool enable) async {
    /// If the user has not granted permissions, we need to request them.
    if (!await FlutterBackground.hasPermissions) {
      await FlutterBackground.initialize(
        androidConfig:
            NotificationService.androidAppRunningDetails,
      );
    }
    if (enable) {
      await FlutterBackground.enableBackgroundExecution();
    } else {
      await FlutterBackground.disableBackgroundExecution();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setBackgroundExecution(
          !FlutterBackground.isBackgroundExecutionEnabled,
        );
      },
      dense: true,
      leading: Icon(Icons.directions_run_rounded),
      title: Text("Allow Background Execution"),
      trailing: Switch(
        value: FlutterBackground.isBackgroundExecutionEnabled,
        onChanged: setBackgroundExecution,
      ),
    );
  }
}
