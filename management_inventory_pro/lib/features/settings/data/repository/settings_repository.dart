import '../../../../core/networking/api_result.dart';
import '../datasource/settings_local_datasource.dart';
import '../models/settings_business_data.dart';

/// UI ↔ SQLite boundary for the settings business fields (store name,
/// currency & tax). No SQL lives here — that's [SettingsLocalDatasource].
class SettingsRepository {
  final SettingsLocalDatasource _datasource;

  const SettingsRepository(this._datasource);

  /// Returns `null` (wrapped in success) when no row has been saved yet
  /// — i.e. first run, before the user has hit Save once.
  Future<ApiResult<SettingsBusinessData?>> getBusinessSettings() async {
    final result = await _datasource.getSettings();
    return switch (result) {
      Success(data: final row) => ApiResult.success(
          row == null ? null : SettingsBusinessData.fromMap(row),
        ),
      Failure(errorModel: final error) => ApiResult.failure(error),
    };
  }

  Future<ApiResult<int>> saveBusinessSettings(
    SettingsBusinessData data,
  ) async {
    return _datasource.saveSettings(data.toMap());
  }

  /// Returns the saved row if one exists; otherwise writes [defaults] as
  /// the very first row and returns that. Used on startup so the app
  /// never runs against in-memory-only mock data — first run always
  /// results in a real row being persisted.
  Future<ApiResult<SettingsBusinessData>> getOrSeedBusinessSettings(
    SettingsBusinessData defaults,
  ) async {
    final existing = await getBusinessSettings();
    return switch (existing) {
      Success(data: final data) when data != null => ApiResult.success(data),
      Success() => await _seed(defaults),
      Failure(errorModel: final error) => ApiResult.failure(error),
    };
  }

  Future<ApiResult<SettingsBusinessData>> _seed(
    SettingsBusinessData defaults,
  ) async {
    final saveResult = await saveBusinessSettings(defaults);
    return switch (saveResult) {
      Success() => ApiResult.success(defaults),
      Failure(errorModel: final error) => ApiResult.failure(error),
    };
  }
}
