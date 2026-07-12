/// SQL fragment builders shared by every report datasource. Kept as pure
/// static helpers (no db handle, no table knowledge) so each concrete
/// datasource — e.g. a future SalesReportLocalDataSource — composes them
/// into its own query instead of this class owning any table-specific
/// logic.
///

class ReportQueryHelpers {
  ReportQueryHelpers._();

  static (String clause, List<Object?> args) dateRangeWhere(
      String column,
      String startIso,
      String endIso,
      ) {
    return ('$column BETWEEN ? AND ?', [startIso, endIso]);
  }

  static (String clause, List<Object?> args)? likeWhere(String column, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return null;
    return ('LOWER($column) LIKE LOWER(?)', ['%$trimmed%']);
  }

  static (String clause, List<Object?> args)? productSearchWhere(
      String nameColumn,
      String skuColumn,
      String query,
      ) {
    final name = likeWhere(nameColumn, query);
    final sku = likeWhere(skuColumn, query);
    if (name == null || sku == null) return null;
    return ('(${name.$1} OR ${sku.$1})', [...name.$2, ...sku.$2]);
  }


  /// `column = ?` clause + bound arg. Returns null when [value] is null
  /// or blank, mirroring [likeWhere]'s "callers can skip appending it
  /// entirely" contract. Generic exact-match builder — introduced for
  /// the sale-status filter, which three separate datasources
  /// (SalesReport, ProfitReport, StockMovement) all need in the same
  /// shape, instead of each hand-rolling its own `_statusWhere`.
  static (String clause, List<Object?> args)? equalsWhere(String column, String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return ('$column = ?', [value]);
  }

  static (String whereSql, List<Object?> args) combine(
      List<(String clause, List<Object?> args)?> fragments,
      ) {
    final present = fragments.whereType<(String, List<Object?>)>().toList();
    if (present.isEmpty) return ('', const []);
    final sql = present.map((f) => f.$1).join(' AND ');
    final args = present.expand((f) => f.$2).toList();
    return ('WHERE $sql', args);
  }

  /// `EXISTS (subquery)` wrapper for the "does this header row have at
  /// least one matching child row" pattern — used by Sales/Profit (via
  /// sale_items), Supplier Purchases (via stock_entry_items), and Stock
  /// Adjustment History (via stock_adjustment_items) to filter a header
  /// table by product without duplicating rows the way a JOIN would.
  /// [subqueryBody] is the full `SELECT 1 FROM ... WHERE ...` text;
  /// returns null when [value] is blank, same contract as [equalsWhere].
  static (String clause, List<Object?> args)? existsWhere(
      String subqueryBody,
      String? value,
      ) {
    if (value == null || value.trim().isEmpty) return null;
    return ('EXISTS ($subqueryBody)', [value]);
  }
}

