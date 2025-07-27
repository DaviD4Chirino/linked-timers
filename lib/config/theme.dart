import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.2.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFF33691E),
      primaryContainer: Color(0xFF8BC34A),
      secondary: Color(0xFFE64A19),
      secondaryContainer: Color(0xFFA5D6A7),
      tertiary: Color(0xFF006875),
      tertiaryContainer: Color(0xFF95F0FF),
      appBarColor: Color(0xFFA5D6A7),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
    ),
    // Input color modifiers.
    useMaterial3ErrorColors: true,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      scaffoldBackgroundBaseColor: FlexScaffoldBaseColor.surface,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      thinBorderWidth: 0.5,
      splashType: FlexSplashType.inkSparkle,
      adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
      defaultRadius: 5.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabUseShape: true,
      alignedDropdown: true,
      bottomAppBarHeight: 59,
      tabBarIndicatorSchemeColor: SchemeColor.primary,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      tabBarIndicatorTopRadius: 10,
      tabBarIndicatorAnimation: TabIndicatorAnimation.elastic,
      bottomNavigationBarSelectedLabelSchemeColor:
          SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: true,
      bottomNavigationBarSelectedIconSchemeColor:
          SchemeColor.primary,
      bottomNavigationBarMutedUnselectedIcon: true,
      menuElevation: 20.0,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    cupertinoOverrideTheme: const CupertinoThemeData(
      applyThemeToAll: true,
    ),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFF78DC77),
      primaryContainer: Color(0xFF1B5E20),
      primaryLightRef: Color(
        0xFF33691E,
      ), // The color of light mode primary
      secondary: Color(0xFFF4511E),
      secondaryContainer: Color(0xFF003909),
      secondaryLightRef: Color(
        0xFFE64A19,
      ), // The color of light mode secondary
      tertiary: Color(0xFF86D2E1),
      tertiaryContainer: Color(0xFF1A4D55),
      tertiaryLightRef: Color(
        0xFF006875,
      ), // The color of light mode tertiary
      appBarColor: Color(0xFFA5D6A7),
      error: Color(0xFFEA1D11),
      errorContainer: Color(0xFFB81D28),
    ),
    // Input color modifiers.
    useMaterial3ErrorColors: true,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      scaffoldBackgroundBaseColor: FlexScaffoldBaseColor.surface,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.inkSparkle,
      adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
      defaultRadius: 5.0,
      thinBorderWidth: 0.5,
      inputDecoratorIsFilled: true,
      inputDecoratorBackgroundAlpha: 25,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabUseShape: true,
      alignedDropdown: true,
      bottomAppBarHeight: 59,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      tabBarIndicatorTopRadius: 10,
      tabBarIndicatorAnimation: TabIndicatorAnimation.elastic,
      bottomNavigationBarSelectedLabelSchemeColor:
          SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: true,
      bottomNavigationBarSelectedIconSchemeColor:
          SchemeColor.primary,
      bottomNavigationBarMutedUnselectedIcon: true,
      menuElevation: 20.0,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    cupertinoOverrideTheme: const CupertinoThemeData(
      applyThemeToAll: true,
    ),
  );
}
