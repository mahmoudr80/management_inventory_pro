import 'package:flutter/material.dart';

/// =======================================================
/// App Spacing
/// =======================================================

class AppSpacing {
  AppSpacing._();


  // Base spacing scale
  static const double unit = 2;

  static const double gutter = 4;

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// One step beyond `xxl`, used for the generously-padded card panels on
  /// tablet/desktop auth screens (e.g. TabletAuthLayout) instead of a bare
  /// `48` literal.
  static const double xxxl = 48;

  static const double screenPadding = 24;
  static const double sectionGap = 24;
  static const double cardPadding = 20;
  static const double dialogPadding = 24;
  // Layout
  static const double pagePadding = 24;


  // Tables
  static const double tableRowHeight = 44;
}

/// =======================================================
/// Border Radius
/// =======================================================

class AppRadius {
  AppRadius._();

  static const double xs = 2;
  static const double sm = 4;
  static const double standard = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;

  static const double full = 9999;
  static const double pill = full;
}

/// =======================================================
/// Icon Sizes
/// =======================================================

class AppIconSize {
  AppIconSize._();

  static const double xs = 14;
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;
}

/// =======================================================
/// Common Component Sizes
/// =======================================================

class AppSize {
  AppSize._();

  static const double buttonHeight = 44;
  static const double textFieldHeight = 44;
  static const double toolbarHeight = 56;

  static const double sidebarWidth = 260;
  static const double navigationRailWidth = 80;

  static const double dialogMaxWidth = 700;
  static const double cardMaxWidth = 420;

  static const double tableRowHeight = 44;

  /// Width of a single card in a horizontally-scrolling summary row
  /// (e.g. SalesSummarySection).
  static const double summaryCardWidth = 250;

  /// Bounds for the filter bar's search input (FiltersSection). Named here
  /// instead of inlined as bare 200/300 literals so the constraint reads
  /// as an intentional design decision rather than a magic number.
  static const double searchFieldMinWidth = 200;
  static const double searchFieldMaxWidth = 300;

  /// Content-width caps for the auth screen (login/register) at each
  /// responsive breakpoint. Centralized here — instead of each of
  /// MobileAuthLayout / TabletAuthLayout / DesktopAuthLayout inlining its
  /// own bare literal — so the three stay obviously related and easy to
  /// tune together.
  static const double authMaxWidthMobile = 400;
  static const double authMaxWidthTablet = 550;
  static const double authMaxWidthDesktop = 900;
}

/// =======================================================
/// Border Widths
/// =======================================================

class AppBorder {
  AppBorder._();

  static const double thin = 1;
  static const double medium = 1.5;
  static const double thick = 2;
}

/// =======================================================
/// Animation Durations
/// =======================================================

class AppAnimation {
  AppAnimation._();

  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
}

/// =======================================================
/// Desktop Breakpoints
/// =======================================================

class AppBreakpoints {
  AppBreakpoints._();

  static const double compact = 900;
  static const double medium = 1280;
  static const double wide = 1600;
  static const double ultraWide = 1920;
}

/// =======================================================
/// Responsive Helper
/// =======================================================

class Responsive {
  Responsive._();

  static double width(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static bool isCompact(BuildContext context) =>
      width(context) < AppBreakpoints.medium;

  static bool isMedium(BuildContext context) =>
      width(context) >= AppBreakpoints.medium &&
          width(context) < AppBreakpoints.wide;

  static bool isWide(BuildContext context) =>
      width(context) >= AppBreakpoints.wide;

  static bool isUltraWide(BuildContext context) =>
      width(context) >= AppBreakpoints.ultraWide;
}
