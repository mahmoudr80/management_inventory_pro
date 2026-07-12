// lib/features/reports/data/datasource/out_of_stock_local_datasource.dart
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/out_of_stock_model.dart';
import '../models/report_filter_state.dart';
import 'reports_query_helpers.dart';

/// Point-in-time report — same reasoning as [LowStockLocalDataSource].
/// "Last Sale" and "Days Out Of Stock" are both derived (no supplier FK
/// on products, no zero-stock-timestamp event in the schema — see
/// [OutOfStockRow.daysOutOfStock] doc comment for the approximation).
/// Phase 3 Part 2/3 adds `filters.extra[supplierFilterKey]`, matched the
/// same way as [LowStockLocalDataSource] — against the `sup` alias
/// resolved via each product's most recent stock entry.
class OutOfStockLocalDataSource {
  final Database db;

  OutOfStockLocalDataSource(this.db);

  static const _p = 'p';
  static const _isOut = '$_p.${DatabaseConstants.currentStockColumn} = 0';

  static const supplierFilterKey = 'supplierId';

  (String, List<Object?>)? _supplierWhere(ReportFilterState filters) {
    final supplierId = filters.extraValue(supplierFilterKey);
    if (supplierId == null || supplierId.trim().isEmpty) return null;
    return ('sup.${DatabaseConstants.idColumn} = ?', [supplierId]);
  }

  (String, List<Object?>) _whereClause(ReportFilterState filters) {
    final search = ReportQueryHelpers.productSearchWhere(
      '$_p.${DatabaseConstants.nameColumn}',
      '$_p.${DatabaseConstants.skuColumn}',
      filters.searchQuery,
    );
    return ReportQueryHelpers.combine([(_isOut, const []), search, _supplierWhere(filters)]);
  }

  String get _lastEntryJoin => '''
      LEFT JOIN (
        SELECT sei.${DatabaseConstants.productIdColumn} AS product_id,
               se.${DatabaseConstants.supplierIdColumn} AS supplier_id,
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

  String get _lastSaleJoin => '''
      LEFT JOIN (
        SELECT si.${DatabaseConstants.productIdColumn} AS product_id,
               MAX(s.${DatabaseConstants.createdAtColumn}) AS last_sale
        FROM ${DatabaseConstants.saleItemTable} si
        JOIN ${DatabaseConstants.saleTable} s ON s.${DatabaseConstants.idColumn} = si.${DatabaseConstants.saleIdColumn}
        GROUP BY si.${DatabaseConstants.productIdColumn}
      ) last_sale ON last_sale.product_id = $_p.${DatabaseConstants.idColumn}
  ''';

  Future<OutOfStockSummary> _fetchSummary(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    // `_lastEntryJoin` needed here too whenever the supplier filter
    // (which references `sup`) is active — same fix as
    // LowStockLocalDataSource._fetchSummary.
    final result = await db.rawQuery('''
      SELECT COUNT(*) AS out_of_stock_count
      FROM ${DatabaseConstants.productTable} $_p
      $_lastEntryJoin
      $whereSql
    ''', args);
    return OutOfStockSummary(outOfStockCount: (result.first['out_of_stock_count'] as int?) ?? 0);
  }

  Future<(List<OutOfStockRow>, int)> _fetchRows(
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
        sup.${DatabaseConstants.companyNameColumn} AS supplier_name,
        last_sale.last_sale AS last_sale
      FROM ${DatabaseConstants.productTable} $_p
      JOIN ${DatabaseConstants.categoryTable} c ON c.${DatabaseConstants.idColumn} = $_p.${DatabaseConstants.categoryIdColumn}
      $_lastEntryJoin
      $_lastSaleJoin
      $whereSql
      ORDER BY last_sale.last_sale ASC NULLS FIRST
      LIMIT ? OFFSET ?
    ''', [...args, pageSize, offset]);

    final now = DateTime.now();
    final mapped = rows.map((r) {
      final lastSaleStr = r['last_sale'] as String?;
      final lastSale = lastSaleStr != null ? DateTime.parse(lastSaleStr) : null;
      // No fallback to products.updated_at — that column reflects any
      // edit to the product, not when it went out of stock, and would
      // silently understate how long a never-sold product has been out.
      return OutOfStockRow(
        sku: (r['sku'] as String?) ?? '',
        productName: r['product_name'] as String,
        category: r['category_name'] as String,
        supplierName: r['supplier_name'] as String?,
        lastSale: lastSale,
        daysOutOfStock: lastSale == null ? null : now.difference(lastSale).inDays,
      );
    }).toList();

    return (mapped, totalEntries);
  }

  /// Phase 3 addition — same dictionary lookup as
  /// LowStockLocalDataSource.fetchSupplierOptions.
  Future<List<(String value, String label)>> fetchSupplierOptions() async {
    final result = await db.rawQuery('''
      SELECT ${DatabaseConstants.idColumn} AS id, ${DatabaseConstants.companyNameColumn} AS name
      FROM ${DatabaseConstants.supplierTable}
      ORDER BY ${DatabaseConstants.companyNameColumn} ASC
    ''');
    return result.map((r) => ('${r['id']}', r['name'] as String)).toList();
  }

  Future<OutOfStockData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final summary = await _fetchSummary(filters);
    final (rows, totalEntries) = await _fetchRows(filters, page: page, pageSize: pageSize);
    return OutOfStockData(summary: summary, rows: rows, totalEntries: totalEntries);
  }
}
