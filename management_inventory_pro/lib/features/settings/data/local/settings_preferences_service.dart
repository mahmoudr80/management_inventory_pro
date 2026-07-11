import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_model.dart';

/// Persists every Settings section that has no column in the `settings`
/// SQLite table — store info, receipt, inventory, security, backup,
/// notifications, the non-DB slice of general, and the non-theme-mode
/// slice of appearance.
///
/// Uses shared_preferences, the same technology [ThemePreferenceService]
/// already uses for `appearance.themeMode` (which stays owned by that
/// service — this class never touches its key), so the project doesn't
/// gain a second local-storage mechanism for what is conceptually the
/// same kind of "UI preference" data.
class SettingsPreferencesService {
  static const _generalExtraKey = 'settings_general_extra';
  static const _storeInfoKey = 'settings_store_info';
  static const _receiptKey = 'settings_receipt';
  static const _inventoryKey = 'settings_inventory';
  static const _securityKey = 'settings_security';
  static const _backupKey = 'settings_backup';
  static const _notificationsKey = 'settings_notifications';
  static const _appearanceExtraKey = 'settings_appearance_extra';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ── General (non-DB fields) ─────────────────────────────────────────

  Future<void> saveGeneralExtra(GeneralSettings general) async {
    final prefs = await _prefs;
    await prefs.setString(
      _generalExtraKey,
      jsonEncode({
        'businessType': general.businessType,
        'timezone': general.timezone,
        'language': general.language,
        'dateFormat': general.dateFormat,
        'timeFormat': general.timeFormat,
      }),
    );
  }

  /// Applies persisted non-DB fields onto [base] (which should already
  /// carry storeName from SQLite). Returns [base] unchanged on first run.
  Future<GeneralSettings> applyGeneralExtra(GeneralSettings base) async {
    final prefs = await _prefs;
    final raw = prefs.getString(_generalExtraKey);
    if (raw == null) return base;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return base.copyWith(
      businessType: map['businessType'] as String?,
      timezone: map['timezone'] as String?,
      language: map['language'] as String?,
      dateFormat: map['dateFormat'] as String?,
      timeFormat: map['timeFormat'] as String?,
    );
  }

  // ── Store info ───────────────────────────────────────────────────────

  Future<void> saveStoreInfo(StoreInfoSettings storeInfo) async {
    final prefs = await _prefs;
    await prefs.setString(
      _storeInfoKey,
      jsonEncode({
        'logoPath': storeInfo.logoPath,
        'phone': storeInfo.phone,
        'email': storeInfo.email,
        'address': storeInfo.address,
        'website': storeInfo.website,
        'taxNumber': storeInfo.taxNumber,
      }),
    );
  }

  Future<StoreInfoSettings?> loadStoreInfo() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storeInfoKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return StoreInfoSettings(
      logoPath: map['logoPath'] as String?,
      phone: map['phone'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      website: map['website'] as String,
      taxNumber: map['taxNumber'] as String,
    );
  }

  // ── Receipt ──────────────────────────────────────────────────────────

  Future<void> saveReceipt(ReceiptSettings receipt) async {
    final prefs = await _prefs;
    await prefs.setString(
      _receiptKey,
      jsonEncode({
        'widthMm': receipt.widthMm,
        'header': receipt.header,
        'footer': receipt.footer,
        'showLogo': receipt.showLogo,
        'showTax': receipt.showTax,
        'showCashier': receipt.showCashier,
      }),
    );
  }

