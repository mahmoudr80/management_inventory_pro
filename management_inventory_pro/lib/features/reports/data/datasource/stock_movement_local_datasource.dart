import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/report_filter_state.dart';
import '../models/stock_movement_model.dart';
import 'reports_query_helpers.dart';

/// The only report that unions three independently-shaped tables (sales,
/// stock entries, stock adjustments) into one ledger. Each source is
/// normalized to the same columns (date, product, type, quantity,
/// reference, created_by, reason, sale_status) before the UNION ALL, so
/// the outer query (date-range + search + extra filters + pagination +
/// the summary/trend aggregates) only has to know about that common
/// shape, not any individual table.
class StockMovementLocalDataSource {
  final Database db;

  StockMovementLocalDataSource(this.db);

  static const _scratchTable = 'stock_movement_scratch';

  /// One normalized SELECT per source. Quantity is signed (+in, -out) so
  /// summary/trend aggregates can just SUM() without a CASE per source.
  /// `sale_status` is NULL for purchase/adjustment rows — only sales
  /// have a status to filter on (see [_statusWhere]).
  String get _unionSql => '''
    SELECT
      s.${DatabaseConstants.createdAtColumn} AS movement_date,
      p.${DatabaseConstants.idColumn} AS product_id,
      p.${DatabaseConstants.skuColumn} AS product_sku,
      p.${DatabaseConstants.nameColumn} AS product_name,
      'sale' AS movement_type,
      -si.${DatabaseConstants.quantityColumn} AS quantity,
      s.${DatabaseConstants.idColumn} AS reference_id,
      s.${DatabaseConstants.cashierNameColumn} AS created_by,
      NULL AS reason,
      s.${DatabaseConstants.statusColumn} AS sale_status
    FROM ${DatabaseConstants.saleItemTable} si
    JOIN ${DatabaseConstants.saleTable} s ON s.${DatabaseConstants.idColumn} = si.${DatabaseConstants.saleIdColumn}
    JOIN ${DatabaseConstants.productTable} p ON p.${DatabaseConstants.idColumn} = si.${DatabaseConstants.productIdColumn}

    UNION ALL

    SELECT
      se.${DatabaseConstants.receiptDateColumn} AS movement_date,
      p.${DatabaseConstants.idColumn} AS product_id,
      p.${DatabaseConstants.skuColumn} AS product_sku,
      p.${DatabaseConstants.nameColumn} AS product_name,
      'purchase' AS movement_type,
      sei.${DatabaseConstants.quantityColumn} AS quantity,
      se.${DatabaseConstants.idColumn} AS reference_id,
      se.${DatabaseConstants.receivedByColumn} AS created_by,
      se.${DatabaseConstants.noteColumn} AS reason,
      NULL AS sale_status
    FROM ${DatabaseConstants.stockEntryItemTable} sei
    JOIN ${DatabaseConstants.stockEntryTable} se ON se.${DatabaseConstants.idColumn} = sei.${DatabaseConstants.stockEntryIdColumn}
    JOIN ${DatabaseConstants.productTable} p ON p.${DatabaseConstants.idColumn} = sei.${DatabaseConstants.productIdColumn}

    UNION ALL

    SELECT
      sa.${DatabaseConstants.createdAtColumn} AS movement_date,
      p.${DatabaseConstants.idColumn} AS product_id,
      p.${DatabaseConstants.skuColumn} AS product_sku,
      p.${DatabaseConstants.nameColumn} AS product_name,
      'adjustment' AS movement_type,
      sai.${DatabaseConstants.adjustmentQuantityColumn} AS quantity,
      sa.${DatabaseConstants.idColumn} AS reference_id,
      sa.${DatabaseConstants.createdByColumn} AS created_by,
      sa.${DatabaseConstants.reasonColumn} AS reason,
      NULL AS sale_status
    FROM ${DatabaseConstants.stockAdjustmentItemsTable} sai
    JOIN ${DatabaseConstants.stockAdjustmentsTable} sa ON sa.${DatabaseConstants.idColumn} = sai.${DatabaseConstants.stockAdjustmentIdColumn}
    JOIN ${DatabaseConstants.productTable} p ON p.${DatabaseConstants.idColumn} = sai.${DatabaseConstants.productIdColumn}
  ''';

  static const movementTypeFilterKey = 'movementType';

  static const movementTypeOptions = <(String value, String label)>[
    ('sale', 'Sale'),
    ('purchase', 'Purchase'),
    ('adjustment', 'Adjustment'),
  ];

  (String, List<Object?>)? _movementTypeWhere(ReportFilterState filters) =>
      ReportQueryHelpers.equalsWhere('movement_type', filters.extraValue(movementTypeFilterKey));

  (String, List<Object?>)? _productWhere(ReportFilterState filters) =>
      ReportQueryHelpers.equalsWhere('product_id', filters.extraValue(ReportFilterState.productFilterKey));

  (String, List<Object?>)? _statusWhere(ReportFilterState filters) {
    final status = filters.extraValue(ReportFilterState.saleStatusFilterKey);
    if (status == null || status.trim().isEmpty) return null;
    return ("(movement_type != 'sale' OR sale_status = ?)", [status]);
  }

  /// FIX: previously only `dateRange` and `search` were combined here —
  /// `_movementTypeWhere`, `_productWhere`, and `_statusWhere` were fully
  /// implemented but never referenced, so selecting a Movement Type,
  /// Product, or Sale Status filter had no effect on the query at all.
  /// All five fragments must be present for the "Professional Filters"
  /// to actually narrow the result set.
  (String, List<Object?>) _whereClause(ReportFilterState filters) {
    final dateRange = ReportQueryHelpers.dateRangeWhere(
      'movement_date',
      filters.dateRange.startIso,
      filters.dateRange.endIso,
    );
    final search = ReportQueryHelpers.productSearchWhere('product_name', 'product_sku', filters.searchQuery);
    return ReportQueryHelpers.combine([
      dateRange,
      search,
      _movementTypeWhere(filters),
      _productWhere(filters),
      _statusWhere(filters),
    ]);
  }

