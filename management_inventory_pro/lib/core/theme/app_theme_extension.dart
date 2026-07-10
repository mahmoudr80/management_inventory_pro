import 'package:flutter/material.dart';

/// Runtime, theme-aware replacement for the old static `AppColors`.
///
/// Every field here mirrors a field that used to live on `AppColors` as a
/// `static const Color`, so migrating a widget is a 1:1 rename:
/// `AppColors.primary` -> `context.colors.primary`.
///
/// This is registered on `ThemeData.extensions` (see app_light_theme.dart /
/// app_dark_theme.dart) and resolved at runtime via `Theme.of(context)`,
/// which is what makes light/dark/system switching possible without a
/// global mutable singleton.
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  // Brand
  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;

  final Color secondary;
  final Color onSecondary;

  final Color background;
  final Color backgroundSideBar;
  final Color sideBarItems;
  final Color sideBarItemsActive;
  final Color sideBarBackgroundActive;

  final Color surface;
  final Color surfaceDim;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;

  final Color textPrimary;
  final Color textSecondary;

  final Color border;
  final Color outline;
  final Color outlineVariant;

  // Functional accents
  final Color error;
  final Color errorContainer;
  final Color onError;

  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;

  final Color info;
  final Color infoContainer;

  // Backward-compat / extended tokens
  final Color primaryDark;
  final Color primaryLight;
  final Color secondaryDark;

  final Color onPrimaryFixed;
  final Color primaryFixedDim;

  final Color onSecondaryContainer;

  final Color surfaceBright;
  final Color surfaceVariant;

  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onBackground;

  final Color onErrorContainer;

  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;

  final Color successGreen;

  final Color secondaryContainer;

  final Color onPrimaryContainer;
  final Color primaryFixed;
  final Color onPrimaryFixedVariant;

  // Status pills
  final Color statusHealthyBg;
  final Color statusHealthyFg;
  final Color statusHealthyBorder;
  final Color statusHealthyDot;

  final Color statusPendingBg;
  final Color statusPendingFg;
  final Color statusPendingBorder;
  final Color statusPendingDot;

  final Color statusCancelledBg;
  final Color statusCancelledFg;
  final Color statusCancelledBorder;
  final Color statusCancelledDot;

  // POS
  final Color posPrimaryDark;
  final Color posSurface;
  final Color posBorder;
  final Color posTextPrimary;
  final Color posTextSecondary;
  final Color posSuccess;
  final Color posError;
  final Color posSidebarBg;
  final Color posSidebarBgLight;
  final Color posSidebarActive;
  final Color posPrimary;
  final Color posCardBg;
  final Color posCartBg;
  final Color posSummaryBg;
  final Color posTextMuted;

  final Color tertiary;

  final Color onSuccessContainer;
  final Color onWarningContainer;

  final Color neutralContainer;
  final Color onNeutralContainer;

  // --- Elevation / surface depth system (Level 0 -> Level 5) ---
  // L3 "resting" card border vs. the border a card gets on hover/focus.
  final Color cardBorder;
  final Color cardHoverBorder;
  // L3.5 — a card nested inside another card (e.g. a stat tile inside a
  // panel) needs to read as "one step up" from its parent.
  final Color cardNested;

  // L4 — dialogs/modals and the scrim behind them.
  final Color dialogSurface;
  final Color dialogScrim;

  // L5 — popover menus, dropdown panels, context menus.
  final Color menuSurface;

  // Data tables (header row, hover, selected row, cell borders).
  final Color tableHeaderBg;
  final Color tableRowHover;
  final Color tableRowSelected;
  final Color tableBorder;

  // Sidebar interaction states beyond the static bg/active pair.
  final Color sidebarHoverBg;
  final Color sidebarDivider;
  final Color sidebarActiveIndicator;

  // Form inputs (background/border independent of generic `surface`/`border`
  // so text fields keep working even if page surface tokens shift).
  final Color inputBg;
  final Color inputBorder;
  final Color inputFocusBorder;

  // Keyboard-navigation focus ring, used for outline-only focus decoration.
  final Color focusRing;

  // Scrollbars — desktop apps live in these, default Material ones are
  // barely visible on custom surface colors.
  final Color scrollbarThumb;

  // A divider fainter than `border`, for separating rows within one
  // surface (e.g. table body rows) rather than separating surfaces.
  final Color dividerSubtle;

  const AppThemeColors({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.backgroundSideBar,
    required this.sideBarItems,
    required this.sideBarItemsActive,
    required this.sideBarBackgroundActive,
    required this.surface,
    required this.surfaceDim,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.errorContainer,
    required this.onError,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondaryDark,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onSecondaryContainer,
    required this.surfaceBright,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onBackground,
    required this.onErrorContainer,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.successGreen,
    required this.secondaryContainer,
    required this.onPrimaryContainer,
    required this.primaryFixed,
    required this.onPrimaryFixedVariant,
    required this.statusHealthyBg,
    required this.statusHealthyFg,
    required this.statusHealthyBorder,
    required this.statusHealthyDot,
    required this.statusPendingBg,
    required this.statusPendingFg,
    required this.statusPendingBorder,
    required this.statusPendingDot,
    required this.statusCancelledBg,
    required this.statusCancelledFg,
    required this.statusCancelledBorder,
    required this.statusCancelledDot,
    required this.posPrimaryDark,
    required this.posSurface,
    required this.posBorder,
    required this.posTextPrimary,
    required this.posTextSecondary,
    required this.posSuccess,
    required this.posError,
    required this.posSidebarBg,
    required this.posSidebarBgLight,
    required this.posSidebarActive,
    required this.posPrimary,
    required this.posCardBg,
    required this.posCartBg,
    required this.posSummaryBg,
    required this.posTextMuted,
    required this.tertiary,
    required this.onSuccessContainer,
    required this.onWarningContainer,
    required this.neutralContainer,
    required this.onNeutralContainer,
    required this.cardBorder,
    required this.cardHoverBorder,
    required this.cardNested,
    required this.dialogSurface,
    required this.dialogScrim,
    required this.menuSurface,
    required this.tableHeaderBg,
    required this.tableRowHover,
    required this.tableRowSelected,
    required this.tableBorder,
    required this.sidebarHoverBg,
    required this.sidebarDivider,
    required this.sidebarActiveIndicator,
    required this.inputBg,
    required this.inputBorder,
    required this.inputFocusBorder,
    required this.focusRing,
    required this.scrollbarThumb,
    required this.dividerSubtle,
  });

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? backgroundSideBar,
    Color? sideBarItems,
    Color? sideBarItemsActive,
    Color? sideBarBackgroundActive,
    Color? surface,
    Color? surfaceDim,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? outline,
    Color? outlineVariant,
    Color? error,
    Color? errorContainer,
    Color? onError,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    Color? primaryDark,
    Color? primaryLight,
    Color? secondaryDark,
    Color? onPrimaryFixed,
    Color? primaryFixedDim,
    Color? onSecondaryContainer,
    Color? surfaceBright,
    Color? surfaceVariant,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? onBackground,
    Color? onErrorContainer,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? inversePrimary,
    Color? successGreen,
    Color? secondaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? onPrimaryFixedVariant,
    Color? statusHealthyBg,
    Color? statusHealthyFg,
    Color? statusHealthyBorder,
    Color? statusHealthyDot,
    Color? statusPendingBg,
    Color? statusPendingFg,
    Color? statusPendingBorder,
    Color? statusPendingDot,
    Color? statusCancelledBg,
    Color? statusCancelledFg,
    Color? statusCancelledBorder,
    Color? statusCancelledDot,
    Color? posPrimaryDark,
    Color? posSurface,
    Color? posBorder,
    Color? posTextPrimary,
    Color? posTextSecondary,
    Color? posSuccess,
    Color? posError,
    Color? posSidebarBg,
    Color? posSidebarBgLight,
    Color? posSidebarActive,
    Color? posPrimary,
    Color? posCardBg,
    Color? posCartBg,
    Color? posSummaryBg,
    Color? posTextMuted,
    Color? tertiary,
    Color? onSuccessContainer,
    Color? onWarningContainer,
    Color? neutralContainer,
    Color? onNeutralContainer,
    Color? cardBorder,
    Color? cardHoverBorder,
    Color? cardNested,
    Color? dialogSurface,
    Color? dialogScrim,
    Color? menuSurface,
    Color? tableHeaderBg,
    Color? tableRowHover,
    Color? tableRowSelected,
    Color? tableBorder,
    Color? sidebarHoverBg,
    Color? sidebarDivider,
    Color? sidebarActiveIndicator,
    Color? inputBg,
    Color? inputBorder,
    Color? inputFocusBorder,
    Color? focusRing,
    Color? scrollbarThumb,
    Color? dividerSubtle,
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      background: background ?? this.background,
      backgroundSideBar: backgroundSideBar ?? this.backgroundSideBar,
      sideBarItems: sideBarItems ?? this.sideBarItems,
      sideBarItemsActive: sideBarItemsActive ?? this.sideBarItemsActive,
      sideBarBackgroundActive: sideBarBackgroundActive ?? this.sideBarBackgroundActive,
      surface: surface ?? this.surface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest ?? this.surfaceContainerHighest,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      onBackground: onBackground ?? this.onBackground,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      inverseOnSurface: inverseOnSurface ?? this.inverseOnSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      successGreen: successGreen ?? this.successGreen,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      primaryFixed: primaryFixed ?? this.primaryFixed,
      onPrimaryFixedVariant: onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      statusHealthyBg: statusHealthyBg ?? this.statusHealthyBg,
      statusHealthyFg: statusHealthyFg ?? this.statusHealthyFg,
      statusHealthyBorder: statusHealthyBorder ?? this.statusHealthyBorder,
      statusHealthyDot: statusHealthyDot ?? this.statusHealthyDot,
      statusPendingBg: statusPendingBg ?? this.statusPendingBg,
      statusPendingFg: statusPendingFg ?? this.statusPendingFg,
      statusPendingBorder: statusPendingBorder ?? this.statusPendingBorder,
      statusPendingDot: statusPendingDot ?? this.statusPendingDot,
      statusCancelledBg: statusCancelledBg ?? this.statusCancelledBg,
      statusCancelledFg: statusCancelledFg ?? this.statusCancelledFg,
      statusCancelledBorder: statusCancelledBorder ?? this.statusCancelledBorder,
      statusCancelledDot: statusCancelledDot ?? this.statusCancelledDot,
      posPrimaryDark: posPrimaryDark ?? this.posPrimaryDark,
      posSurface: posSurface ?? this.posSurface,
      posBorder: posBorder ?? this.posBorder,
      posTextPrimary: posTextPrimary ?? this.posTextPrimary,
      posTextSecondary: posTextSecondary ?? this.posTextSecondary,
      posSuccess: posSuccess ?? this.posSuccess,
      posError: posError ?? this.posError,
      posSidebarBg: posSidebarBg ?? this.posSidebarBg,
      posSidebarBgLight: posSidebarBgLight ?? this.posSidebarBgLight,
      posSidebarActive: posSidebarActive ?? this.posSidebarActive,
      posPrimary: posPrimary ?? this.posPrimary,
      posCardBg: posCardBg ?? this.posCardBg,
      posCartBg: posCartBg ?? this.posCartBg,
      posSummaryBg: posSummaryBg ?? this.posSummaryBg,
      posTextMuted: posTextMuted ?? this.posTextMuted,
      tertiary: tertiary ?? this.tertiary,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      neutralContainer: neutralContainer ?? this.neutralContainer,
      onNeutralContainer: onNeutralContainer ?? this.onNeutralContainer,
      cardBorder: cardBorder ?? this.cardBorder,
      cardHoverBorder: cardHoverBorder ?? this.cardHoverBorder,
      cardNested: cardNested ?? this.cardNested,
      dialogSurface: dialogSurface ?? this.dialogSurface,
      dialogScrim: dialogScrim ?? this.dialogScrim,
      menuSurface: menuSurface ?? this.menuSurface,
      tableHeaderBg: tableHeaderBg ?? this.tableHeaderBg,
      tableRowHover: tableRowHover ?? this.tableRowHover,
      tableRowSelected: tableRowSelected ?? this.tableRowSelected,
      tableBorder: tableBorder ?? this.tableBorder,
      sidebarHoverBg: sidebarHoverBg ?? this.sidebarHoverBg,
      sidebarDivider: sidebarDivider ?? this.sidebarDivider,
      sidebarActiveIndicator: sidebarActiveIndicator ?? this.sidebarActiveIndicator,
      inputBg: inputBg ?? this.inputBg,
      inputBorder: inputBorder ?? this.inputBorder,
      inputFocusBorder: inputFocusBorder ?? this.inputFocusBorder,
      focusRing: focusRing ?? this.focusRing,
      scrollbarThumb: scrollbarThumb ?? this.scrollbarThumb,
      dividerSubtle: dividerSubtle ?? this.dividerSubtle,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppThemeColors(
      primary: l(primary, other.primary),
      primaryContainer: l(primaryContainer, other.primaryContainer),
      onPrimary: l(onPrimary, other.onPrimary),
      secondary: l(secondary, other.secondary),
      onSecondary: l(onSecondary, other.onSecondary),
      background: l(background, other.background),
      backgroundSideBar: l(backgroundSideBar, other.backgroundSideBar),
      sideBarItems: l(sideBarItems, other.sideBarItems),
      sideBarItemsActive: l(sideBarItemsActive, other.sideBarItemsActive),
      sideBarBackgroundActive: l(sideBarBackgroundActive, other.sideBarBackgroundActive),
      surface: l(surface, other.surface),
      surfaceDim: l(surfaceDim, other.surfaceDim),
      surfaceContainerLowest: l(surfaceContainerLowest, other.surfaceContainerLowest),
      surfaceContainerLow: l(surfaceContainerLow, other.surfaceContainerLow),
      surfaceContainer: l(surfaceContainer, other.surfaceContainer),
      surfaceContainerHigh: l(surfaceContainerHigh, other.surfaceContainerHigh),
      surfaceContainerHighest: l(surfaceContainerHighest, other.surfaceContainerHighest),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      border: l(border, other.border),
      outline: l(outline, other.outline),
      outlineVariant: l(outlineVariant, other.outlineVariant),
      error: l(error, other.error),
      errorContainer: l(errorContainer, other.errorContainer),
      onError: l(onError, other.onError),
      success: l(success, other.success),
      successContainer: l(successContainer, other.successContainer),
      warning: l(warning, other.warning),
      warningContainer: l(warningContainer, other.warningContainer),
      info: l(info, other.info),
      infoContainer: l(infoContainer, other.infoContainer),
      primaryDark: l(primaryDark, other.primaryDark),
      primaryLight: l(primaryLight, other.primaryLight),
      secondaryDark: l(secondaryDark, other.secondaryDark),
      onPrimaryFixed: l(onPrimaryFixed, other.onPrimaryFixed),
      primaryFixedDim: l(primaryFixedDim, other.primaryFixedDim),
      onSecondaryContainer: l(onSecondaryContainer, other.onSecondaryContainer),
      surfaceBright: l(surfaceBright, other.surfaceBright),
      surfaceVariant: l(surfaceVariant, other.surfaceVariant),
      onSurface: l(onSurface, other.onSurface),
      onSurfaceVariant: l(onSurfaceVariant, other.onSurfaceVariant),
      onBackground: l(onBackground, other.onBackground),
      onErrorContainer: l(onErrorContainer, other.onErrorContainer),
      inverseSurface: l(inverseSurface, other.inverseSurface),
      inverseOnSurface: l(inverseOnSurface, other.inverseOnSurface),
      inversePrimary: l(inversePrimary, other.inversePrimary),
      successGreen: l(successGreen, other.successGreen),
      secondaryContainer: l(secondaryContainer, other.secondaryContainer),
      onPrimaryContainer: l(onPrimaryContainer, other.onPrimaryContainer),
      primaryFixed: l(primaryFixed, other.primaryFixed),
      onPrimaryFixedVariant: l(onPrimaryFixedVariant, other.onPrimaryFixedVariant),
      statusHealthyBg: l(statusHealthyBg, other.statusHealthyBg),
      statusHealthyFg: l(statusHealthyFg, other.statusHealthyFg),
      statusHealthyBorder: l(statusHealthyBorder, other.statusHealthyBorder),
      statusHealthyDot: l(statusHealthyDot, other.statusHealthyDot),
      statusPendingBg: l(statusPendingBg, other.statusPendingBg),
      statusPendingFg: l(statusPendingFg, other.statusPendingFg),
      statusPendingBorder: l(statusPendingBorder, other.statusPendingBorder),
      statusPendingDot: l(statusPendingDot, other.statusPendingDot),
      statusCancelledBg: l(statusCancelledBg, other.statusCancelledBg),
      statusCancelledFg: l(statusCancelledFg, other.statusCancelledFg),
      statusCancelledBorder: l(statusCancelledBorder, other.statusCancelledBorder),
      statusCancelledDot: l(statusCancelledDot, other.statusCancelledDot),
      posPrimaryDark: l(posPrimaryDark, other.posPrimaryDark),
      posSurface: l(posSurface, other.posSurface),
      posBorder: l(posBorder, other.posBorder),
      posTextPrimary: l(posTextPrimary, other.posTextPrimary),
      posTextSecondary: l(posTextSecondary, other.posTextSecondary),
      posSuccess: l(posSuccess, other.posSuccess),
      posError: l(posError, other.posError),
      posSidebarBg: l(posSidebarBg, other.posSidebarBg),
      posSidebarBgLight: l(posSidebarBgLight, other.posSidebarBgLight),
      posSidebarActive: l(posSidebarActive, other.posSidebarActive),
      posPrimary: l(posPrimary, other.posPrimary),
      posCardBg: l(posCardBg, other.posCardBg),
      posCartBg: l(posCartBg, other.posCartBg),
      posSummaryBg: l(posSummaryBg, other.posSummaryBg),
      posTextMuted: l(posTextMuted, other.posTextMuted),
      tertiary: l(tertiary, other.tertiary),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      neutralContainer: l(neutralContainer, other.neutralContainer),
      onNeutralContainer: l(onNeutralContainer, other.onNeutralContainer),
      cardBorder: l(cardBorder, other.cardBorder),
      cardHoverBorder: l(cardHoverBorder, other.cardHoverBorder),
      cardNested: l(cardNested, other.cardNested),
      dialogSurface: l(dialogSurface, other.dialogSurface),
      dialogScrim: l(dialogScrim, other.dialogScrim),
      menuSurface: l(menuSurface, other.menuSurface),
      tableHeaderBg: l(tableHeaderBg, other.tableHeaderBg),
      tableRowHover: l(tableRowHover, other.tableRowHover),
      tableRowSelected: l(tableRowSelected, other.tableRowSelected),
      tableBorder: l(tableBorder, other.tableBorder),
      sidebarHoverBg: l(sidebarHoverBg, other.sidebarHoverBg),
      sidebarDivider: l(sidebarDivider, other.sidebarDivider),
      sidebarActiveIndicator: l(sidebarActiveIndicator, other.sidebarActiveIndicator),
      inputBg: l(inputBg, other.inputBg),
      inputBorder: l(inputBorder, other.inputBorder),
      inputFocusBorder: l(inputFocusBorder, other.inputFocusBorder),
      focusRing: l(focusRing, other.focusRing),
      scrollbarThumb: l(scrollbarThumb, other.scrollbarThumb),
      dividerSubtle: l(dividerSubtle, other.dividerSubtle),
    );
  }
}

/// Access point every migrated widget uses instead of the static
/// `AppColors` class: `context.colors.primary`.
///
/// Throws (via the `!`) if a screen forgets to register `AppThemeColors`
/// on its `ThemeData` — intentional: a silent fallback would hide the
/// mistake instead of failing fast in debug.
extension ThemeContext on BuildContext {
  AppThemeColors get colors => Theme.of(this).extension<AppThemeColors>()!;
}