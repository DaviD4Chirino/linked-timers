import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/providers/theme_mode.dart';

class ThemeModeSwitch extends ConsumerWidget {
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeModeNotifier themeModeNotifier = ref.read(
      themeModeNotifierProvider.notifier,
    );
    ThemeMode themeModeProvider = ref.watch(
      themeModeNotifierProvider,
    );
    bool isLightMode = themeModeProvider == ThemeMode.light;

    return ListTile(
      leading: Icon(
        isLightMode
            ? Icons.dark_mode_rounded
            : Icons.light_mode_rounded,
      ),
      title: Text(
        "Switch To ${isLightMode ? "Dark" : "Light"} Mode",
      ),
      trailing: Switch(
        value: isLightMode,
        onChanged: themeModeNotifier.setThemeMode,
      ),
      dense: true,
    );
  }
}
