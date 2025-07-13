import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/config/theme.dart';
import 'package:linked_timers/localization/app_locale.dart';
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
  await appInitializations();

  bool success = await FlutterBackground.initialize(
    androidConfig: androidConfig,
  );
  if (success) {
    FlutterBackground.enableBackgroundExecution();
  }

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  var localization = FlutterLocalization.instance;
  ThemeMode get themeModeProvider =>
      ref.watch(themeModeNotifierProvider);
  ThemeModeNotifier get themeModeNotifier =>
      ref.read(themeModeNotifierProvider.notifier);

  // the setState function here is a must to add
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale("en", AppLocale.en),
        const MapLocale("es", AppLocale.es),
      ],
      initLanguageCode: "es",
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Linked Timers",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeModeProvider,

      supportedLocales: localization.supportedLocales,
      localizationsDelegates:
          localization.localizationsDelegates,
      routes: {
        Routes.home: (context) => const HomeScreen(),
        Routes.manageCollection:
            (context) => const ManageCollectionScreen(),
      },
      initialRoute: Routes.home,
    );
  }
}

Future<void> appInitializations() async {
  LocalStorage.init();
  NotificationService.initialize();
  Alarm.init();
  PermissionsHandler.checkAndroidScheduleExactAlarmPermission();
  FlutterLocalization.instance.ensureInitialized();
}
