import 'package:flutter/material.dart';

/// Dashboard-only design tokens: status-chip container colors, insight
/// severity tints, and the "inverse surface" KPI card used by
/// InventoryValueCard. Not shared with other features — if another
/// feature needs a status-chip color, it gets its own extension rather
/// than reaching into this one.
class DashboardThemeColors extends ThemeExtension<DashboardThemeColors> {
  final Color primaryContainer;
  final Color secondaryContainer;
  final Color successContainer;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color errorContainer;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color trendPositive;

  const DashboardThemeColors({
    required this.primaryContainer,
    required this.secondaryContainer,
    required this.successContainer,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.errorContainer,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.trendPositive,
  });

  @override
  DashboardThemeColors copyWith({
    Color? primaryContainer,
    Color? secondaryContainer,
    Color? successContainer,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? errorContainer,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? trendPositive,
  }) {
    return DashboardThemeColors(
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      successContainer: successContainer ?? this.successContainer,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      errorContainer: errorContainer ?? this.errorContainer,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      trendPositive: trendPositive ?? this.trendPositive,
    );
  }

  @override
  DashboardThemeColors lerp(ThemeExtension<DashboardThemeColors>? other, double t) {
    if (other is! DashboardThemeColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return DashboardThemeColors(
      primaryContainer: l(primaryContainer, other.primaryContainer),
      secondaryContainer: l(secondaryContainer, other.secondaryContainer),
      successContainer: l(successContainer, other.successContainer),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      errorContainer: l(errorContainer, other.errorContainer),
      inverseSurface: l(inverseSurface, other.inverseSurface),
      onInverseSurface: l(onInverseSurface, other.onInverseSurface),
      trendPositive: l(trendPositive, other.trendPositive),
    );
  }
}

/// Values identical to the current global `AppColors` fields this
/// extension replaces — the "no visual change" baseline.
const DashboardThemeColors dashboardLightColors = DashboardThemeColors(
  primaryContainer: Color(0xFFDCE1FF), // was AppColors.primaryFixed
  secondaryContainer: Color(0xFFD0E1FB), // was AppColors.secondaryContainer
  successContainer: Color(0xFFD0F2E6), // was AppColors.successContainer
  warningContainer: Color(0xFFFEF3C7), // was AppColors.warningContainer
  onWarningContainer: Color(0xFFC2410C), // was AppColors.onWarningContainer
  errorContainer: Color(0xFFFFDAD6), // was AppColors.errorContainer
  inverseSurface: Color(0xFF283044), // was AppColors.backgroundSideBar
  onInverseSurface: Color(0xFFB6C4FF), // was AppColors.primaryFixedDim
  trendPositive: Color(0xFF059669), // was AppColors.statusHealthyDot
);

/// Dark counterpart. `inverseSurface` is lifted a step above the dark
/// page background so the KPI card still reads as a distinct "inverse"
/// surface instead of blending in.
const DashboardThemeColors dashboardDarkColors = DashboardThemeColors(
  primaryContainer: Color(0xFF0041C8),
  secondaryContainer: Color(0xFF33445E),
  successContainer: Color(0xFF0B4A31),
  warningContainer: Color(0xFF5A3B00),
  onWarningContainer: Color(0xFFFDBA74),
  errorContainer: Color(0xFF93000A),
  inverseSurface: Color(0xFF1B2A4D),
  onInverseSurface: Color(0xFFB6C4FF),
  trendPositive: Color(0xFF34D399),
);

/// Picks the right palette for the current app brightness.
DashboardThemeColors dashboardColorsFor(Brightness brightness) =>
    brightness == Brightness.dark ? dashboardDarkColors : dashboardLightColors;

/// `context.dashboardColors.primaryContainer` — the access point every
/// migrated Dashboard widget uses.
extension DashboardThemeContext on BuildContext {
  DashboardThemeColors get dashboardColors =>
      Theme.of(this).extension<DashboardThemeColors>()!;
}