  Future<ReceiptSettings?> loadReceipt() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_receiptKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return ReceiptSettings(
      widthMm: map['widthMm'] as int,
      header: map['header'] as String,
      footer: map['footer'] as String,
      showLogo: map['showLogo'] as bool,
      showTax: map['showTax'] as bool,
      showCashier: map['showCashier'] as bool,
    );
  }

  // ── Inventory ────────────────────────────────────────────────────────

  Future<void> saveInventory(InventorySettings inventory) async {
    final prefs = await _prefs;
    await prefs.setString(
      _inventoryKey,
      jsonEncode({
        'lowStockThreshold': inventory.lowStockThreshold,
        'criticalStockThreshold': inventory.criticalStockThreshold,
        'allowNegativeStock': inventory.allowNegativeStock,
        'autoSku': inventory.autoSku,
        'requireBarcode': inventory.requireBarcode,
        'defaultUnitId': inventory.defaultUnitId,
        'enableStockAlerts': inventory.enableStockAlerts,
      }),
    );
  }

  Future<InventorySettings?> loadInventory() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_inventoryKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return InventorySettings(
      lowStockThreshold: map['lowStockThreshold'] as int,
      criticalStockThreshold: map['criticalStockThreshold'] as int,
      allowNegativeStock: map['allowNegativeStock'] as bool,
      autoSku: map['autoSku'] as bool,
      requireBarcode: map['requireBarcode'] as bool,
      // Migration: pre-refactor installs stored a unit *name* under the
      // old 'defaultUnit' key (e.g. "Piece"). There's no reliable way to
      // map a name back to an id (names can change, the unit may no
      // longer exist), so old data isn't migrated — it's simply treated
      // as "nothing chosen", which is always a safe, crash-free default.
      defaultUnitId: map['defaultUnitId'] is int ? map['defaultUnitId'] as int : null,
      enableStockAlerts: map['enableStockAlerts'] as bool,
    );
  }

  // ── Security ─────────────────────────────────────────────────────────

  Future<void> saveSecurity(SecuritySettings security) async {
    final prefs = await _prefs;
    await prefs.setString(
      _securityKey,
      jsonEncode({
        'currentUser': security.currentUser,
        'role': security.role,
        'rememberLogin': security.rememberLogin,
        'sessionTimeoutMinutes': security.sessionTimeoutMinutes,
      }),
    );
  }

  Future<SecuritySettings?> loadSecurity() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_securityKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return SecuritySettings(
      currentUser: map['currentUser'] as String,
      role: map['role'] as String,
      rememberLogin: map['rememberLogin'] as bool,
      sessionTimeoutMinutes: map['sessionTimeoutMinutes'] as int,
    );
  }

  // ── Backup ───────────────────────────────────────────────────────────

  Future<void> saveBackup(BackupSettings backup) async {
    final prefs = await _prefs;
    await prefs.setString(
      _backupKey,
      jsonEncode({
        'automaticBackup': backup.automaticBackup,
        'backupFolder': backup.backupFolder,
        'databaseSizeMb': backup.databaseSizeMb,
        'lastBackup': backup.lastBackup.toIso8601String(),
        'storageUsagePercent': backup.storageUsagePercent,
      }),
    );
  }

  Future<BackupSettings?> loadBackup() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_backupKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return BackupSettings(
      automaticBackup: map['automaticBackup'] as bool,
      backupFolder: map['backupFolder'] as String,
      databaseSizeMb: (map['databaseSizeMb'] as num).toDouble(),
      lastBackup: DateTime.parse(map['lastBackup'] as String),
      storageUsagePercent: (map['storageUsagePercent'] as num).toDouble(),
    );
  }

  // ── Notifications ────────────────────────────────────────────────────

  Future<void> saveNotifications(NotificationSettings notifications) async {
    final prefs = await _prefs;
    await prefs.setString(
      _notificationsKey,
      jsonEncode({
        'desktopNotifications': notifications.desktopNotifications,
        'lowStockAlerts': notifications.lowStockAlerts,
        'backupReminder': notifications.backupReminder,
        'subscriptionReminder': notifications.subscriptionReminder,
        'soundEnabled': notifications.soundEnabled,
      }),
    );
  }

  Future<NotificationSettings?> loadNotifications() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_notificationsKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return NotificationSettings(
      desktopNotifications: map['desktopNotifications'] as bool,
      lowStockAlerts: map['lowStockAlerts'] as bool,
      backupReminder: map['backupReminder'] as bool,
      subscriptionReminder: map['subscriptionReminder'] as bool,
      soundEnabled: map['soundEnabled'] as bool,
    );
  }

  // ── Appearance (non-theme-mode fields only — themeMode is owned by
  // ThemePreferenceService and is never read/written here) ────────────

  Future<void> saveAppearanceExtra(AppearanceSettings appearance) async {
    final prefs = await _prefs;
    await prefs.setString(
      _appearanceExtraKey,
      jsonEncode({
        'compactDensity': appearance.compactDensity,
        'animationsEnabled': appearance.animationsEnabled,
        'largeText': appearance.largeText,
      }),
    );
  }

  Future<AppearanceSettings> applyAppearanceExtra(
    AppearanceSettings base,
  ) async {
    final prefs = await _prefs;
    final raw = prefs.getString(_appearanceExtraKey);
    if (raw == null) return base;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return base.copyWith(
      compactDensity: map['compactDensity'] as bool?,
      animationsEnabled: map['animationsEnabled'] as bool?,
      largeText: map['largeText'] as bool?,
    );
  }

  // ── Load-or-seed variants ───────────────────────────────────────────
  //
  // Used once, on startup: if a section was never saved, its default is
  // written to storage immediately and returned, so the app is always
  // running against something actually persisted — never silent
  // in-memory-only defaults. Every load after that first run goes
  // through the plain loadX/applyX methods above and returns exactly
  // what the user last saved.

  Future<GeneralSettings> applyOrSeedGeneralExtra({
    required GeneralSettings base,
    required GeneralSettings defaults,
  }) async {
    final prefs = await _prefs;
    final raw = prefs.getString(_generalExtraKey);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return base.copyWith(
        businessType: map['businessType'] as String?,
        timezone: map['timezone'] as String?,
        language: map['language'] as String?,
        dateFormat: map['dateFormat'] as String?,
        timeFormat: map['timeFormat'] as String?,
      );
    }
    final seeded = base.copyWith(
      businessType: defaults.businessType,
      timezone: defaults.timezone,
      language: defaults.language,
      dateFormat: defaults.dateFormat,
      timeFormat: defaults.timeFormat,
    );
    await saveGeneralExtra(seeded);
    return seeded;
  }

  Future<StoreInfoSettings> loadOrSeedStoreInfo(
    StoreInfoSettings defaults,
  ) async {
    final existing = await loadStoreInfo();
    if (existing != null) return existing;
    await saveStoreInfo(defaults);
    return defaults;
  }

  Future<ReceiptSettings> loadOrSeedReceipt(ReceiptSettings defaults) async {
    final existing = await loadReceipt();
    if (existing != null) return existing;
    await saveReceipt(defaults);
    return defaults;
  }

  Future<InventorySettings> loadOrSeedInventory(
    InventorySettings defaults,
  ) async {
    final existing = await loadInventory();
    if (existing != null) return existing;
    await saveInventory(defaults);
    return defaults;
  }

  Future<SecuritySettings> loadOrSeedSecurity(
    SecuritySettings defaults,
  ) async {
    final existing = await loadSecurity();
    if (existing != null) return existing;
    await saveSecurity(defaults);
    return defaults;
  }

  Future<BackupSettings> loadOrSeedBackup(BackupSettings defaults) async {
    final existing = await loadBackup();
    if (existing != null) return existing;
    await saveBackup(defaults);
    return defaults;
  }

  Future<NotificationSettings> loadOrSeedNotifications(
    NotificationSettings defaults,
  ) async {
    final existing = await loadNotifications();
    if (existing != null) return existing;
    await saveNotifications(defaults);
    return defaults;
  }

  Future<AppearanceSettings> applyOrSeedAppearanceExtra({
    required AppearanceSettings base,
    required AppearanceSettings defaults,
  }) async {
    final prefs = await _prefs;
    final raw = prefs.getString(_appearanceExtraKey);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return base.copyWith(
        compactDensity: map['compactDensity'] as bool?,
        animationsEnabled: map['animationsEnabled'] as bool?,
        largeText: map['largeText'] as bool?,
      );
    }
    final seeded = base.copyWith(
      compactDensity: defaults.compactDensity,
      animationsEnabled: defaults.animationsEnabled,
      largeText: defaults.largeText,
    );
    await saveAppearanceExtra(seeded);
    return seeded;
  }
}
