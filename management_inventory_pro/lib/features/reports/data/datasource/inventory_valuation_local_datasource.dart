// lib/features/reports/data/datasource/inventory_valuation_local_datasource.dart
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/inventory_valuation_model.dart';
import '../models/report_filter_state.dart';
import 'reports_query_helpers.dart';

/// Inventory Valuation is a point-in-time snapshot of current stock, not
/// a date-ranged report — every product's `current_stock` is already
/// "as of now". [filters.dateRange] is accepted (so this datasource has
/// the same shape as every other report and [ReportWorkspace]'s filter
/// bar stays uniform) but intentionally NOT applied to the WHERE clause;
/// only [filters.searchQuery] and, as of Phase 3 Part 2/3,
/// `filters.extra[categoryFilterKey]` filter this report.
class InventoryValuationLocalDataSource {
  final Database db;

  const InventoryValuationLocalDataSource(this.db);

  static const _p = 'p';

  /// Key this datasource reads from `filters.extra` — kept as a constant
  /// so the screen's [ReportSelectFilter] and this datasource can't
  /// drift apart on the string literal (same pattern as
  /// SalesReportLocalDataSource.paymentMethodFilterKey).
  static const categoryFilterKey = 'categoryId';

  (String, List<Object?>)? _categoryWhere(ReportFilterState filters) {
    final raw = filters.extraValue(categoryFilterKey);
    if (raw == null || raw.trim().isEmpty) return null;
    final id = int.tryParse(raw);
    if (id == null) return null;
    return ('$_p.${DatabaseConstants.categoryIdColumn} = ?', [id]);
  }

  /// Phase 3 fix: previously this method special-cased the OR'd search
  /// fragment and simply discarded any other filter that might exist —
  /// there was nothing else to combine it with yet, but it meant adding
  /// the category filter here couldn't just slot into `combine()` like
  /// every other datasource. Rebuilt so search (still OR'd across
  /// name/SKU) and category (AND'd) compose correctly together.
  (String, List<Object?>) _whereClause(ReportFilterState filters) {
    final search = ReportQueryHelpers.productSearchWhere(
      '$_p.${DatabaseConstants.nameColumn}',
      '$_p.${DatabaseConstants.skuColumn}',
      filters.searchQuery,
    );
    return ReportQueryHelpers.combine([search, _categoryWhere(filters)]);
  }

  Future<InventoryValuationSummary> _fetchSummary(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    final result = await db.rawQuery('''
      SELECT
        COALESCE(SUM($_p.${DatabaseConstants.currentStockColumn} * $_p.${DatabaseConstants.costPriceColumn}), 0) AS total_value,
        COUNT(*) AS active_skus,
        COUNT(DISTINCT $_p.${DatabaseConstants.categoryIdColumn}) AS category_count,
        SUM(CASE WHEN $_p.${DatabaseConstants.currentStockColumn} > 0
                  AND $_p.${DatabaseConstants.currentStockColumn} <= $_p.${DatabaseConstants.minimumStockColumn}
             THEN 1 ELSE 0 END) AS low_stock_count,
        SUM(CASE WHEN $_p.${DatabaseConstants.currentStockColumn} = 0 THEN 1 ELSE 0 END) AS out_of_stock_count
      FROM ${DatabaseConstants.productTable} $_p
      $whereSql
    ''', args);

    final row = result.first;
    return InventoryValuationSummary(
      totalValue: (row['total_value'] as num?)?.toDouble() ?? 0,
      activeSkus: (row['active_skus'] as int?) ?? 0,
      categoryCount: (row['category_count'] as int?) ?? 0,
      lowStockCount: (row['low_stock_count'] as int?) ?? 0,
      outOfStockCount: (row['out_of_stock_count'] as int?) ?? 0,
    );
  }

  Future<List<CategoryValueSlice>> _fetchCategoryBreakdown(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    final result = await db.rawQuery('''
      SELECT
        c.${DatabaseConstants.nameColumn} AS category_name,
        COALESCE(SUM($_p.${DatabaseConstants.currentStockColumn} * $_p.${DatabaseConstants.costPriceColumn}), 0) AS value
      FROM ${DatabaseConstants.productTable} $_p
      JOIN ${DatabaseConstants.categoryTable} c ON c.${DatabaseConstants.idColumn} = $_p.${DatabaseConstants.categoryIdColumn}
      $whereSql
      GROUP BY c.${DatabaseConstants.idColumn}
      ORDER BY value DESC
    ''', args);

    return result
        .map((r) => CategoryValueSlice(
              category: r['category_name'] as String,
              value: (r['value'] as num?)?.toDouble() ?? 0,
            ))
        .toList();
  }

