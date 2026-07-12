import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/report_filter_state.dart';
import '../models/sales_report_model.dart';
import '../services/profit_calculator.dart';
import 'reports_query_helpers.dart';

/// Reads the Sales Report straight off [DatabaseConstants.saleTable]. All
/// three queries (summary / trend / rows) share the same WHERE clause,
/// built once via [ReportQueryHelpers] and reused, so the filtered set is
/// always identical across the workspace.
///
/// Cost/profit figures use each product's *current* cost_price — sales
/// don't snapshot cost at time of sale, so historical accuracy is
/// approximate for products whose cost has since changed. Flagged here
/// for a future revisit if exact historical margin becomes a
/// requirement (would need a cost_price_at_sale column on sale_items).
///
/// Phase 3 Part 4 (Performance) change: added [fetchRows] and
/// [fetchAllRows], both thin public wrappers around the existing
/// private [_fetchRows]. This is what lets [SalesReportCubit] stop
/// re-running the summary + trend aggregates on every page click and
/// sort change (flagged as a known trade-off since Section 2) — those
/// two queries don't depend on page/sort at all, only on filters, so a
/// page click only needs [fetchRows] now. [fetchAllRows] reuses the same
/// query with a very large `pageSize` instead of writing a second,
/// subtly-different unpaginated query — SQLite's LIMIT has no practical
/// ceiling, so this is correct and avoids drift between "paged" and
/// "all rows" behaving differently for edge cases like sort ties.
class SalesReportLocalDataSource {
  final Database db;

  SalesReportLocalDataSource(this.db);

  static const _saleAlias = 's';

  /// Key this datasource reads from `filters.extra` — kept as a constant
  /// so the screen's [ReportSelectFilter] and this datasource can't drift
  /// apart on the string literal.
  static const paymentMethodFilterKey = 'paymentMethod';

  /// Large enough that no realistic sales table will ever hit it, small
  /// enough to stay a plain `int` rather than needing a "no limit" sentinel
  /// value threaded through every layer.
  static const _unpaginatedPageSize = 1000000;

  (String, List<Object?>)? _productWhere(ReportFilterState filters) => ReportQueryHelpers.existsWhere(
    '''
      SELECT 1 FROM ${DatabaseConstants.saleItemTable} si
      WHERE si.${DatabaseConstants.saleIdColumn} = $_saleAlias.${DatabaseConstants.idColumn}
        AND si.${DatabaseConstants.productIdColumn} = ?
      ''',
    filters.extraValue(ReportFilterState.productFilterKey),
  );

  (String, List<Object?>)? _paymentMethodWhere(ReportFilterState filters) {
    final method = filters.extraValue(paymentMethodFilterKey);
    if (method == null || method.trim().isEmpty) return null;
    return ('$_saleAlias.${DatabaseConstants.paymentMethodColumn} = ?', [method]);
  }

  (String, List<Object?>)? _statusWhere(ReportFilterState filters) => ReportQueryHelpers.equalsWhere(
    '$_saleAlias.${DatabaseConstants.statusColumn}',
    filters.extraValue(ReportFilterState.saleStatusFilterKey),
  );

