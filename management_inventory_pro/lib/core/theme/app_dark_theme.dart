import 'package:flutter/material.dart';
import 'app_theme_extension.dart';

/// Dark counterpart of [lightColors]. Same field set, values chosen for
/// contrast/readability on dark surfaces rather than a literal invert.
const AppThemeColors darkColors = AppThemeColors(
  // --- Elevation ladder (L0 -> L5), all blue-slate, none pure black ---
  // L0 background: Color(0xFF0B0E16)
  // L1 sidebar:    Color(0xFF090C13)  (a hair darker than L0 -> recedes)
  // L2 surface:    Color(0xFF12151F)  (main canvas cards sit on)
  // L3 cards:      Color(0xFF171C29)  (surfaceContainer)
  // L3.5 nested:   Color(0xFF1D2330)  (surfaceContainerHigh / cardNested)
  // L4 dialogs:    Color(0xFF1F2531)  (dialogSurface)
  // L5 menus:      Color(0xFF232937)  (surfaceContainerHighest / menuSurface)
  primary: Color(0xFF6E9FFF),
  primaryContainer: Color(0xFF15294F),
  onPrimary: Color(0xFF05122B),
  secondary: Color(0xFFA9B4C9),
  onSecondary: Color(0xFF1B2836),
  background: Color(0xFF0B0E16),
  backgroundSideBar: Color(0xFF090C13),
  sideBarItems: Color(0xFF8891A8),
  sideBarItemsActive: Color(0xFFF2F5FF),
  sideBarBackgroundActive: Color(0xFF17233D),
  surface: Color(0xFF12151F),
  surfaceDim: Color(0xFF0D1019),
  surfaceContainerLowest: Color(0xFF090C13),
  surfaceContainerLow: Color(0xFF12151F),
  surfaceContainer: Color(0xFF171C29),
  surfaceContainerHigh: Color(0xFF1D2330),
  surfaceContainerHighest: Color(0xFF232937),
  textPrimary: Color(0xFFE8EAF2),
  textSecondary: Color(0xFF9AA1B5),
  border: Color(0xFF232A3B),
  outline: Color(0xFF4A5268),
  outlineVariant: Color(0xFF1B2130),
  error: Color(0xFFFF9C93),
  errorContainer: Color(0xFF3D1210),
  onError: Color(0xFF2D0002),
  success: Color(0xFF3ECF8E),
  successContainer: Color(0xFF0E3B29),
  warning: Color(0xFFE8A855),
  warningContainer: Color(0xFF47320B),
  info: Color(0xFF6FC3EE),
  infoContainer: Color(0xFF0D2F42),
  primaryDark: Color(0xFF0039B3),
  primaryLight: Color(0xFF60A5FA),
  secondaryDark: Color(0xFF0B1C30),
  onPrimaryFixed: Color(0xFF001551),
  primaryFixedDim: Color(0xFFB6C4FF),
  onSecondaryContainer: Color(0xFFCBD5E8),
  surfaceBright: Color(0xFF232A3B),
  surfaceVariant: Color(0xFF2B3245),
  onSurface: Color(0xFFE4E7F2),
  onSurfaceVariant: Color(0xFFA9AFC4),
  onBackground: Color(0xFFE4E7F2),
  onErrorContainer: Color(0xFFFFDAD6),
  inverseSurface: Color(0xFFE4E7F2),
  inverseOnSurface: Color(0xFF283044),
  inversePrimary: Color(0xFF0041C8),
  successGreen: Color(0xFF4ADE9C),
  secondaryContainer: Color(0xFF33445E),
  onPrimaryContainer: Color(0xFFE3E6FF),
  primaryFixed: Color(0xFFDCE1FF),
  onPrimaryFixedVariant: Color(0xFF0039B3),
  statusHealthyBg: Color(0xFF0F2E22),
  statusHealthyFg: Color(0xFF6EE7B7),
  statusHealthyBorder: Color(0xFF1A4A36),
  statusHealthyDot: Color(0xFF34D399),
  statusPendingBg: Color(0xFF3A2B08),
  statusPendingFg: Color(0xFFFCD34D),
  statusPendingBorder: Color(0xFF57420F),
  statusPendingDot: Color(0xFFF59E0B),
  statusCancelledBg: Color(0xFF3D1512),
  statusCancelledFg: Color(0xFFFFB4AB),
  statusCancelledBorder: Color(0xFF592019),
  statusCancelledDot: Color(0xFFFF6B60),
  posPrimaryDark: Color(0xFF0039B3),
  posSurface: Color(0xFF161B27),
  posBorder: Color(0xFF2B3245),
  posTextPrimary: Color(0xFFE4E7F2),
  posTextSecondary: Color(0xFF9AA1B4),
  posSuccess: Color(0xFF4ADE80),
  posError: Color(0xFFFFB4AB),
  posSidebarBg: Color(0xFF0B0F19),
  posSidebarBgLight: Color(0xFF141A28),
  posSidebarActive: Color(0xFF1E2A44),
  posPrimary: Color(0xFF7DA6FF),
  posCardBg: Color(0xFF1B2130),
  posCartBg: Color(0xFF161B27),
  posSummaryBg: Color(0xFF232A3B),
  posTextMuted: Color(0xFF6B7280),
  tertiary: Color(0xFFAEB4B8),
  onSuccessContainer: Color(0xFF86EFAC),
  onWarningContainer: Color(0xFFFDBA74),
  neutralContainer: Color(0xFF232A3B),
  onNeutralContainer: Color(0xFF94A3B8),
  cardBorder: Color(0xFF232A3B),
  cardHoverBorder: Color(0xFF34405A),
  cardNested: Color(0xFF1D2330),
  dialogSurface: Color(0xFF1F2531),
  dialogScrim: Color(0xB3050710),
  menuSurface: Color(0xFF232937),
  tableHeaderBg: Color(0xFF171C29),
  tableRowHover: Color(0xFF1B2130),
  tableRowSelected: Color(0xFF17233D),
  tableBorder: Color(0xFF212736),
  sidebarHoverBg: Color(0xFF131826),
  sidebarDivider: Color(0xFF1A2030),
  sidebarActiveIndicator: Color(0xFF6E9FFF),
  inputBg: Color(0xFF131826),
  inputBorder: Color(0xFF2E3448),
  inputFocusBorder: Color(0xFF6E9FFF),
  focusRing: Color(0x556E9FFF),
  scrollbarThumb: Color(0xFF2E3448),
  dividerSubtle: Color(0xFF1B2130),
);

