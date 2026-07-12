import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/profit_report_model.dart';
import '../models/report_filter_state.dart';
import '../services/profit_calculator.dart';
import 'reports_query_helpers.dart';

/// Same cost-join approach and the same current-cost-price caveat as
/// [SalesReportLocalDataSource] — see that file's doc comment.
class ProfitReportLocalDataSource {
  final Database db;

  ProfitReportLocalDataSource(this.db);

  static const _saleAlias = 's';

  (String, List<Object?>) _whereClause(ReportFilterState filters) {
    final dateRange = ReportQueryHelpers.dateRangeWhere(
      '$_saleAlias.${DatabaseConstants.createdAtColumn}',
      filters.dateRange.startIso,
      filters.dateRange.endIso,
    );
    final search = ReportQueryHelpers.likeWhere('$_saleAlias.${DatabaseConstants.idColumn}', filters.searchQuery);
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

  (String, List<Object?>)? _productWhere(ReportFilterState filters) => ReportQueryHelpers.existsWhere(
    '''
      SELECT 1 FROM ${DatabaseConstants.saleItemTable} si
      WHERE si.${DatabaseConstants.saleIdColumn} = $_saleAlias.${DatabaseConstants.idColumn}
        AND si.${DatabaseConstants.productIdColumn} = ?
      ''',
    filters.extraValue(ReportFilterState.productFilterKey),
  );

  String get _costAgg => '''
    LEFT JOIN (
      SELECT si.${DatabaseConstants.saleIdColumn} AS sale_id,
             SUM(si.${DatabaseConstants.quantityColumn} *
                 COALESCE(si.${DatabaseConstants.costPriceAtSaleColumn}, p.${DatabaseConstants.costPriceColumn})
             ) AS cost
      FROM ${DatabaseConstants.saleItemTable} si
      JOIN ${DatabaseConstants.productTable} p
        ON p.${DatabaseConstants.idColumn} = si.${DatabaseConstants.productIdColumn}
      GROUP BY si.${DatabaseConstants.saleIdColumn}
    ) cost_agg ON cost_agg.sale_id = $_saleAlias.${DatabaseConstants.idColumn}
''';
  Future<ProfitReportSummary> _fetchSummary(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    final result = await db.rawQuery('''
    SELECT
      COALESCE(SUM($_saleAlias.${DatabaseConstants.subtotalColumn}), 0) AS revenue,
      COALESCE(SUM($_saleAlias.${DatabaseConstants.discountAmountColumn}), 0) AS discount,
      COALESCE(SUM(cost_agg.cost), 0) AS cost
    FROM ${DatabaseConstants.saleTable} $_saleAlias
    $_costAgg
    $whereSql
  ''', args);

    final row = result.first;
    final revenue = (row['revenue'] as num?)?.toDouble() ?? 0;
    final discount = (row['discount'] as num?)?.toDouble() ?? 0;
    final cost = (row['cost'] as num?)?.toDouble() ?? 0;
    final profit = ProfitCalculator.profit(subtotal: revenue, discount: discount, cost: cost);

    return ProfitReportSummary(
      revenue: revenue,
      cost: cost,
      profit: profit,
      marginPercent: ProfitCalculator.marginPercent(revenue: revenue, profit: profit),
    );
  }


  static const _sortableColumns = {'revenue': 'revenue', 'cost': 'cost', 'profit': 'profit'};

  (String, List<Object?>)? _statusWhere(ReportFilterState filters) => ReportQueryHelpers.equalsWhere(
    '$_saleAlias.${DatabaseConstants.statusColumn}',
    filters.extraValue(ReportFilterState.saleStatusFilterKey),
  );

  Future<(List<ProfitReportRow>, int)> _fetchRows(
    ReportFilterState filters, {
    required int page,
    required int pageSize,
    String? sortColumn,
    bool sortAscending = true,
  }) async {
    final (whereSql, args) = _whereClause(filters);

    final countResult = await db.rawQuery('''
      SELECT COUNT(*) AS total
      FROM ${DatabaseConstants.saleTable} $_saleAlias
      $whereSql
    ''', args);
    final totalEntries = (countResult.first['total'] as int?) ?? 0;

    final direction = sortAscending ? 'ASC' : 'DESC';
    final orderColumn = _sortableColumns[sortColumn] ?? 'revenue';
    final offset = (page - 1) * pageSize;
    final rows = await db.rawQuery('''
  SELECT * FROM (
    SELECT
      $_saleAlias.${DatabaseConstants.idColumn} AS invoice_id,
      $_saleAlias.${DatabaseConstants.subtotalColumn} AS revenue,
      $_saleAlias.${DatabaseConstants.discountAmountColumn} AS discount,
      COALESCE(cost_agg.cost, 0) AS cost,
      ($_saleAlias.${DatabaseConstants.subtotalColumn}
        - $_saleAlias.${DatabaseConstants.discountAmountColumn}
        - COALESCE(cost_agg.cost, 0)) AS profit
    FROM ${DatabaseConstants.saleTable} $_saleAlias
    $_costAgg
    $whereSql
  )
  ORDER BY $orderColumn $direction
  LIMIT ? OFFSET ?
''', [...args, pageSize, offset]);

    final mapped = rows.map((r) {
      final revenue = (r['revenue'] as num?)?.toDouble() ?? 0;
      final discount = (r['discount'] as num?)?.toDouble() ?? 0;
      final cost = (r['cost'] as num?)?.toDouble() ?? 0;
      final profit = ProfitCalculator.profit(subtotal: revenue, discount: discount, cost: cost);
      return ProfitReportRow(
        invoiceId: r['invoice_id'] as String,
        revenue: revenue,
        cost: cost,
        profit: profit,
        marginPercent: ProfitCalculator.marginPercent(revenue: revenue, profit: profit),
      );
    }).toList();

    return (mapped, totalEntries);
  }

  Future<ProfitReportData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
    String? sortColumn,
    bool sortAscending = true,
  }) async {
    final summary = await _fetchSummary(filters);
    final (rows, totalEntries) = await _fetchRows(
      filters,
      page: page,
      pageSize: pageSize,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
    );
    return ProfitReportData(summary: summary, rows: rows, totalEntries: totalEntries);
  }
}
