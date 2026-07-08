import 'package:flutter_bloc/flutter_bloc.dart';

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
/// Persistence is intentionally out of scope: [save] simulates a write
/// and swaps `_lastSaved` to the current draft. A repository can later be
/// injected and called from [save] / the constructor without touching any
/// UI code.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(settings: MockSettings.build())) {
    _lastSaved = state.settings;
  }

  late SettingsModel _lastSaved;

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

  void updateAppearance(AppearanceSettings appearance) =>
      _apply(state.settings.copyWith(appearance: appearance));

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
  }

  void dismissMessages() => emit(state.copyWith(clearMessages: true));
}
