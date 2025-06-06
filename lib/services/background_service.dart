import 'package:workmanager/workmanager.dart';

const String taskName = "myBackgroundTask";

abstract class BackgroundService {
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      // Your background task code here
      print("Background task triggered: $task");

      // Do your periodic work, e.g., fetch data, send notification, etc.

      // Return true if task completed successfully, false otherwise.
      return Future.value(true);
    });
  }

  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher, // The top-level function
      isInDebugMode: true, // Set to false in production
    );
  }
}