  /// Phase 3 addition. Dictionary lookup, not scoped to this report's
  /// current result set — every category in the system is offered,
  /// matching the "every supplier/product in the system" resolution
  /// from the Part 1 wrap-up's open question. Returns
  /// `(value, label)` tuples rather than a presentation-layer
  /// `ReportSelectOption` so this data-layer file doesn't import UI code.
  Future<List<(String value, String label)>> fetchCategoryOptions() async {
    final result = await db.rawQuery('''
      SELECT ${DatabaseConstants.idColumn} AS id, ${DatabaseConstants.nameColumn} AS name
      FROM ${DatabaseConstants.categoryTable}
      ORDER BY ${DatabaseConstants.nameColumn} ASC
    ''');
    return result.map((r) => ('${r['id']}', r['name'] as String)).toList();
  }

  static const _sortableColumns = {
    'stock': DatabaseConstants.currentStockColumn,
    'cost': DatabaseConstants.costPriceColumn,
  };

  Future<(List<InventoryValuationRow>, int)> _fetchRows(
    ReportFilterState filters, {
    required int page,
    required int pageSize,
    String? sortColumn,
    bool sortAscending = true,
  }) async {
    final (whereSql, args) = _whereClause(filters);

    final countResult = await db.rawQuery('''
      SELECT COUNT(*) AS total FROM ${DatabaseConstants.productTable} $_p $whereSql
    ''', args);
    final totalEntries = (countResult.first['total'] as int?) ?? 0;

    final direction = sortAscending ? 'ASC' : 'DESC';
    final offset = (page - 1) * pageSize;
    final orderColumn = sortColumn == 'value' ? 'value' : (_sortableColumns[sortColumn] ?? 'value');

    final rows = await db.rawQuery('''
      SELECT * FROM (
        SELECT
          $_p.${DatabaseConstants.skuColumn} AS sku,
          $_p.${DatabaseConstants.nameColumn} AS product_name,
          c.${DatabaseConstants.nameColumn} AS category_name,
          $_p.${DatabaseConstants.currentStockColumn} AS current_stock,
          $_p.${DatabaseConstants.costPriceColumn} AS cost_price,
          $_p.${DatabaseConstants.minimumStockColumn} AS min_stock,
          ($_p.${DatabaseConstants.currentStockColumn} * $_p.${DatabaseConstants.costPriceColumn}) AS value
        FROM ${DatabaseConstants.productTable} $_p
        JOIN ${DatabaseConstants.categoryTable} c ON c.${DatabaseConstants.idColumn} = $_p.${DatabaseConstants.categoryIdColumn}
        $whereSql
      )
      ORDER BY $orderColumn $direction
      LIMIT ? OFFSET ?
    ''', [...args, pageSize, offset]);

    final mapped = rows.map((r) {
      final currentStock = (r['current_stock'] as num?)?.toDouble() ?? 0;
      final minStock = (r['min_stock'] as num?)?.toDouble() ?? 0;
      final status = currentStock == 0
          ? StockStatus.out
          : (currentStock <= minStock ? StockStatus.low : StockStatus.healthy);
      return InventoryValuationRow(
        sku: (r['sku'] as String?) ?? '',
        productName: r['product_name'] as String,
        category: r['category_name'] as String,
        currentStock: currentStock,
        costPrice: (r['cost_price'] as num?)?.toDouble() ?? 0,
        totalValue: (r['value'] as num?)?.toDouble() ?? 0,
        status: status,
      );
    }).toList();

    return (mapped, totalEntries);
  }

  Future<InventoryValuationData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
    String? sortColumn,
    bool sortAscending = true,
  }) async {
    final summary = await _fetchSummary(filters);
    final breakdown = await _fetchCategoryBreakdown(filters);
    final (rows, totalEntries) = await _fetchRows(
      filters,
      page: page,
      pageSize: pageSize,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
    );
    return InventoryValuationData(
      summary: summary,
      categoryBreakdown: breakdown,
      rows: rows,
      totalEntries: totalEntries,
    );
  }
}
