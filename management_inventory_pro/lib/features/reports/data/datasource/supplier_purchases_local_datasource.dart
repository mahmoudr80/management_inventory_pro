// lib/features/reports/data/datasource/supplier_purchases_local_datasource.dart
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/report_filter_state.dart';
import '../models/supplier_purchases_model.dart';
import 'reports_query_helpers.dart';

/// Aggregates [DatabaseConstants.stockEntryTable] by supplier for the
/// selected date range. Phase 3 Part 2/3 adds an exact-match Supplier
/// filter (`filters.extra[supplierFilterKey]`) alongside the existing
/// free-text supplier-name search — the filter narrows to one supplier,
/// the search box narrows by partial name match; both can be active
/// together.
class SupplierPurchasesLocalDataSource {
  final Database db;

  SupplierPurchasesLocalDataSource(this.db);

  static const _se = 'se';

  static const supplierFilterKey = 'supplierId';

  (String, List<Object?>)? _supplierWhere(ReportFilterState filters) {
    final supplierId = filters.extraValue(supplierFilterKey);
    if (supplierId == null || supplierId.trim().isEmpty) return null;
    return ('sup.${DatabaseConstants.idColumn} = ?', [supplierId]);
  }

  (String, List<Object?>)? _productWhere(ReportFilterState filters) => ReportQueryHelpers.existsWhere(
    '''
      SELECT 1 FROM ${DatabaseConstants.stockEntryItemTable} sei
      WHERE sei.${DatabaseConstants.stockEntryIdColumn} = $_se.${DatabaseConstants.idColumn}
        AND sei.${DatabaseConstants.productIdColumn} = ?
      ''',
    filters.extraValue(ReportFilterState.productFilterKey),
  );

  (String, List<Object?>) _whereClause(ReportFilterState filters) {
    final dateRange = ReportQueryHelpers.dateRangeWhere(
      '$_se.${DatabaseConstants.receiptDateColumn}',
      filters.dateRange.startIso,
      filters.dateRange.endIso,
    );
    final search = ReportQueryHelpers.likeWhere('sup.${DatabaseConstants.companyNameColumn}', filters.searchQuery);
    return ReportQueryHelpers.combine([dateRange, search, _supplierWhere(filters), _productWhere(filters)]);
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

  Future<SupplierPurchasesSummary> _fetchSummary(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    final result = await db.rawQuery('''
      SELECT
        COALESCE(SUM($_se.${DatabaseConstants.totalCostColumn}), 0) AS purchase_cost,
        COUNT(*) AS orders,
        COALESCE(SUM($_se.${DatabaseConstants.totalItemColumn}), 0) AS products
      FROM ${DatabaseConstants.stockEntryTable} $_se
      JOIN ${DatabaseConstants.supplierTable} sup ON sup.${DatabaseConstants.idColumn} = $_se.${DatabaseConstants.supplierIdColumn}
      $whereSql
    ''', args);

    final row = result.first;
    return SupplierPurchasesSummary(
      purchaseCost: (row['purchase_cost'] as num?)?.toDouble() ?? 0,
      orders: (row['orders'] as int?) ?? 0,
      products: (row['products'] as num?)?.toInt() ?? 0,
    );
  }

  Future<(List<SupplierPurchasesRow>, int)> _fetchRows(
    ReportFilterState filters, {
    required int page,
    required int pageSize,
  }) async {
    final (whereSql, args) = _whereClause(filters);

    final countResult = await db.rawQuery('''
      SELECT COUNT(DISTINCT sup.${DatabaseConstants.idColumn}) AS total
      FROM ${DatabaseConstants.stockEntryTable} $_se
      JOIN ${DatabaseConstants.supplierTable} sup ON sup.${DatabaseConstants.idColumn} = $_se.${DatabaseConstants.supplierIdColumn}
      $whereSql
    ''', args);
    final totalEntries = (countResult.first['total'] as int?) ?? 0;

    final offset = (page - 1) * pageSize;
    final rows = await db.rawQuery('''
      SELECT
        sup.${DatabaseConstants.idColumn} AS supplier_id,
        sup.${DatabaseConstants.companyNameColumn} AS supplier_name,
        COUNT($_se.${DatabaseConstants.idColumn}) AS orders,
        COALESCE(SUM($_se.${DatabaseConstants.totalItemColumn}), 0) AS items,
        COALESCE(SUM($_se.${DatabaseConstants.totalCostColumn}), 0) AS total_cost,
        MAX($_se.${DatabaseConstants.receiptDateColumn}) AS last_purchase
      FROM ${DatabaseConstants.stockEntryTable} $_se
      JOIN ${DatabaseConstants.supplierTable} sup ON sup.${DatabaseConstants.idColumn} = $_se.${DatabaseConstants.supplierIdColumn}
      $whereSql
      GROUP BY sup.${DatabaseConstants.idColumn}
      ORDER BY total_cost DESC
      LIMIT ? OFFSET ?
    ''', [...args, pageSize, offset]);

    final mapped = rows
        .map((r) => SupplierPurchasesRow(
              supplierId: r['supplier_id'] as String,
              supplierName: r['supplier_name'] as String,
              orders: (r['orders'] as int?) ?? 0,
              items: (r['items'] as num?)?.toInt() ?? 0,
              totalCost: (r['total_cost'] as num?)?.toDouble() ?? 0,
              lastPurchase:
                  r['last_purchase'] == null ? null : DateTime.parse(r['last_purchase'] as String),
            ))
        .toList();

    return (mapped, totalEntries);
  }

  /// Phase 3 addition — same dictionary lookup as the other reports'
  /// fetchSupplierOptions.
  Future<List<(String value, String label)>> fetchSupplierOptions() async {
    final result = await db.rawQuery('''
      SELECT ${DatabaseConstants.idColumn} AS id, ${DatabaseConstants.companyNameColumn} AS name
      FROM ${DatabaseConstants.supplierTable}
      ORDER BY ${DatabaseConstants.companyNameColumn} ASC
    ''');
    return result.map((r) => ('${r['id']}', r['name'] as String)).toList();
  }

  Future<SupplierPurchasesData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final summary = await _fetchSummary(filters);
    final (rows, totalEntries) = await _fetchRows(filters, page: page, pageSize: pageSize);
    return SupplierPurchasesData(summary: summary, rows: rows, totalEntries: totalEntries);
  }
}
