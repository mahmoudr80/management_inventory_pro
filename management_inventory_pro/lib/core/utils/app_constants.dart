import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'OmniStock';

  // Localization
  static const String translationsPath = 'assets/translations';
  static const Locale englishLocale = Locale('en');
  static const Locale arabicLocale = Locale('ar');
  static const List<Locale> supportedLocales = [englishLocale, arabicLocale];
}
