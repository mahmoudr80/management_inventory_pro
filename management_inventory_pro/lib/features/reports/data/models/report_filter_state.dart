import 'package:flutter/foundation.dart';
import 'report_date_range.dart';

@immutable
class ReportFilterState {
  final ReportDateRange dateRange;
  final String searchQuery;
  final Map<String, String?> extra;

  const ReportFilterState({
    required this.dateRange,
    this.searchQuery = '',
    this.extra = const {},
  });

  /// Key every sales-derived report reads from `extra` to scope itself
  /// to a sale lifecycle state. Centralized here (not duplicated per
  /// datasource like paymentMethodFilterKey/categoryFilterKey) because
  /// three datasources — SalesReport, ProfitReport, StockMovement —
  /// all need to agree on the exact same string, and drift here would
  /// silently un-filter one report while the others stayed fixed.
  static const saleStatusFilterKey = 'saleStatus';

  /// Key every product-scoped report reads from `extra` to narrow to one
  /// SKU — reused by Sales, Profit, Stock Movement, Supplier Purchases,
  /// and Stock Adjustment History, so it's centralized the same way
  /// saleStatusFilterKey is: multiple datasources must agree on the exact
  /// string, and drift here would silently un-filter one report while the
  /// others stayed correctly filtered.
  static const productFilterKey = 'productId';

  /// Business default: only a Completed sale is real revenue, real
  /// profit, or a real stock-out. Pending/void/refunded sales must not
  /// inflate Revenue, Profit, Tax, Average Order Value, or Stock
  /// Movement's outbound total. Reports opt into this by reading
  /// [saleStatusFilterKey] via [extraValue] — a report that isn't
  /// sale-derived (Low Stock, Inventory Valuation, ...) never reads
  /// this key, so this default has no effect there.
  static const defaultSaleStatus = 'completed';

  factory ReportFilterState.initial() => ReportFilterState(
    dateRange: ReportDateRange.last7Days(),
    extra: const {saleStatusFilterKey: defaultSaleStatus},
  );

  String? extraValue(String key) => extra[key];

  ReportFilterState copyWith({
    ReportDateRange? dateRange,
    String? searchQuery,
    Map<String, String?>? extra,
  }) {
    return ReportFilterState(
      dateRange: dateRange ?? this.dateRange,
      searchQuery: searchQuery ?? this.searchQuery,
      extra: extra ?? this.extra,
    );
  }

  ReportFilterState withExtra(String key, String? value) {
    final next = Map<String, String?>.from(extra);
    if (value == null) {
      next.remove(key);
    } else {
      next[key] = value;
    }
    return copyWith(extra: next);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ReportFilterState &&
              other.dateRange == dateRange &&
              other.searchQuery == searchQuery &&
              mapEquals(other.extra, extra));

  @override
  int get hashCode => Object.hash(dateRange, searchQuery, Object.hashAllUnordered(
    extra.entries.map((e) => Object.hash(e.key, e.value)),
  ));
}