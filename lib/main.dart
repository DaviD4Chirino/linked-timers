import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/config/theme.dart';
import 'package:linked_timers/models/abstracts/permissions_handler.dart';
import 'package:linked_timers/models/abstracts/routes.dart';
import 'package:linked_timers/models/abstracts/local_storage.dart';
import 'package:linked_timers/providers/theme_mode.dart';
import 'package:linked_timers/screens/home_screen.dart';
import 'package:linked_timers/screens/manage_collection_screen.dart';
import 'package:linked_timers/services/notification_service.dart';

final androidConfig = FlutterBackgroundAndroidConfig(
  notificationTitle: "Linked Timers",
  notificationText: "Linked Timers is running in the background",
  shouldRequestBatteryOptimizationsOff: true,
  notificationImportance: AndroidNotificationImportance.normal,
  notificationIcon: AndroidResource(
    name: 'background_icon',
    defType: 'drawable',
  ), // Default is ic_launcher from folder mipmap
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializations();

  bool success = await FlutterBackground.initialize(
    androidConfig: androidConfig,
  );
  if (success) {
    FlutterBackground.enableBackgroundExecution();
  }

  runApp(ProviderScope(child: MyApp()));
}

Future<void> initializations() async {
  await LocalStorage.init();
  await NotificationService.initialize();
  await Alarm.init();
  await PermissionsHandler.checkAndroidScheduleExactAlarmPermission();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ThemeMode get themeModeProvider =>
      ref.watch(themeModeNotifierProvider);
  ThemeModeNotifier get themeModeNotifier =>
      ref.read(themeModeNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Linked Timers",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeModeProvider,
      routes: {
        Routes.home: (context) => const HomeScreen(),
        Routes.manageCollection: (context) =>
            const ManageCollectionScreen(),
      },
      initialRoute: Routes.home,
    );
  }
}
