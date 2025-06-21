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

    return ListTile(
      leading: Icon(Icons.light_mode_rounded),
      title: Text("Switch To Light Mode"),
      trailing: Switch(
        value: themeModeNotifier.isLightMode,
        onChanged: themeModeNotifier.setThemeMode,
      ),
      dense: true,
    );
  }
}
