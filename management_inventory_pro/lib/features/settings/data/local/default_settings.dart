import '../models/settings_model.dart';

/// The Settings feature's baseline values.
///
/// This replaces `mock/mock_settings.dart`. These are no longer "mock"
/// data used to fake a populated UI — they are the app's real defaults.
/// [SettingsCubit] only ever touches this in two places:
///  1. As the synchronous initial state a freshly-constructed Cubit
///     needs before its async load from SQLite/shared_preferences
///     finishes.
///  2. As the seed it writes into storage the very first time the app
///     runs and nothing has been saved yet — after that, every load
///     reads back what was actually saved, never this class again
///     (unless the user explicitly hits "Reset to defaults").
///
/// Values here are deliberately neutral (empty strings, generic labels)
/// rather than fake demo content, and the currency/tax fields mirror the
/// `settings` table's own column defaults so the seeded row and the
/// schema never disagree.
class DefaultSettings {
  DefaultSettings._();

  static const GeneralSettings general = GeneralSettings(
    storeName: 'My Store',
    businessType: '',
    timezone: 'Africa/Cairo',
    language: 'English',
    dateFormat: 'DD/MM/YYYY',
    timeFormat: '24-hour',
  );

  static const StoreInfoSettings storeInfo = StoreInfoSettings(
    logoPath: null,
    phone: '',
    email: '',
    address: '',
    website: '',
    taxNumber: '',
  );

  /// Mirrors DatabaseService's CREATE TABLE defaults for `settings`
  /// (currency 'EGP', currency_symbol 'E£', tax_percentage 14,
  /// tax_enabled 0, prices_include_tax 0) on purpose.
  static const CurrencyTaxSettings currencyTax = CurrencyTaxSettings(
    currency: 'EGP',
    currencySymbol: 'E£',
    decimalPrecision: 2,
    taxPercent: 14,
    taxEnabled: false,
    pricesIncludeTax: false,
  );

  static const ReceiptSettings receipt = ReceiptSettings(
    widthMm: 80,
    header: '',
    footer: '',
    showLogo: true,
    showTax: true,
    showCashier: true,
  );

  /// `defaultUnitId` is deliberately null: units are business data the
  /// user creates via the Units feature, so there is never a safe
  /// hardcoded id to seed here. The app must render correctly with an
  /// empty units table.
  static const InventorySettings inventory = InventorySettings(
    lowStockThreshold: 10,
    criticalStockThreshold: 3,
    allowNegativeStock: false,
    autoSku: true,
    requireBarcode: false,
    defaultUnitId: null,
    enableStockAlerts: true,
  );

  static const SecuritySettings security = SecuritySettings(
    currentUser: '',
    role: 'Administrator',
    rememberLogin: true,
    sessionTimeoutMinutes: 30,
  );

  static final BackupSettings backup = BackupSettings(
    automaticBackup: false,
    backupFolder: '',
    databaseSizeMb: 0,
    lastBackup: DateTime.now(),
    storageUsagePercent: 0,
  );

  static const NotificationSettings notifications = NotificationSettings(
    desktopNotifications: true,
    lowStockAlerts: true,
    backupReminder: true,
    subscriptionReminder: false,
    soundEnabled: true,
  );

  static const AppearanceSettings appearance = AppearanceSettings(
    compactDensity: false,
    animationsEnabled: true,
    largeText: false,
    themeMode: ThemeModeOption.system,
  );

  static const AboutInfo about = AboutInfo(
    appName: 'Inventory Pro',
    version: '1.0.0',
    databaseVersion: 'v1',
    licenseStatus: LicenseStatus.active,
    subscriptionPlan: SubscriptionPlan.free,
    supportEmail: '',
  );

  static SettingsModel build() {
    return SettingsModel(
      general: general,
      storeInfo: storeInfo,
      currencyTax: currencyTax,
      receipt: receipt,
      inventory: inventory,
      security: security,
      backup: backup,
      notifications: notifications,
      appearance: appearance,
      about: about,
    );
  }
}
