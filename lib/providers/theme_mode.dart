import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linked_timers/models/abstracts/local_storage.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme_mode.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  bool get isLightMode => state == ThemeMode.light;
  @override
  ThemeMode build() {
    if (LocalStorage.getBool("theme-mode") == null) {
      return ThemeMode.system;
    } else {
      return LocalStorage.getBool("theme-mode")!
          ? ThemeMode.light
          : ThemeMode.dark;
    }
  }

  void fetchThemeMode() {
    bool? mode = LocalStorage.getBool("theme-mode");
    if (mode == null) return;
    state = mode ? ThemeMode.light : ThemeMode.dark;
  }

  void setThemeMode(bool lightMode) {
    Utils.log(["setThemeMode", lightMode]);
    if (lightMode) {
      setLight();
      return;
    }
    setDark();
  }

  void setDark() {
    state = ThemeMode.dark;
    _setStatusBarColor();
    LocalStorage.setBool("theme-mode", false);
  }

  void setLight() {
    state = ThemeMode.light;
    _setStatusBarColor();
    LocalStorage.setBool("theme-mode", true);
  }

  void _setStatusBarColor() {
    SystemUiOverlayStyle brightness =
        state == ThemeMode.light || state == ThemeMode.system
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light;

    SystemChrome.setSystemUIOverlayStyle(brightness);
  }
}
