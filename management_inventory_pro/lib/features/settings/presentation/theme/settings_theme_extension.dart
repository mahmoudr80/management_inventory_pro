import 'package:flutter/material.dart';

/// Settings-only design tokens: the low-emphasis panel/tile backgrounds
/// (threshold panel, bordered switch tile, user row, logo drop-zone), the
/// primary-tinted slider badge default, the unselected theme-swatch
/// foreground, and the critical-stock badge's default error tint. Not
/// shared with other features — if another feature needs one of these,
/// it gets its own extension rather than reaching into this one.
class SettingsThemeColors extends ThemeExtension<SettingsThemeColors> {
  final Color primaryContainer;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color onSurfaceVariant;
  final Color errorContainer;

  const SettingsThemeColors({
    required this.primaryContainer,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.onSurfaceVariant,
    required this.errorContainer,
  });

  @override
  SettingsThemeColors copyWith({
    Color? primaryContainer,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? onSurfaceVariant,
    Color? errorContainer,
  }) {
    return SettingsThemeColors(
      primaryContainer: primaryContainer ?? this.primaryContainer,
      surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      errorContainer: errorContainer ?? this.errorContainer,
    );
  }

  @override
  SettingsThemeColors lerp(ThemeExtension<SettingsThemeColors>? other, double t) {
    if (other is! SettingsThemeColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return SettingsThemeColors(
      primaryContainer: l(primaryContainer, other.primaryContainer),
      surfaceContainerLowest: l(surfaceContainerLowest, other.surfaceContainerLowest),
      surfaceContainerLow: l(surfaceContainerLow, other.surfaceContainerLow),
      onSurfaceVariant: l(onSurfaceVariant, other.onSurfaceVariant),
      errorContainer: l(errorContainer, other.errorContainer),
    );
  }
}

/// Values identical to the current global `AppColors` fields this
/// extension replaces — the "no visual change" baseline.
const SettingsThemeColors settingsLightColors = SettingsThemeColors(
  primaryContainer: Color(0xFF0055FF), // was AppColors.primaryContainer
  surfaceContainerLowest: Color(0xFFFFFFFF), // was AppColors.surfaceContainerLowest
  surfaceContainerLow: Color(0xFFF2F3FF), // was AppColors.surfaceContainerLow
  onSurfaceVariant: Color(0xFF434656), // was AppColors.onSurfaceVariant
  errorContainer: Color(0xFFFFDAD6), // was AppColors.errorContainer
);

/// Dark counterpart, matching `darkColors` in app_dark_theme.dart field
/// for field.
const SettingsThemeColors settingsDarkColors = SettingsThemeColors(
  primaryContainer: Color(0xFF0041C8),
  surfaceContainerLowest: Color(0xFF0B0F19),
  surfaceContainerLow: Color(0xFF161B27),
  onSurfaceVariant: Color(0xFFA9AFC4),
  errorContainer: Color(0xFF93000A),
);

/// Picks the right palette for the current app brightness.
SettingsThemeColors settingsColorsFor(Brightness brightness) =>
    brightness == Brightness.dark ? settingsDarkColors : settingsLightColors;

/// `context.settingsColors.primaryContainer` — the access point every
/// migrated Settings widget uses.
extension SettingsThemeContext on BuildContext {
  SettingsThemeColors get settingsColors =>
      Theme.of(this).extension<SettingsThemeColors>()!;
}
