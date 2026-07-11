import '../../../../core/database/database_constants.dart';

/// Data-layer shape for the fields backed by SQLite (`settings` table).
///
/// Deliberately separate from [GeneralSettings] / [CurrencyTaxSettings]
/// in `settings_model.dart` — those are the UI's full editable shape and
/// carry fields (businessType, timezone, ...) that have no database
/// column. This is exactly what persists to SQLite; nothing more.
/// [SettingsRepository] maps between the two so the UI model never needs
/// to know about this class.
class SettingsBusinessData {
  final String storeName;
  final String currency;
  final String currencySymbol;
  final bool taxEnabled;
  final double taxPercentage;
  final bool pricesIncludeTax;

  const SettingsBusinessData({
    required this.storeName,
    required this.currency,
    required this.currencySymbol,
    required this.taxEnabled,
    required this.taxPercentage,
    required this.pricesIncludeTax,
  });

  factory SettingsBusinessData.fromMap(Map<String, dynamic> map) {
    return SettingsBusinessData(
      storeName: map[DatabaseConstants.storeNameColumn] as String,
      currency: map[DatabaseConstants.currencyColumn] as String,
      currencySymbol: map[DatabaseConstants.currencySymbolColumn] as String,
      taxEnabled: (map[DatabaseConstants.taxEnabledColumn] as int) == 1,
      taxPercentage:
          (map[DatabaseConstants.taxPercentageColumn] as num).toDouble(),
      pricesIncludeTax:
          (map[DatabaseConstants.pricesIncludeTaxColumn] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.storeNameColumn: storeName,
      DatabaseConstants.currencyColumn: currency,
      DatabaseConstants.currencySymbolColumn: currencySymbol,
      DatabaseConstants.taxEnabledColumn: taxEnabled ? 1 : 0,
      DatabaseConstants.taxPercentageColumn: taxPercentage,
      DatabaseConstants.pricesIncludeTaxColumn: pricesIncludeTax ? 1 : 0,
    };
  }
}