  (String, List<Object?>) _whereClause(ReportFilterState filters) {
    final dateRange = ReportQueryHelpers.dateRangeWhere(
      '$_saleAlias.${DatabaseConstants.createdAtColumn}',
      filters.dateRange.startIso,
      filters.dateRange.endIso,
    );

    final search = ReportQueryHelpers.likeWhere('$_saleAlias.${DatabaseConstants.idColumn}', filters.searchQuery);
    final paymentMethod = _paymentMethodWhere(filters);
    final status = _statusWhere(filters);
    final product = _productWhere(filters);
    return ReportQueryHelpers.combine([dateRange, search, paymentMethod, status, product]);
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

  /// LEFT JOIN subquery that rolls sale_items + products up to one
  /// cost-per-sale row. Shared by the summary and trend queries.
  /// LEFT JOIN subquery that rolls sale_items + products up to one
  /// cost-per-sale row. Uses each line's own cost_price_at_sale when
  /// present (post-migration sales — exact historical cost) and falls
  /// back to the product's current cost_price only for legacy rows
  /// written before that column existed (COALESCE keeps old behavior
  /// for data we have no way to make exact). Shared by the summary and
  /// trend queries.
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
  Future<SalesReportSummary> _fetchSummary(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    final result = await db.rawQuery('''
    SELECT
      COUNT(*) AS orders,
      COALESCE(SUM($_saleAlias.${DatabaseConstants.subtotalColumn}), 0) AS revenue,
      COALESCE(SUM($_saleAlias.${DatabaseConstants.discountAmountColumn}), 0) AS discount,
      COALESCE(SUM($_saleAlias.${DatabaseConstants.taxAmountColumn}), 0) AS tax,
      COALESCE(SUM(cost_agg.cost), 0) AS cost
    FROM ${DatabaseConstants.saleTable} $_saleAlias
    $_costAgg
    $whereSql
  ''', args);

    final row = result.first;
    final orders = (row['orders'] as int?) ?? 0;
    final revenue = (row['revenue'] as num?)?.toDouble() ?? 0;
    final discount = (row['discount'] as num?)?.toDouble() ?? 0;
    final cost = (row['cost'] as num?)?.toDouble() ?? 0;
    final profit = ProfitCalculator.profit(subtotal: revenue, discount: discount, cost: cost);

    return SalesReportSummary(
      revenue: revenue,
      profit: profit,
      orders: orders,
      averageOrder: orders == 0 ? 0 : revenue / orders,
      tax: (row['tax'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Day-level bucketing. Fine for the ranges the filter bar offers
  /// (today .. last 30 days); a multi-month custom range would benefit
  /// from week/month bucketing — noted as a future refinement, not a
  /// blocker for this pass.
  Future<List<SalesTrendPoint>> _fetchTrend(ReportFilterState filters) async {
    final (whereSql, args) = _whereClause(filters);
    final result = await db.rawQuery('''
    SELECT
      strftime('%Y-%m-%d', $_saleAlias.${DatabaseConstants.createdAtColumn}) AS day,
      COALESCE(SUM($_saleAlias.${DatabaseConstants.subtotalColumn}), 0) AS revenue,
      COALESCE(SUM($_saleAlias.${DatabaseConstants.discountAmountColumn}), 0) AS discount,
      COALESCE(SUM(cost_agg.cost), 0) AS cost
    FROM ${DatabaseConstants.saleTable} $_saleAlias
    $_costAgg
    $whereSql
    GROUP BY day
    ORDER BY day ASC
  ''', args);

    return result.map((r) {
      final revenue = (r['revenue'] as num?)?.toDouble() ?? 0;
      final discount = (r['discount'] as num?)?.toDouble() ?? 0;
      final cost = (r['cost'] as num?)?.toDouble() ?? 0;
      return SalesTrendPoint(
        label: r['day'] as String,
        revenue: revenue,
        profit: ProfitCalculator.profit(subtotal: revenue, discount: discount, cost: cost),
      );
    }).toList();
  }

  /// UI sort keys -> actual column names. Only Date / Cashier / Grand
  /// Total are wired sortable today; adding Subtotal/Discount/Tax is a
  /// one-line addition here plus in the screen's column list.
  static const _sortableColumns = {
    'date': DatabaseConstants.createdAtColumn,
    'cashier': DatabaseConstants.cashierNameColumn,
    'grandTotal': DatabaseConstants.totalAmountColumn,
  };

  Future<(List<SalesReportRow>, int)> _fetchRows(
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

    final orderColumn = _sortableColumns[sortColumn] ?? DatabaseConstants.createdAtColumn;
    final direction = sortAscending ? 'ASC' : 'DESC';
    final offset = (page - 1) * pageSize;

    final rows = await db.rawQuery('''
      SELECT
        $_saleAlias.${DatabaseConstants.idColumn} AS invoice_id,
        $_saleAlias.${DatabaseConstants.createdAtColumn} AS created_at,
        $_saleAlias.${DatabaseConstants.cashierNameColumn} AS cashier,
        $_saleAlias.${DatabaseConstants.paymentMethodColumn} AS payment_method,
        $_saleAlias.${DatabaseConstants.subtotalColumn} AS subtotal,
        $_saleAlias.${DatabaseConstants.discountAmountColumn} AS discount,
        $_saleAlias.${DatabaseConstants.taxAmountColumn} AS tax,
        $_saleAlias.${DatabaseConstants.totalAmountColumn} AS grand_total,
        $_saleAlias.${DatabaseConstants.statusColumn} AS status
      FROM ${DatabaseConstants.saleTable} $_saleAlias
      $whereSql
      ORDER BY $orderColumn $direction
      LIMIT ? OFFSET ?
    ''', [...args, pageSize, offset]);

    final mapped = rows
        .map((r) => SalesReportRow(
              invoiceId: r['invoice_id'] as String,
              date: DateTime.parse(r['created_at'] as String),
              cashier: (r['cashier'] as String?) ?? '',
              paymentMethod: (r['payment_method'] as String?) ?? '',
              subtotal: (r['subtotal'] as num?)?.toDouble() ?? 0,
              discount: (r['discount'] as num?)?.toDouble() ?? 0,
              tax: (r['tax'] as num?)?.toDouble() ?? 0,
              grandTotal: (r['grand_total'] as num?)?.toDouble() ?? 0,
              status: (r['status'] as String?) ?? '',
            ))
        .toList();

    return (mapped, totalEntries);
  }

  /// Public row-only fetch — [SalesReportCubit.changePage] and
  /// [SalesReportCubit.changeSort] call this directly instead of [fetch],
  /// since summary/trend are unaffected by page or sort and shouldn't be
  /// re-aggregated on every click.
  Future<(List<SalesReportRow>, int)> fetchRows(
    ReportFilterState filters, {
    required int page,
    required int pageSize,
    String? sortColumn,
    bool sortAscending = true,
  }) {
    return _fetchRows(filters, page: page, pageSize: pageSize, sortColumn: sortColumn, sortAscending: sortAscending);
  }

  /// Every row matching [filters], ignoring pagination — backs the
  /// "Export all filtered rows" action. See the class doc comment for
  /// why this reuses [_fetchRows] rather than a second query.
  Future<List<SalesReportRow>> fetchAllRows(
    ReportFilterState filters, {
    String? sortColumn,
    bool sortAscending = true,
  }) async {
    final (rows, _) = await _fetchRows(
      filters,
      page: 1,
      pageSize: _unpaginatedPageSize,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
    );
    return rows;
  }

  /// Recomputes summary + trend + the requested page of rows in one
  /// call. Used for the first load and for any filter change (date
  /// range / search / payment method) — those genuinely do change the
  /// summary and trend, unlike page/sort.
  Future<SalesReportData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
    String? sortColumn,
    bool sortAscending = true,
  }) async {
    final summary = await _fetchSummary(filters);
    final trend = await _fetchTrend(filters);
    final (rows, totalEntries) = await _fetchRows(
      filters,
      page: page,
      pageSize: pageSize,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
    );

    return SalesReportData(summary: summary, trend: trend, rows: rows, totalEntries: totalEntries);
  }
}
