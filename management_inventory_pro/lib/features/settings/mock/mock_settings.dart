import '../models/settings_model.dart';

/// Realistic mock data for Inventory Pro's Settings screen.
///
/// Stands in for a repository until persistence is wired up — the Cubit
/// depends only on this function returning a [SettingsModel], so swapping
/// it for a real data source later is a one-line change.
class MockSettings {
  MockSettings._();

  static SettingsModel build() {
    return SettingsModel(
      general: const GeneralSettings(
        storeName: 'Electro Store',
        businessType: 'Electronics Retail',
        timezone: 'Africa/Cairo',
        language: 'English',
        dateFormat: 'DD/MM/YYYY',
        timeFormat: '24-hour',
      ),
      storeInfo: const StoreInfoSettings(
        logoPath: null,
        phone: '+20 100 234 5678',
        email: 'admin@electro-store.com',
        address: '14 El Nasr Street, Nasr City, Cairo',
        website: 'www.electro-store.com',
        taxNumber: 'TX-4471-EG-2024',
      ),
      currencyTax: const CurrencyTaxSettings(
        currency: 'EGP',
        currencySymbol: 'ج.م',
        decimalPrecision: 2,
        taxPercent: 14,
        taxEnabled: true,
        pricesIncludeTax: false,
      ),
      receipt: const ReceiptSettings(
        widthMm: 80,
        header: 'Electro Store — Thank you for shopping with us',
        footer: 'All sales are final after 14 days. Keep this receipt.',
        showLogo: true,
        showTax: true,
        showCashier: true,
      ),
      inventory: const InventorySettings(
        lowStockThreshold: 15,
        criticalStockThreshold: 5,
        allowNegativeStock: false,
        autoSku: true,
        requireBarcode: false,
        defaultUnit: 'Piece',
        enableStockAlerts: true,
      ),
      security: const SecuritySettings(
        currentUser: 'Mahmoud Saeid',
        role: 'Store Administrator',
        rememberLogin: true,
        sessionTimeoutMinutes: 30,
      ),
      backup: BackupSettings(
        automaticBackup: true,
        backupFolder: 'D:/InventoryPro/Backups',
        databaseSizeMb: 28.4,
        lastBackup: DateTime.now().subtract(const Duration(hours: 6)),
        storageUsagePercent: 42,
      ),
      notifications: const NotificationSettings(
        desktopNotifications: true,
        lowStockAlerts: true,
        backupReminder: true,
        subscriptionReminder: false,
        soundEnabled: true,
      ),
      appearance: const AppearanceSettings(
        compactDensity: false,
        animationsEnabled: true,
        largeText: false,
        themeMode: ThemeModeOption.light,
      ),
      about: const AboutInfo(
        appName: 'Inventory Pro',
        version: '4.2.0-PRO',
        databaseVersion: 'v18',
        licenseStatus: LicenseStatus.active,
        subscriptionPlan: SubscriptionPlan.business,
        supportEmail: 'support@inventorypro.app',
      ),
    );
  }
}
