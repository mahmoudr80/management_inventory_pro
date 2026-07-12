// lib/features/reports/data/datasource/low_stock_local_datasource.dart
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/low_stock_model.dart';
import '../models/report_filter_state.dart';
import 'reports_query_helpers.dart';

/// Point-in-time report, same reasoning as [InventoryValuationLocalDataSource]
/// — [filters.dateRange] is accepted but not applied; [searchQuery] and,
/// as of Phase 3 Part 2/3, `filters.extra[supplierFilterKey]` filter
/// rows. "Supplier" and "Last Stock Entry" aren't columns on `products`
/// (a product has no direct supplier FK — only stock_entries do), so
/// both are derived from each product's most recent stock entry via a
/// correlated subquery. A product that has never had a stock entry
/// shows both as null/blank, and is excluded by the supplier filter
/// (there's no supplier to match against).
class LowStockLocalDataSource {
  final Database db;

  LowStockLocalDataSource(this.db);

  static const _p = 'p';

  /// Key this datasource reads from `filters.extra`.
  static const supplierFilterKey = 'supplierId';

  static const _threshold = '''
    $_p.${DatabaseConstants.currentStockColumn} > 0
    AND $_p.${DatabaseConstants.currentStockColumn} <= $_p.${DatabaseConstants.minimumStockColumn}
  ''';

  (String, List<Object?>)? _supplierWhere(ReportFilterState filters) {
    final supplierId = filters.extraValue(supplierFilterKey);
    if (supplierId == null || supplierId.trim().isEmpty) return null;
    // References the `sup` alias from `_lastEntryJoin` — the same
    // supplier surfaced in the "Supplier" column is what this filters
    // against.
    return ('sup.${DatabaseConstants.idColumn} = ?', [supplierId]);
  }

  (String, List<Object?>) _whereClause(ReportFilterState filters) {
    final search = ReportQueryHelpers.productSearchWhere(
      '$_p.${DatabaseConstants.nameColumn}',
      '$_p.${DatabaseConstants.skuColumn}',
      filters.searchQuery,
    );
    return ReportQueryHelpers.combine([('$_threshold', const []), search, _supplierWhere(filters)]);
  }

  /// Correlated subquery: latest stock_entry (by receipt_date) touching
  /// this product, joined for its supplier + date.
  String get _lastEntryJoin => '''
      LEFT JOIN (
        SELECT sei.${DatabaseConstants.productIdColumn} AS product_id,
               se.${DatabaseConstants.supplierIdColumn} AS supplier_id,
               se.${DatabaseConstants.receiptDateColumn} AS receipt_date,
               ROW_NUMBER() OVER (
                 PARTITION BY sei.${DatabaseConstants.productIdColumn}
                 ORDER BY se.${DatabaseConstants.receiptDateColumn} DESC
               ) AS rn
        FROM ${DatabaseConstants.stockEntryItemTable} sei
        JOIN ${DatabaseConstants.stockEntryTable} se
          ON se.${DatabaseConstants.idColumn} = sei.${DatabaseConstants.stockEntryIdColumn}
      ) last_entry ON last_entry.product_id = $_p.${DatabaseConstants.idColumn} AND last_entry.rn = 1
      LEFT JOIN ${DatabaseConstants.supplierTable} sup ON sup.${DatabaseConstants.idColumn} = last_entry.supplier_id
  ''';

  Future<LowStockSummary> _fetchSummary(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    // The supplier filter references `sup`, which only exists once
    // `_lastEntryJoin` is in the FROM clause — the summary query needs
    // it too whenever that filter is active, not just `_fetchRows`.
    final result = await db.rawQuery('''
      SELECT COUNT(*) AS low_stock_count
      FROM ${DatabaseConstants.productTable} $_p
      $_lastEntryJoin
      $whereSql
    ''', args);
    return LowStockSummary(lowStockCount: (result.first['low_stock_count'] as int?) ?? 0);
  }

  Future<(List<LowStockRow>, int)> _fetchRows(
    ReportFilterState filters, {
    required int page,
    required int pageSize,
  }) async {
    final (whereSql, args) = _whereClause(filters);

    final countResult = await db.rawQuery('''
      SELECT COUNT(*) AS total
      FROM ${DatabaseConstants.productTable} $_p
      $_lastEntryJoin
      $whereSql
    ''', args);
    final totalEntries = (countResult.first['total'] as int?) ?? 0;

    final offset = (page - 1) * pageSize;
    final rows = await db.rawQuery('''
      SELECT
        $_p.${DatabaseConstants.skuColumn} AS sku,
        $_p.${DatabaseConstants.nameColumn} AS product_name,
        c.${DatabaseConstants.nameColumn} AS category_name,
        $_p.${DatabaseConstants.currentStockColumn} AS current_stock,
        $_p.${DatabaseConstants.minimumStockColumn} AS min_stock,
        sup.${DatabaseConstants.companyNameColumn} AS supplier_name,
        last_entry.receipt_date AS last_entry_date
      FROM ${DatabaseConstants.productTable} $_p
      JOIN ${DatabaseConstants.categoryTable} c ON c.${DatabaseConstants.idColumn} = $_p.${DatabaseConstants.categoryIdColumn}
      $_lastEntryJoin
      $whereSql
      ORDER BY $_p.${DatabaseConstants.currentStockColumn} ASC
      LIMIT ? OFFSET ?
    ''', [...args, pageSize, offset]);

    final mapped = rows
        .map((r) => LowStockRow(
              sku: (r['sku'] as String?) ?? '',
              productName: r['product_name'] as String,
              category: r['category_name'] as String,
              currentStock: (r['current_stock'] as num?)?.toDouble() ?? 0,
              minimumStock: (r['min_stock'] as num?)?.toDouble() ?? 0,
              supplierName: r['supplier_name'] as String?,
              lastStockEntry:
                  r['last_entry_date'] == null ? null : DateTime.parse(r['last_entry_date'] as String),
            ))
        .toList();

    return (mapped, totalEntries);
  }

  /// Phase 3 addition. Every supplier in the system (dictionary lookup,
  /// not scoped to this report's current result set — same resolution as
  /// InventoryValuationLocalDataSource.fetchCategoryOptions).
  Future<List<(String value, String label)>> fetchSupplierOptions() async {
    final result = await db.rawQuery('''
      SELECT ${DatabaseConstants.idColumn} AS id, ${DatabaseConstants.companyNameColumn} AS name
      FROM ${DatabaseConstants.supplierTable}
      ORDER BY ${DatabaseConstants.companyNameColumn} ASC
    ''');
    return result.map((r) => ('${r['id']}', r['name'] as String)).toList();
  }

  Future<LowStockData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final summary = await _fetchSummary(filters);
    final (rows, totalEntries) = await _fetchRows(filters, page: page, pageSize: pageSize);
    return LowStockData(summary: summary, rows: rows, totalEntries: totalEntries);
  }
}
