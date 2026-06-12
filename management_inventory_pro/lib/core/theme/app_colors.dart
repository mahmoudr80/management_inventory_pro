import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Precision Operational Interface spec)
  static const Color primary = Color(0xFF0041C8); // Operational Blue
  static const Color primaryContainer = Color(0xFF0055FF);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFF505F76); // Slate
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFAF8FF);
  static const Color backgroundSideBar = Color(0xFF283044); // inverse-surface / slate dark
  static const Color sideBarItems = Color(0xFFDCE1FF);
  static const Color sideBarItemsActive = Color(0xFFFFFFFF);
  static const Color sideBarBackgroundActive = Color(0xFF38485D); // secondary-fixed-variant

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFD2D9F4);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);

  static const Color textPrimary = Color(0xFF131B2E); // on-surface
  static const Color textSecondary = Color(0xFF434656); // on-surface-variant

  static const Color border = Color(0xFFE2E8F0); // soft border
  static const Color outline = Color(0xFF737688);
  static const Color outlineVariant = Color(0xFFC3C5D9);

  // Functional Accents
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF047857); // Healthy / completed
  static const Color successContainer = Color(0xFFD0F2E6);
  static const Color warning = Color(0xFFF59E0B); // Amber / low stock
  static const Color warningContainer = Color(0xFFFEF3C7);

  static const Color info = Color(0xFF0284C7); // info / pending
  static const Color infoContainer = Color(0xFFE0F2FE);

  // Backward compatibility getters
  static const Color primaryDark = Color(0xFF0039B3);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color secondaryDark = Color(0xFF0B1C30);

  static const Color onPrimaryFixed = Color(0xFF001551);
  static const Color primaryFixedDim = Color(0xFFB6C4FF);

  static const Color onSecondaryContainer = Color(0xFF54647A);

  static const Color surfaceBright = Color(0xFFFAF8FF);
  static const Color surfaceVariant = Color(0xFFDAE2FD);

  static const Color onSurface = Color(0xFF131B2E);
  static const Color onSurfaceVariant = Color(0xFF434656);
  static const Color onBackground = Color(0xFF131B2E);

  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color inverseSurface = Color(0xFF283044);
  static const Color inverseOnSurface = Color(0xFFEEF0FF);
  static const Color inversePrimary = Color(0xFFB6C4FF);

  static const Color successGreen = Color(0xFF1A6B3C);

  static const Color secondaryContainer = Color(0xFFD0E1FB);

}
