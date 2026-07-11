import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/api_result.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/theme_preference_service.dart';
import '../../data/local/default_settings.dart';
import '../../data/local/settings_preferences_service.dart';
import '../../data/models/settings_business_data.dart';
import '../../data/repository/settings_repository.dart';
import '../../data/models/settings_model.dart';
import 'settings_state.dart';

/// Owns every read/write for the Settings screen.
///
/// Each `updateX` method takes the already-rebuilt sub-settings object
/// (sections call `section.copyWith(...)` themselves, then hand the result
/// here) so this Cubit doesn't need one setter per individual field. This
/// keeps the file from growing into a god-class as new fields get added
/// to a section.
///
/// Persistence is split across two stores, matching what each field
/// actually is:
///  - Store name + currency/tax fields → [SettingsRepository] → SQLite
///    (the `settings` table).
///  - Everything else (store info, receipt, inventory, security, backup,
///    notifications, and the non-DB slices of general/appearance) →
///    [SettingsPreferencesService] → shared_preferences, same tech
///    [ThemePreferenceService] already uses for `appearance.themeMode`.
///
/// [settingsRepository] is nullable because SQLite is only initialized
/// on Windows (see `service_locator.dart`); on other platforms the
/// Cubit still works, it just can't persist the business fields.
///
/// The one exception to "everything waits for Save" is
/// [AppearanceSettings.themeMode]: it's persisted immediately via
/// [ThemePreferenceService] on every change (not gated behind [save])
/// so the app can switch light/dark/system live and the choice survives
/// a restart even if the rest of the draft is discarded.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required ThemePreferenceService themePreferenceService,
    required SettingsPreferencesService settingsPreferencesService,
    SettingsRepository? settingsRepository,
    StorageService? storageService,
  })  : _themePreferenceService = themePreferenceService,
        _settingsPreferencesService = settingsPreferencesService,
        _settingsRepository = settingsRepository,
        _storageService = storageService,
        super(SettingsState(settings: DefaultSettings.build())) {
    _lastSaved = state.settings;
    _loadPersistedSettings();
  }

  final ThemePreferenceService _themePreferenceService;
  final SettingsPreferencesService _settingsPreferencesService;
  final SettingsRepository? _settingsRepository;
  final StorageService? _storageService;

  late SettingsModel _lastSaved;

  /// Restores everything persisted so far on startup: theme mode, the
  /// SQLite-backed business fields, and every shared_preferences-backed
  /// section. This is a restore, not a user edit, so it does NOT set
  /// `hasUnsavedChanges` and it updates `_lastSaved` too — otherwise the
  /// app would open with a spurious "unsaved changes" flag and a stray
  /// Discard would revert values the user already saved last session.
  Future<void> _loadPersistedSettings() async {
    final persistedMode = await _themePreferenceService.getThemeMode();

    SettingsModel working = state.settings.copyWith(
      appearance: state.settings.appearance.copyWith(themeMode: persistedMode),
    );

    // Business fields (store name, currency & tax) → SQLite. On first
    // run (no row saved yet) this writes DefaultSettings — with the
    // store name seeded from the landing-page profile when one exists
    // — as the real first row, rather than leaving it as in-memory-only
    // mock data that would vanish on the next launch.
    final repository = _settingsRepository;
    if (repository != null) {
      final seededStoreName =
          _seedStoreNameFromLandingPageUser() ?? DefaultSettings.general.storeName;
      final defaultsBusiness = SettingsBusinessData(
        storeName: seededStoreName,
        currency: DefaultSettings.currencyTax.currency,
        currencySymbol: DefaultSettings.currencyTax.currencySymbol,
        taxEnabled: DefaultSettings.currencyTax.taxEnabled,
        taxPercentage: DefaultSettings.currencyTax.taxPercent,
        pricesIncludeTax: DefaultSettings.currencyTax.pricesIncludeTax,
      );

      final businessResult =
          await repository.getOrSeedBusinessSettings(defaultsBusiness);
      if (businessResult is Success<SettingsBusinessData>) {
        final business = businessResult.data;
        working = working.copyWith(
          general: working.general.copyWith(storeName: business.storeName),
          currencyTax: CurrencyTaxSettings(
            currency: business.currency,
            currencySymbol: business.currencySymbol,
            decimalPrecision: working.currencyTax.decimalPrecision,
            taxPercent: business.taxPercentage,
            taxEnabled: business.taxEnabled,
            pricesIncludeTax: business.pricesIncludeTax,
          ),
        );
      }
      // On failure, keep the in-memory defaults for this session rather
      // than blocking startup; nothing was written, so the next
      // successful Save will create the row.
    }

    // Every other section → shared_preferences, seeded the same way.
    working = working.copyWith(
      general: await _settingsPreferencesService.applyOrSeedGeneralExtra(
        base: working.general,
        defaults: DefaultSettings.general,
      ),
      storeInfo: await _settingsPreferencesService.loadOrSeedStoreInfo(
        DefaultSettings.storeInfo,
      ),
      receipt: await _settingsPreferencesService.loadOrSeedReceipt(
        DefaultSettings.receipt,
      ),
      inventory: await _settingsPreferencesService.loadOrSeedInventory(
        DefaultSettings.inventory,
      ),
      security: await _settingsPreferencesService.loadOrSeedSecurity(
        DefaultSettings.security,
      ),
      backup: await _settingsPreferencesService.loadOrSeedBackup(
        DefaultSettings.backup,
      ),
      notifications: await _settingsPreferencesService.loadOrSeedNotifications(
        DefaultSettings.notifications,
      ),
      appearance: await _settingsPreferencesService.applyOrSeedAppearanceExtra(
        base: working.appearance,
        defaults: DefaultSettings.appearance,
      ),
    );

    emit(state.copyWith(settings: working));
    _lastSaved = working;
  }

  String? _seedStoreNameFromLandingPageUser() {
    final storage = _storageService;
    if (storage == null) return null;
    final users = storage.getAllUsers();
    if (users.isEmpty) return null;
    return users.first.name;
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

    final settings = state.settings;

    // Business fields → SQLite.
    final repository = _settingsRepository;
    if (repository != null) {
      final result = await repository.saveBusinessSettings(
        SettingsBusinessData(
          storeName: settings.general.storeName,
          currency: settings.currencyTax.currency,
          currencySymbol: settings.currencyTax.currencySymbol,
          taxEnabled: settings.currencyTax.taxEnabled,
          taxPercentage: settings.currencyTax.taxPercent,
          pricesIncludeTax: settings.currencyTax.pricesIncludeTax,
        ),
      );
      if (result is Failure<int>) {
        emit(
          state.copyWith(
            isSaving: false,
            errorMessage: result.errorModel.message,
          ),
        );
        return;
      }
    }

    // Everything else → shared_preferences.
    await Future.wait([
      _settingsPreferencesService.saveGeneralExtra(settings.general),
      _settingsPreferencesService.saveStoreInfo(settings.storeInfo),
      _settingsPreferencesService.saveReceipt(settings.receipt),
      _settingsPreferencesService.saveInventory(settings.inventory),
      _settingsPreferencesService.saveSecurity(settings.security),
      _settingsPreferencesService.saveBackup(settings.backup),
      _settingsPreferencesService.saveNotifications(settings.notifications),
      _settingsPreferencesService.saveAppearanceExtra(settings.appearance),
    ]);

    _lastSaved = settings;
    emit(
      state.copyWith(
        isSaving: false,
        hasUnsavedChanges: false,
        successMessage: 'Settings saved successfully.',
      ),
    );
  }

  void restoreDefaults() {
    final defaults = DefaultSettings.build();
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