  /// Runs the UNION ALL + WHERE exactly once and drops the already
  /// filtered result into a temp table. Temp tables are connection-
  /// scoped in SQLite; wrapping the whole fetch in [db.transaction]
  /// serializes access on sqflite's single connection so no other
  /// operation can interleave between create and drop.
  Future<void> _materialize(Transaction txn, String whereSql, List<Object?> args) async {
    await txn.execute('DROP TABLE IF EXISTS $_scratchTable');
    await txn.execute('''
      CREATE TEMP TABLE $_scratchTable AS
      SELECT * FROM ($_unionSql)
      $whereSql
    ''', args);
  }

  /// Dictionary lookup for the screen's Product filter dropdown, same
  /// pattern as fetchSupplierOptions elsewhere.
  Future<List<(String value, String label)>> fetchProductOptions() async {
    final result = await db.rawQuery('''
      SELECT ${DatabaseConstants.idColumn} AS id, ${DatabaseConstants.nameColumn} AS name
      FROM ${DatabaseConstants.productTable}
      ORDER BY ${DatabaseConstants.nameColumn} ASC
    ''');
    return result.map((r) => ('${r['id']}', r['name'] as String)).toList();
  }

  Future<StockMovementSummary> _fetchSummary(Transaction txn) async {
    final result = await txn.rawQuery('''
      SELECT
        COALESCE(SUM(CASE WHEN movement_type = 'purchase' THEN quantity ELSE 0 END), 0) AS total_inbound,
        COALESCE(SUM(CASE WHEN movement_type = 'sale' THEN -quantity ELSE 0 END), 0) AS total_outbound,
        COALESCE(SUM(CASE WHEN movement_type = 'adjustment' THEN ABS(quantity) ELSE 0 END), 0) AS total_adjustments
      FROM $_scratchTable
    ''');

    final row = result.first;
    return StockMovementSummary(
      totalInbound: (row['total_inbound'] as num?)?.toDouble() ?? 0,
      totalOutbound: (row['total_outbound'] as num?)?.toDouble() ?? 0,
      totalAdjustments: (row['total_adjustments'] as num?)?.toDouble() ?? 0,
    );
  }

  Future<List<StockMovementTrendPoint>> _fetchTrend(Transaction txn) async {
    final result = await txn.rawQuery('''
      SELECT
        strftime('%Y-%m-%d', movement_date) AS day,
        COALESCE(SUM(CASE WHEN movement_type = 'purchase' THEN quantity ELSE 0 END), 0) AS inbound,
        COALESCE(SUM(CASE WHEN movement_type = 'sale' THEN -quantity ELSE 0 END), 0) AS outbound,
        COALESCE(SUM(CASE WHEN movement_type = 'adjustment' THEN ABS(quantity) ELSE 0 END), 0) AS adjustments
      FROM $_scratchTable
      GROUP BY day
      ORDER BY day ASC
    ''');

    return result
        .map((r) => StockMovementTrendPoint(
      label: r['day'] as String,
      inbound: (r['inbound'] as num?)?.toDouble() ?? 0,
      outbound: (r['outbound'] as num?)?.toDouble() ?? 0,
      adjustments: (r['adjustments'] as num?)?.toDouble() ?? 0,
    ))
        .toList();
  }

  Future<(List<StockMovementRow>, int)> _fetchRows(
      Transaction txn, {
        required int page,
        required int pageSize,
      }) async {
    final countResult = await txn.rawQuery('SELECT COUNT(*) AS total FROM $_scratchTable');
    final totalEntries = (countResult.first['total'] as int?) ?? 0;

    final offset = (page - 1) * pageSize;
    final rows = await txn.rawQuery('''
      SELECT * FROM $_scratchTable
      ORDER BY movement_date DESC
      LIMIT ? OFFSET ?
    ''', [pageSize, offset]);

    final mapped = rows.map((r) {
      final typeStr = r['movement_type'] as String;
      final type = switch (typeStr) {
        'sale' => StockMovementType.sale,
        'purchase' => StockMovementType.purchase,
        _ => StockMovementType.adjustment,
      };
      return StockMovementRow(
        date: DateTime.parse(r['movement_date'] as String),
        productSku: (r['product_sku'] as String?) ?? '',
        productName: r['product_name'] as String,
        type: type,
        quantity: (r['quantity'] as num?)?.toDouble() ?? 0,
        referenceId: r['reference_id'] as String,
        createdBy: (r['created_by'] as String?) ?? '',
        reason: r['reason'] as String?,
      );
    }).toList();

    return (mapped, totalEntries);
  }

  Future<StockMovementData> fetch(
      ReportFilterState filters, {
        int page = 1,
        int pageSize = 20,
      }) async {
    final (whereSql, args) = _whereClause(filters);

    return db.transaction((txn) async {
      await _materialize(txn, whereSql, args);
      try {
        final summary = await _fetchSummary(txn);
        final trend = await _fetchTrend(txn);
        final (rows, totalEntries) = await _fetchRows(txn, page: page, pageSize: pageSize);
        return StockMovementData(summary: summary, trend: trend, rows: rows, totalEntries: totalEntries);
      } finally {
        // Always clean up, even if one of the aggregate queries throws.
        await txn.execute('DROP TABLE IF EXISTS $_scratchTable');
      }
    });
  }
}