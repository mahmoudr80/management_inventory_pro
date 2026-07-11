/// Data models for the Settings feature.
///
/// Grouped by section so each `copyWith` stays small and each section
/// widget only ever touches the slice of settings it owns. `SettingsModel`
/// composes them into a single immutable snapshot the Cubit holds in state.
library settings_model;

enum ThemeModeOption { light, dark, system }

enum SubscriptionPlan { free, starter, business, enterprise }

enum LicenseStatus { active, trial, expired }

// ── General ──────────────────────────────────────────────────────────────

class GeneralSettings {
  final String storeName;
  final String businessType;
  final String timezone;
  final String language;
  final String dateFormat;
  final String timeFormat;

  const GeneralSettings({
    required this.storeName,
    required this.businessType,
    required this.timezone,
    required this.language,
    required this.dateFormat,
    required this.timeFormat,
  });

  GeneralSettings copyWith({
    String? storeName,
    String? businessType,
    String? timezone,
    String? language,
    String? dateFormat,
    String? timeFormat,
  }) {
    return GeneralSettings(
      storeName: storeName ?? this.storeName,
      businessType: businessType ?? this.businessType,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
    );
  }
}

// ── Store Information ───────────────────────────────────────────────────

class StoreInfoSettings {
  final String? logoPath;
  final String phone;
  final String email;
  final String address;
  final String website;
  final String taxNumber;

  const StoreInfoSettings({
    this.logoPath,
    required this.phone,
    required this.email,
    required this.address,
    required this.website,
    required this.taxNumber,
  });

  StoreInfoSettings copyWith({
    String? logoPath,
    String? phone,
    String? email,
    String? address,
    String? website,
    String? taxNumber,
  }) {
    return StoreInfoSettings(
      logoPath: logoPath ?? this.logoPath,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      website: website ?? this.website,
      taxNumber: taxNumber ?? this.taxNumber,
    );
  }
}

// ── Currency & Tax ──────────────────────────────────────────────────────

class CurrencyTaxSettings {
  final String currency;
  final String currencySymbol;
  final int decimalPrecision;
  final double taxPercent;
  final bool taxEnabled;
  final bool pricesIncludeTax;

  const CurrencyTaxSettings({
    required this.currency,
    required this.currencySymbol,
    required this.decimalPrecision,
    required this.taxPercent,
    required this.taxEnabled,
    required this.pricesIncludeTax,
  });

  CurrencyTaxSettings copyWith({
    String? currency,
    String? currencySymbol,
    int? decimalPrecision,
    double? taxPercent,
    bool? taxEnabled,
    bool? pricesIncludeTax,
  }) {
    return CurrencyTaxSettings(
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      taxPercent: taxPercent ?? this.taxPercent,
      taxEnabled: taxEnabled ?? this.taxEnabled,
      pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
    );
  }
}

// ── Receipt ──────────────────────────────────────────────────────────────

class ReceiptSettings {
  final int widthMm;
  final String header;
  final String footer;
  final bool showLogo;
  final bool showTax;
  final bool showCashier;

  const ReceiptSettings({
    required this.widthMm,
    required this.header,
    required this.footer,
    required this.showLogo,
    required this.showTax,
    required this.showCashier,
  });

  ReceiptSettings copyWith({
    int? widthMm,
    String? header,
    String? footer,
    bool? showLogo,
    bool? showTax,
    bool? showCashier,
  }) {
    return ReceiptSettings(
      widthMm: widthMm ?? this.widthMm,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      showLogo: showLogo ?? this.showLogo,
      showTax: showTax ?? this.showTax,
      showCashier: showCashier ?? this.showCashier,
    );
  }
}

// ── Inventory ────────────────────────────────────────────────────────────

class InventorySettings {
  final int lowStockThreshold;
  final int criticalStockThreshold;
  final bool allowNegativeStock;
  final bool autoSku;
  final bool requireBarcode;
  /// References `UnitModel.id`. `null` means "nothing selected" — a
  /// valid, expected state whenever the units table is empty or the
  /// user hasn't picked one yet. Can also go stale if the unit is later
  /// deleted; see `DefaultUnitDropdown` for the self-healing check.
  final int? defaultUnitId;
  final bool enableStockAlerts;

  const InventorySettings({
    required this.lowStockThreshold,
    required this.criticalStockThreshold,
    required this.allowNegativeStock,
    required this.autoSku,
    required this.requireBarcode,
    this.defaultUnitId,
    required this.enableStockAlerts,
  });

  InventorySettings copyWith({
    int? lowStockThreshold,
    int? criticalStockThreshold,
    bool? allowNegativeStock,
    bool? autoSku,
    bool? requireBarcode,
    int? defaultUnitId,
    bool clearDefaultUnitId = false,
    bool? enableStockAlerts,
  }) {
    return InventorySettings(
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      criticalStockThreshold: criticalStockThreshold ?? this.criticalStockThreshold,
      allowNegativeStock: allowNegativeStock ?? this.allowNegativeStock,
      autoSku: autoSku ?? this.autoSku,
      requireBarcode: requireBarcode ?? this.requireBarcode,
      defaultUnitId: clearDefaultUnitId ? null : (defaultUnitId ?? this.defaultUnitId),
      enableStockAlerts: enableStockAlerts ?? this.enableStockAlerts,
    );
  }
}

// ── Users & Security ─────────────────────────────────────────────────────

