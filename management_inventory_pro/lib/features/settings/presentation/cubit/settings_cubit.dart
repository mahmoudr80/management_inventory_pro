import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_preference_service.dart';
import '../../mock/mock_settings.dart';
import '../../models/settings_model.dart';
import 'settings_state.dart';

/// Owns every read/write for the Settings screen.
///
/// Each `updateX` method takes the already-rebuilt sub-settings object
/// (sections call `section.copyWith(...)` themselves, then hand the result
/// here) so this Cubit doesn't need one setter per individual field. This
/// keeps the file from growing into a god-class as new fields get added
/// to a section.
///
/// Persistence is intentionally out of scope for most sections: [save]
/// simulates a write and swaps `_lastSaved` to the current draft. A
/// repository can later be injected and called from [save] / the
/// constructor without touching any UI code.
///
/// The one exception is [AppearanceSettings.themeMode]: it's persisted
/// immediately via [ThemePreferenceService] on every change (not gated
/// behind [save]) so the app can switch light/dark/system live and the
/// choice survives a restart even if the rest of the draft is discarded.
/// If that immediate-persist behavior isn't what you want (e.g. you'd
/// rather theme mode only stick after hitting Save like everything
/// else), flag it and this can move into [save] instead.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required ThemePreferenceService themePreferenceService})
      : _themePreferenceService = themePreferenceService,
        super(SettingsState(settings: MockSettings.build())) {
    _lastSaved = state.settings;
    _loadPersistedThemeMode();
  }

  final ThemePreferenceService _themePreferenceService;

  late SettingsModel _lastSaved;

  /// Restores the previously-saved theme mode (if any) on startup.
  /// This is a restore, not a user edit, so it does NOT set
  /// `hasUnsavedChanges` and updates `_lastSaved` too, otherwise the app
  /// would open with a spurious "unsaved changes" flag and a stray
  /// Discard would revert the mode the user already chose last session.
  Future<void> _loadPersistedThemeMode() async {
    final persistedMode = await _themePreferenceService.getThemeMode();
    final updatedAppearance =
    state.settings.appearance.copyWith(themeMode: persistedMode);
    final updatedSettings =
    state.settings.copyWith(appearance: updatedAppearance);

    emit(state.copyWith(settings: updatedSettings));
    _lastSaved = updatedSettings;
  }

  void _apply(SettingsModel updated) {
    emit(
      state.copyWith(
        settings: updated,
        hasUnsavedChanges: true,
        clearMessages: true,
      ),
    );
  }

  // ── Section updates ─────────────────────────────────────────────────

  void updateGeneral(GeneralSettings general) =>
      _apply(state.settings.copyWith(general: general));

  void updateStoreInfo(StoreInfoSettings storeInfo) =>
      _apply(state.settings.copyWith(storeInfo: storeInfo));

  void updateCurrencyTax(CurrencyTaxSettings currencyTax) =>
      _apply(state.settings.copyWith(currencyTax: currencyTax));

  void updateReceipt(ReceiptSettings receipt) =>
      _apply(state.settings.copyWith(receipt: receipt));

  void updateInventory(InventorySettings inventory) =>
      _apply(state.settings.copyWith(inventory: inventory));

  void updateSecurity(SecuritySettings security) =>
      _apply(state.settings.copyWith(security: security));

  void updateBackup(BackupSettings backup) =>
      _apply(state.settings.copyWith(backup: backup));

  void updateNotifications(NotificationSettings notifications) =>
      _apply(state.settings.copyWith(notifications: notifications));

  void updateAppearance(AppearanceSettings appearance) {
    _apply(state.settings.copyWith(appearance: appearance));
    unawaited(_themePreferenceService.saveThemeMode(appearance.themeMode));
  }

  // ── Lifecycle actions ────────────────────────────────────────────────

  /// Simulates a manual backup — bumps the "last backup" timestamp so the
  /// Backup & Restore card reflects it immediately.
  void runManualBackup() {
    final updated = state.settings.backup.copyWith(lastBackup: DateTime.now());
    _apply(state.settings.copyWith(backup: updated));
    emit(state.copyWith(successMessage: 'Backup completed successfully.'));
  }

  Future<void> save() async {
    if (!state.hasUnsavedChanges || state.isSaving) return;

    emit(state.copyWith(isSaving: true, clearMessages: true));

    // Simulated latency for a repository write.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    _lastSaved = state.settings;
    emit(
      state.copyWith(
        isSaving: false,
        hasUnsavedChanges: false,
        successMessage: 'Settings saved successfully.',
      ),
    );
  }

  void restoreDefaults() {
    final defaults = MockSettings.build();
    emit(
      state.copyWith(
        settings: defaults,
        hasUnsavedChanges: true,
        clearMessages: true,
      ),
    );
  }

  /// Discards the current draft and reverts to the last saved snapshot.
  void discardChanges() {
    emit(
      state.copyWith(
        settings: _lastSaved,
        hasUnsavedChanges: false,
        clearMessages: true,
      ),
    );
    // Note: since theme mode is persisted immediately on every change
    // (see updateAppearance), a Discard after switching modes will
    // revert the in-memory draft here but NOT re-persist the old mode
    // to disk. If you want Discard to also roll back a persisted theme
    // change, say so and I'll adjust this to re-save
    // _lastSaved.appearance.themeMode here too.
  }

  void dismissMessages() => emit(state.copyWith(clearMessages: true));
}