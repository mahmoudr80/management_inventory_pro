import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_constants.dart';
import '../../../../core/networking/api_error_model.dart';
import '../../../../core/networking/api_result.dart';

/// Raw SQLite access for the `settings` table.
///
/// The table is a single-row config table (`id` is CHECK'd to always be
/// 1), so this reduces to "read the one row" / "upsert the one row".
/// No business logic and no mapping to UI models here — see
/// [SettingsRepository] for that.
class SettingsLocalDatasource {
  final Database _database;

  const SettingsLocalDatasource(this._database);

  static const int _singletonRowId = 1;

  Future<ApiResult<Map<String, dynamic>?>> getSettings() async {
    try {
      final rows = await _database.query(
        DatabaseConstants.settingsTable,
        where: '${DatabaseConstants.idColumn} = ?',
        whereArgs: [_singletonRowId],
        limit: 1,
      );
      return ApiResult.success(rows.isEmpty ? null : rows.first);
    } catch (e) {
      return ApiResult.failure(
        ApiErrorModel(message: 'Could not load settings'),
      );
    }
  }

  /// Inserts the single settings row if it doesn't exist yet, or
  /// overwrites it otherwise. [values] should NOT include the id column;
  /// it's added here since this table only ever has one row.
  Future<ApiResult<int>> saveSettings(Map<String, dynamic> values) async {
    try {
      final data = {
        DatabaseConstants.idColumn: _singletonRowId,
        ...values,
      };
      final id = await _database.insert(
        DatabaseConstants.settingsTable,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return ApiResult.success(id);
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }
}