ThemeData buildAppDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkColors.primary,
      primary: darkColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkColors.background,
    useMaterial3: true,
    extensions: const [darkColors],

    // Cards: give every stock Card a visible border against the darker
    // canvas instead of relying on a shadow that barely reads at low
    // elevation on dark backgrounds.
    cardTheme: CardThemeData(
      color: darkColors.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: darkColors.cardBorder),
      ),
    ),

    // Dialogs: distinct L4 surface + real elevation shadow, since a dialog
    // is the one place a shadow should be visible (it's floating above
    // everything, including the scrim).
    dialogTheme: DialogThemeData(
      backgroundColor: darkColors.dialogSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: darkColors.cardBorder),
      ),
      titleTextStyle: TextStyle(
        color: darkColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        color: darkColors.textSecondary,
        fontSize: 14,
      ),
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: darkColors.menuSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: darkColors.cardBorder),
      ),
    ),

    dividerTheme: DividerThemeData(
      color: darkColors.dividerSubtle,
      thickness: 1,
      space: 1,
    ),

    // Inputs: dedicated bg/border tokens + a clearly-brand-colored focus
    // border, instead of the default Material focus indicator.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColors.inputBg,
      hintStyle: TextStyle(color: darkColors.textSecondary),
      labelStyle: TextStyle(color: darkColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColors.inputFocusBorder, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColors.outlineVariant),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColors.error),
      ),
    ),

    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(darkColors.scrollbarThumb),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      radius: const Radius.circular(8),
      thickness: WidgetStateProperty.all(8),
    ),

    focusColor: darkColors.focusRing,

    textTheme: Typography.whiteMountainView.apply(
      bodyColor: darkColors.textPrimary,
      displayColor: darkColors.textPrimary,
    ),
  );
}