class SecuritySettings {
  final String currentUser;
  final String role;
  final bool rememberLogin;
  final int sessionTimeoutMinutes;

  const SecuritySettings({
    required this.currentUser,
    required this.role,
    required this.rememberLogin,
    required this.sessionTimeoutMinutes,
  });

  SecuritySettings copyWith({
    String? currentUser,
    String? role,
    bool? rememberLogin,
    int? sessionTimeoutMinutes,
  }) {
    return SecuritySettings(
      currentUser: currentUser ?? this.currentUser,
      role: role ?? this.role,
      rememberLogin: rememberLogin ?? this.rememberLogin,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
    );
  }
}

// ── Backup & Restore ─────────────────────────────────────────────────────

class BackupSettings {
  final bool automaticBackup;
  final String backupFolder;
  final double databaseSizeMb;
  final DateTime lastBackup;
  final double storageUsagePercent;

  const BackupSettings({
    required this.automaticBackup,
    required this.backupFolder,
    required this.databaseSizeMb,
    required this.lastBackup,
    required this.storageUsagePercent,
  });

  BackupSettings copyWith({
    bool? automaticBackup,
    String? backupFolder,
    double? databaseSizeMb,
    DateTime? lastBackup,
    double? storageUsagePercent,
  }) {
    return BackupSettings(
      automaticBackup: automaticBackup ?? this.automaticBackup,
      backupFolder: backupFolder ?? this.backupFolder,
      databaseSizeMb: databaseSizeMb ?? this.databaseSizeMb,
      lastBackup: lastBackup ?? this.lastBackup,
      storageUsagePercent: storageUsagePercent ?? this.storageUsagePercent,
    );
  }
}

// ── Notifications ────────────────────────────────────────────────────────

class NotificationSettings {
  final bool desktopNotifications;
  final bool lowStockAlerts;
  final bool backupReminder;
  final bool subscriptionReminder;
  final bool soundEnabled;

  const NotificationSettings({
    required this.desktopNotifications,
    required this.lowStockAlerts,
    required this.backupReminder,
    required this.subscriptionReminder,
    required this.soundEnabled,
  });

  NotificationSettings copyWith({
    bool? desktopNotifications,
    bool? lowStockAlerts,
    bool? backupReminder,
    bool? subscriptionReminder,
    bool? soundEnabled,
  }) {
    return NotificationSettings(
      desktopNotifications: desktopNotifications ?? this.desktopNotifications,
      lowStockAlerts: lowStockAlerts ?? this.lowStockAlerts,
      backupReminder: backupReminder ?? this.backupReminder,
      subscriptionReminder: subscriptionReminder ?? this.subscriptionReminder,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

// ── Appearance ───────────────────────────────────────────────────────────

class AppearanceSettings {
  final bool compactDensity;
  final bool animationsEnabled;
  final bool largeText;
  final ThemeModeOption themeMode;

  const AppearanceSettings({
    required this.compactDensity,
    required this.animationsEnabled,
    required this.largeText,
    required this.themeMode,
  });

  AppearanceSettings copyWith({
    bool? compactDensity,
    bool? animationsEnabled,
    bool? largeText,
    ThemeModeOption? themeMode,
  }) {
    return AppearanceSettings(
      compactDensity: compactDensity ?? this.compactDensity,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      largeText: largeText ?? this.largeText,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

// ── About (read-only, but modeled for a future remote config source) ────

class AboutInfo {
  final String appName;
  final String version;
  final String databaseVersion;
  final LicenseStatus licenseStatus;
  final SubscriptionPlan subscriptionPlan;
  final String supportEmail;

  const AboutInfo({
    required this.appName,
    required this.version,
    required this.databaseVersion,
    required this.licenseStatus,
    required this.subscriptionPlan,
    required this.supportEmail,
  });
}

// ── Composite root ──────────────────────────────────────────────────────

class SettingsModel {
  final GeneralSettings general;
  final StoreInfoSettings storeInfo;
  final CurrencyTaxSettings currencyTax;
  final ReceiptSettings receipt;
  final InventorySettings inventory;
  final SecuritySettings security;
  final BackupSettings backup;
  final NotificationSettings notifications;
  final AppearanceSettings appearance;
  final AboutInfo about;

  const SettingsModel({
    required this.general,
    required this.storeInfo,
    required this.currencyTax,
    required this.receipt,
    required this.inventory,
    required this.security,
    required this.backup,
    required this.notifications,
    required this.appearance,
    required this.about,
  });

  SettingsModel copyWith({
    GeneralSettings? general,
    StoreInfoSettings? storeInfo,
    CurrencyTaxSettings? currencyTax,
    ReceiptSettings? receipt,
    InventorySettings? inventory,
    SecuritySettings? security,
    BackupSettings? backup,
    NotificationSettings? notifications,
    AppearanceSettings? appearance,
    AboutInfo? about,
  }) {
    return SettingsModel(
      general: general ?? this.general,
      storeInfo: storeInfo ?? this.storeInfo,
      currencyTax: currencyTax ?? this.currencyTax,
      receipt: receipt ?? this.receipt,
      inventory: inventory ?? this.inventory,
      security: security ?? this.security,
      backup: backup ?? this.backup,
      notifications: notifications ?? this.notifications,
      appearance: appearance ?? this.appearance,
      about: about ?? this.about,
    );
  }
}
