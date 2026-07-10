import 'package:flutter/material.dart';

/// POS-only design tokens: search bar, product grid, cart panel, and
/// checkout dialog colors. Not shared with other features. Values match
/// the `posX` fields that used to live in the old static `AppColors` /
/// core `AppThemeColors` — this is the "no visual change" baseline.
class PosThemeColors extends ThemeExtension<PosThemeColors> {
  final Color primaryDark;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color error;
  final Color sidebarBg;
  final Color sidebarBgLight;
  final Color sidebarActive;
  final Color primary;
  final Color cardBg;
  final Color cartBg;
  final Color summaryBg;
  final Color textMuted;

  const PosThemeColors({
    required this.primaryDark,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.error,
    required this.sidebarBg,
    required this.sidebarBgLight,
    required this.sidebarActive,
    required this.primary,
    required this.cardBg,
    required this.cartBg,
    required this.summaryBg,
    required this.textMuted,
  });

  @override
  PosThemeColors copyWith({
    Color? primaryDark,
    Color? surface,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? error,
    Color? sidebarBg,
    Color? sidebarBgLight,
    Color? sidebarActive,
    Color? primary,
    Color? cardBg,
    Color? cartBg,
    Color? summaryBg,
    Color? textMuted,
  }) {
    return PosThemeColors(
      primaryDark: primaryDark ?? this.primaryDark,
      surface: surface ?? this.surface,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      error: error ?? this.error,
      sidebarBg: sidebarBg ?? this.sidebarBg,
      sidebarBgLight: sidebarBgLight ?? this.sidebarBgLight,
      sidebarActive: sidebarActive ?? this.sidebarActive,
      primary: primary ?? this.primary,
      cardBg: cardBg ?? this.cardBg,
      cartBg: cartBg ?? this.cartBg,
      summaryBg: summaryBg ?? this.summaryBg,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  PosThemeColors lerp(ThemeExtension<PosThemeColors>? other, double t) {
    if (other is! PosThemeColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PosThemeColors(
      primaryDark: l(primaryDark, other.primaryDark),
      surface: l(surface, other.surface),
      border: l(border, other.border),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      success: l(success, other.success),
      error: l(error, other.error),
      sidebarBg: l(sidebarBg, other.sidebarBg),
      sidebarBgLight: l(sidebarBgLight, other.sidebarBgLight),
      sidebarActive: l(sidebarActive, other.sidebarActive),
      primary: l(primary, other.primary),
      cardBg: l(cardBg, other.cardBg),
      cartBg: l(cartBg, other.cartBg),
      summaryBg: l(summaryBg, other.summaryBg),
      textMuted: l(textMuted, other.textMuted),
    );
  }
}

/// Values identical to the old `AppColors.posX` fields — "no visual
/// change" baseline.
const PosThemeColors posLightColors = PosThemeColors(
  primaryDark: Color(0xFF0039B3),
  surface: Color(0xFFF7F8FC),
  border: Color(0xFFE5E8F2),
  textPrimary: Color(0xFF131B2E),
  textSecondary: Color(0xFF6B7280),
  success: Color(0xFF22C55E),
  error: Color(0xFFBA1A1A),
  sidebarBg: Color(0xFF131B2E),
  sidebarBgLight: Color(0xFF1B2438),
  sidebarActive: Color(0xFF22304F),
  primary: Color(0xFF0041C8),
  cardBg: Color(0xFFFFFFFF),
  cartBg: Color(0xFFFAFAFE),
  summaryBg: Color(0xFFE9ECFB),
  textMuted: Color(0xFF9CA3AF),
);

/// Dark counterpart, matching the values already present in
/// `core/theme/app_dark_theme.dart`'s `posX` fields.
const PosThemeColors posDarkColors = PosThemeColors(
  primaryDark: Color(0xFF0039B3),
  surface: Color(0xFF161B27),
  border: Color(0xFF2B3245),
  textPrimary: Color(0xFFE4E7F2),
  textSecondary: Color(0xFF9AA1B4),
  success: Color(0xFF4ADE80),
  error: Color(0xFFFFB4AB),
  sidebarBg: Color(0xFF0B0F19),
  sidebarBgLight: Color(0xFF141A28),
  sidebarActive: Color(0xFF1E2A44),
  primary: Color(0xFF7DA6FF),
  cardBg: Color(0xFF1B2130),
  cartBg: Color(0xFF161B27),
  summaryBg: Color(0xFF232A3B),
  textMuted: Color(0xFF6B7280),
);

/// Picks the right palette for the current app brightness.
PosThemeColors posColorsFor(Brightness brightness) =>
    brightness == Brightness.dark ? posDarkColors : posLightColors;

/// `context.posColors.primary` — the access point every migrated POS
/// widget uses.
extension PosThemeContext on BuildContext {
  PosThemeColors get posColors =>
      Theme.of(this).extension<PosThemeColors>()!;
}