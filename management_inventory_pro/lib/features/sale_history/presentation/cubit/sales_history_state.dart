part of 'sales_history_cubit.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

enum DateRangeFilter { today, yesterday, last7Days, thisMonth, custom }

enum SortColumn { saleId, dateTime, itemsCount, quantity, totalAmount }

enum SortDirection { ascending, descending }

// ---------------------------------------------------------------------------
// ActiveFilters
// ---------------------------------------------------------------------------

class ActiveFilters {
  const ActiveFilters({
    this.searchQuery = '',
    this.dateRangeFilter = DateRangeFilter.thisMonth,
    this.customStartDate,
    this.customEndDate,
    // `mixed` acts as "show all" — matches the PaymentMethod default in SaleModel
    this.paymentMethod = PaymentMethod.mixed,
  });

  final String searchQuery;
  final DateRangeFilter dateRangeFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final PaymentMethod paymentMethod;

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      dateRangeFilter != DateRangeFilter.thisMonth ||
      paymentMethod != PaymentMethod.mixed;

  ActiveFilters copyWith({
    String? searchQuery,
    DateRangeFilter? dateRangeFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
    PaymentMethod? paymentMethod,
    bool clearCustomDates = false,
  }) {
    return ActiveFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      dateRangeFilter: dateRangeFilter ?? this.dateRangeFilter,
      customStartDate:
          clearCustomDates ? null : (customStartDate ?? this.customStartDate),
      customEndDate:
          clearCustomDates ? null : (customEndDate ?? this.customEndDate),
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class SalesHistoryState {
  const SalesHistoryState();
}

final class SalesHistoryInitial extends SalesHistoryState {
  const SalesHistoryInitial();
}

final class SalesHistoryLoading extends SalesHistoryState {
  const SalesHistoryLoading();
}

final class SalesHistoryLoaded extends SalesHistoryState {
  const SalesHistoryLoaded({
    required this.allSales,
    required this.filteredSales,
    required this.summary,
    required this.filters,
    this.selectedSale,
    this.sortColumn = SortColumn.dateTime,
    this.sortDirection = SortDirection.descending,
    this.currentPage = 1,
    this.pageSize = 10,
  });

  final List<SaleModel> allSales;
  final List<SaleModel> filteredSales;
  final SalesSummaryModel summary;
  final ActiveFilters filters;
  final SaleModel? selectedSale;
  final SortColumn sortColumn;
  final SortDirection sortDirection;
  final int currentPage;
  final int pageSize;

  int get totalPages => (filteredSales.length / pageSize).ceil().clamp(1, 9999);

  List<SaleModel> get pagedSales {
    final start = (currentPage - 1) * pageSize;
    final end = (start + pageSize).clamp(0, filteredSales.length);
    if (start >= filteredSales.length) return [];
    return filteredSales.sublist(start, end);
  }

  SalesHistoryLoaded copyWith({
    List<SaleModel>? allSales,
    List<SaleModel>? filteredSales,
    SalesSummaryModel? summary,
    ActiveFilters? filters,
    SaleModel? selectedSale,
    bool clearSelectedSale = false,
    SortColumn? sortColumn,
    SortDirection? sortDirection,
    int? currentPage,
    int? pageSize,
  }) {
    return SalesHistoryLoaded(
      allSales: allSales ?? this.allSales,
      filteredSales: filteredSales ?? this.filteredSales,
      summary: summary ?? this.summary,
      filters: filters ?? this.filters,
      selectedSale:
          clearSelectedSale ? null : (selectedSale ?? this.selectedSale),
      sortColumn: sortColumn ?? this.sortColumn,
      sortDirection: sortDirection ?? this.sortDirection,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

// final class SalesHistoryEmpty extends SalesHistoryState {
//   const SalesHistoryEmpty({required this.filters});
//   final ActiveFilters filters;
// }

final class SalesHistoryError extends SalesHistoryState {
  const SalesHistoryError({required this.message});
  final String message;
}
