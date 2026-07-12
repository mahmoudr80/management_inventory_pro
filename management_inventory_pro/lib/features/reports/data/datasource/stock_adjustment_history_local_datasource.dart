import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/report_filter_state.dart';
import '../models/stock_adjustment_history_model.dart';
import 'reports_query_helpers.dart';

class ReportsStockAdjustmentHistoryLocalDataSource {
  final Database db;

  ReportsStockAdjustmentHistoryLocalDataSource(this.db);

  static const _sa = 'sa';

  static const statusFilterKey = 'status';

  (String, List<Object?>)? _statusWhere(ReportFilterState filters) =>
      ReportQueryHelpers.equalsWhere('$_sa.${DatabaseConstants.statusColumn}', filters.extraValue(statusFilterKey));

  (String, List<Object?>)? _productWhere(ReportFilterState filters) => ReportQueryHelpers.existsWhere(
    '''
      SELECT 1 FROM ${DatabaseConstants.stockAdjustmentItemsTable} sai
      WHERE sai.${DatabaseConstants.stockAdjustmentIdColumn} = $_sa.${DatabaseConstants.idColumn}
        AND sai.${DatabaseConstants.productIdColumn} = ?
      ''',
    filters.extraValue(ReportFilterState.productFilterKey),
  );

  (String, List<Object?>) _whereClause(ReportFilterState filters) {
    final dateRange = ReportQueryHelpers.dateRangeWhere(
      '$_sa.${DatabaseConstants.createdAtColumn}',
      filters.dateRange.startIso,
      filters.dateRange.endIso,
    );
    final search = ReportQueryHelpers.likeWhere('$_sa.${DatabaseConstants.idColumn}', filters.searchQuery);
    return ReportQueryHelpers.combine([dateRange, search, _statusWhere(filters), _productWhere(filters)]);
  }

  /// Phase 4 addition — dictionary lookup for the screen's Product filter
  /// dropdown, same pattern as fetchSupplierOptions elsewhere.
  Future<List<(String value, String label)>> fetchProductOptions() async {
    final result = await db.rawQuery('''
    SELECT ${DatabaseConstants.idColumn} AS id, ${DatabaseConstants.nameColumn} AS name
    FROM ${DatabaseConstants.productTable}
    ORDER BY ${DatabaseConstants.nameColumn} ASC
  ''');
    return result.map((r) => ('${r['id']}', r['name'] as String)).toList();
  }

  /// Distinct statuses actually present on stock_adjustments, rather than
  /// a hardcoded enum list — keeps the dropdown honest if new statuses
  /// are introduced without a code change here.
  Future<List<(String value, String label)>> fetchStatusOptions() async {
    final result = await db.rawQuery('''
    SELECT DISTINCT ${DatabaseConstants.statusColumn} AS status
    FROM ${DatabaseConstants.stockAdjustmentsTable}
    WHERE ${DatabaseConstants.statusColumn} IS NOT NULL
    ORDER BY ${DatabaseConstants.statusColumn} ASC
  ''');
    return result.map((r) => (r['status'] as String, r['status'] as String)).toList();
  }

  Future<StockAdjustmentHistorySummary> _fetchSummary(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    final result = await db.rawQuery('''
      SELECT
        COUNT(*) AS adjustments,
        COALESCE(SUM($_sa.${DatabaseConstants.totalInventoryValueChangeColumn}), 0) AS value_impact
      FROM ${DatabaseConstants.stockAdjustmentsTable} $_sa
      $whereSql
    ''', args);

    final row = result.first;
    return StockAdjustmentHistorySummary(
      adjustments: (row['adjustments'] as int?) ?? 0,
      inventoryValueImpact: (row['value_impact'] as num?)?.toDouble() ?? 0,
    );
  }

  Future<(List<StockAdjustmentHistoryRow>, int)> _fetchRows(
    ReportFilterState filters, {
    required int page,
    required int pageSize,
  }) async {
    final (whereSql, args) = _whereClause(filters);

    final countResult = await db.rawQuery('''
      SELECT COUNT(*) AS total FROM ${DatabaseConstants.stockAdjustmentsTable} $_sa $whereSql
    ''', args);
    final totalEntries = (countResult.first['total'] as int?) ?? 0;

    final offset = (page - 1) * pageSize;
    final rows = await db.rawQuery('''
      SELECT
        $_sa.${DatabaseConstants.idColumn} AS adjustment_id,
        $_sa.${DatabaseConstants.reasonColumn} AS reason,
        $_sa.${DatabaseConstants.totalItemColumn} AS items,
        $_sa.${DatabaseConstants.totalInventoryValueChangeColumn} AS value_impact,
        $_sa.${DatabaseConstants.createdByColumn} AS created_by,
        $_sa.${DatabaseConstants.statusColumn} AS status,
        $_sa.${DatabaseConstants.createdAtColumn} AS created_at
      FROM ${DatabaseConstants.stockAdjustmentsTable} $_sa
      $whereSql
      ORDER BY $_sa.${DatabaseConstants.createdAtColumn} DESC
      LIMIT ? OFFSET ?
    ''', [...args, pageSize, offset]);

    final mapped = rows
        .map((r) => StockAdjustmentHistoryRow(
              adjustmentNumber: r['adjustment_id'] as String,
              reason: (r['reason'] as String?) ?? '',
              items: (r['items'] as int?) ?? 0,
              valueImpact: (r['value_impact'] as num?)?.toDouble() ?? 0,
              createdBy: (r['created_by'] as String?) ?? '',
              status: (r['status'] as String?) ?? '',
              date: DateTime.parse(r['created_at'] as String),
            ))
        .toList();

    return (mapped, totalEntries);
  }

  Future<StockAdjustmentHistoryData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final summary = await _fetchSummary(filters);
    final (rows, totalEntries) = await _fetchRows(filters, page: page, pageSize: pageSize);
    return StockAdjustmentHistoryData(summary: summary, rows: rows, totalEntries: totalEntries);
  }
}
