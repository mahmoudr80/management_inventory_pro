import 'package:flutter/material.dart';
import 'app_dark_theme.dart';
import 'app_light_theme.dart';

/// Single entry point `MaterialApp` reaches for. Keeps `main.dart` (and
/// any future callers) from knowing how each `ThemeData` is assembled.
class AppTheme {
  AppTheme._();

  static final ThemeData light = buildAppLightTheme();
  static final ThemeData dark = buildAppDarkTheme();
}