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
      primary: Color(0xFF5C8F45),
      primaryContainer: Color(0xFF83B87C),
      secondary: Color(0xFFFF5722),
      secondaryContainer: Color(0xFFB9F0B7),
      tertiary: Color(0xFF006875),
      tertiaryContainer: Color(0xFF95F0FF),
      appBarColor: Color(0xFFB9F0B7),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
    ),
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.inkSplash,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      outlinedButtonBorderWidth: 2.5,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabSchemeColor: SchemeColor.tertiary,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(
      applyThemeToAll: true,
    ),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFF8BC34A),
      primaryContainer: Color(0xFF407A27),
      primaryLightRef: Color(
        0xFF5C8F45,
      ), // The color of light mode primary
      secondary: Color(0xFFFF5722),
      secondaryContainer: Color(0xFF33691E),
      secondaryLightRef: Color(
        0xFFFF5722,
      ), // The color of light mode secondary
      tertiary: Color(0xFF86D2E1),
      tertiaryContainer: Color(0xFF1D565E),
      tertiaryLightRef: Color(
        0xFF006875,
      ), // The color of light mode tertiary
      appBarColor: Color(0xFFB9F0B7),
      error: Color(0xFFEA1D11),
      errorContainer: Color(0xFFB81D28),
    ),
    // Surface color adjustments.
    surfaceTint: const Color(0xFF081400),
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      scaffoldBackgroundBaseColor:
          FlexScaffoldBaseColor.surfaceContainer,
      scaffoldBackgroundSchemeColor: SchemeColor.surface,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.inkSplash,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      outlinedButtonBorderWidth: 2.5,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabSchemeColor: SchemeColor.tertiary,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(
      applyThemeToAll: true,
    ),
  );
}
