import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';

import '../../../../core/dependency_injection/service_locator.dart';
import '../../../unit/data/respository/unit_repository.dart';
import '../../../unit/presentation/cubit/unit_cubit.dart';
import '../theme/settings_theme_extension.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/buttons/reset_button.dart';
import '../widgets/layout/overview_cards_section.dart';
import '../widgets/layout/page_header_section.dart';
import '../widgets/buttons/save_button.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/appearance_section.dart';
import '../widgets/sections/backup_section.dart';
import '../widgets/sections/currency_tax_section.dart';
import '../widgets/sections/general_section.dart';
import '../widgets/sections/inventory_section.dart';
import '../widgets/sections/notification_section.dart';
import '../widgets/sections/receipt_section.dart';
import '../widgets/sections/security_section.dart';
import '../widgets/sections/store_information_section.dart';

/// Root of the Settings feature. Displayed inside the app's existing
/// scaffold/sidebar/navigation — this widget owns only the scrollable
/// page body, provides [SettingsCubit], and lays out every section in
/// the order specified by the design brief.
class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Layer SettingsThemeColors on top of the app's active theme
    // (light/dark/system) without core ever knowing this feature exists.
    final baseTheme = Theme.of(context);
    final themeWithSettingsColors = baseTheme.copyWith(
      extensions: {
        ...baseTheme.extensions.values,
        settingsColorsFor(baseTheme.brightness),
      },
    );

    return Theme(
      data: themeWithSettingsColors,
      // Reuse the app-wide singleton (same instance main.dart reads for
      // MaterialApp.themeMode) instead of constructing a second
      // SettingsCubit here. A second instance would re-run the SQLite +
      // shared_preferences load from scratch on every visit to this page
      // and would drift out of sync with the app-level instance (e.g. an
      // appearance change made here wouldn't show up in the other, and
      // vice versa).
      child: BlocProvider.value(
        value: getIt<SettingsCubit>(),
        child: const _SettingsView(),
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          previous.successMessage != current.successMessage ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final message = state.successMessage ?? state.errorMessage;
        if (message == null) return;
        state.errorMessage != null
            ? AppSnackBar.showError(context, message: message)
            : AppSnackBar.showSuccess(context, message: message);

        context.read<SettingsCubit>().dismissMessages();
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          final settings = state.settings;

          return Container(
            color: context.colors.background,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.pagePadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeaderSection(
                      hasUnsavedChanges: state.hasUnsavedChanges,
                      isSaving: state.isSaving,
                      onSave: cubit.save,
                      onReset: cubit.restoreDefaults,
                    ),
                    SizedBox(height: AppSpacing.xxl),
                    OverviewCardsSection(settings: settings),
                    SizedBox(height: AppSpacing.xxl),
                    GeneralSection(
                      general: settings.general,
                      onChanged: cubit.updateGeneral,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    StoreInformationSection(
                      storeInfo: settings.storeInfo,
                      onChanged: cubit.updateStoreInfo,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    CurrencyTaxSection(
                      currencyTax: settings.currencyTax,
                      onChanged: cubit.updateCurrencyTax,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    ReceiptSection(
                      receipt: settings.receipt,
                      onChanged: cubit.updateReceipt,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    if (getIt.isRegistered<UnitRepository>())
                      BlocProvider(
                        create: (_) => UnitCubit(getIt<UnitRepository>()),
                        child: Builder(
                          builder: (context) => BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, state) => InventorySettingsSection(
                              inventory: state.settings.inventory,
                              onChanged: context.read<SettingsCubit>().updateInventory,
                              unitCubit: context.read<UnitCubit>(),
                            ),
                          ),
                        ),
                      )
                    else
                      InventorySettingsSection(
                        inventory: settings.inventory,
                        onChanged: cubit.updateInventory,
                        unitCubit: null,
                      ),
                    SizedBox(height: AppSpacing.xl),
                    SecuritySection(
                      security: settings.security,
                      onChanged: cubit.updateSecurity,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    BackupSection(
                      backup: settings.backup,
                      onChanged: cubit.updateBackup,
                      onManualBackup: cubit.runManualBackup,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    NotificationSection(
                      notifications: settings.notifications,
                      onChanged: cubit.updateNotifications,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    AppearanceSection(
                      appearance: settings.appearance,
                      onChanged: cubit.updateAppearance,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    AboutSection(about: settings.about),
                    SizedBox(height: AppSpacing.xxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ResetButton(onConfirm: cubit.restoreDefaults),
                        SizedBox(width: AppSpacing.sm),
                        SizedBox(
                          width: 160,
                          child: SaveButton(
                            enabled: state.hasUnsavedChanges,
                            isSaving: state.isSaving,
                            onPressed: cubit.save,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
