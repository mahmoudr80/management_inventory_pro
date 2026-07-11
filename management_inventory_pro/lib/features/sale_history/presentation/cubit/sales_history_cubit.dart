import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/core/services/sale_calculator.dart';
import 'package:management_inventory_pro/features/sale_history/data/repository/sale_history_repository.dart';
import 'package:management_inventory_pro/features/pos/data/models/pos_product.dart';
import '../../data/models/sale_item_model.dart';
import '../../data/models/sale_model.dart';
import '../../data/models/sale_summary_model.dart';

part 'sales_history_state.dart';

class SalesHistoryCubit extends Cubit<SalesHistoryState> {
  SalesHistoryCubit(this._repository) : super(const SalesHistoryInitial());

  final SaleHistoryRepository _repository;
  // ---------------------------------------------------------------------------
  // Load / Refresh
  // ---------------------------------------------------------------------------

  Future<void> loadSales() async {
    emit(const SalesHistoryLoading());
    final response = await _repository.getSales();
    switch(response){
      case Success(data:final sales):
        _emitLoaded(sales, const ActiveFilters());
      case Failure(errorModel:final error):
        emit(SalesHistoryError(message: error.message));
    }
  }

  Future<void> refresh() async {
    final currentFilters = _currentFilters();
    emit(const SalesHistoryLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final sales = _mockSales();
      _emitLoaded(sales, currentFilters);
    } catch (e) {
      emit(SalesHistoryError(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Selection
  // ---------------------------------------------------------------------------

  void selectSale(SaleModel sale) {
    final current = state;
    if (current is SalesHistoryLoaded) {
      emit(current.copyWith(selectedSale: sale));
    }
  }

  void clearSelection() {
    final current = state;
    if (current is SalesHistoryLoaded) {
      emit(current.copyWith(clearSelectedSale: true));
    }
  }

  // ---------------------------------------------------------------------------
  // Filters
  // ---------------------------------------------------------------------------

  void search(String query) {
    final current = state;
    if (current is! SalesHistoryLoaded) return;
    final newFilters = current.filters.copyWith(searchQuery: query);
    _applyFilters(current.allSales, newFilters);

  }

  void setDateRangeFilter(DateRangeFilter filter) {
    final current = state;
    if (current is! SalesHistoryLoaded) return;
    final newFilters = current.filters.copyWith(
      dateRangeFilter: filter,
      clearCustomDates: filter != DateRangeFilter.custom,
    );
    _applyFilters(current.allSales, newFilters);
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    final current = state;
    if (current is! SalesHistoryLoaded) return;
    final newFilters = current.filters.copyWith(
      dateRangeFilter: DateRangeFilter.custom,
      customStartDate: start,
      customEndDate: end,
    );
    _applyFilters(current.allSales, newFilters);
  }

  void setPaymentMethod(PaymentMethod method) {
    final current = state;
    if (current is! SalesHistoryLoaded) return;
    final newFilters = current.filters.copyWith(paymentMethod: method);
    _applyFilters(current.allSales, newFilters);
  }

  void resetFilters() {
    final current = state;

    if (current is SalesHistoryLoaded) {
      _applyFilters(
        current.allSales,
        const ActiveFilters(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Sorting
  // ---------------------------------------------------------------------------

  void sortBy(SortColumn column) {
    final current = state;
    if (current is! SalesHistoryLoaded) return;
    final newDirection = current.sortColumn == column &&
        current.sortDirection == SortDirection.ascending
        ? SortDirection.descending
        : SortDirection.ascending;
    final sorted = _sortSales(
      List.from(current.filteredSales),
      column,
      newDirection,
    );
    emit(current.copyWith(
      filteredSales: sorted,
      sortColumn: column,
      sortDirection: newDirection,
      currentPage: 1,
    ));
  }

  // ---------------------------------------------------------------------------
  // Pagination
  // ---------------------------------------------------------------------------

  void goToPage(int page) {
    final current = state;
    if (current is! SalesHistoryLoaded) return;
    if (page < 1 || page > current.totalPages) return;
    emit(current.copyWith(currentPage: page));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  ActiveFilters _currentFilters() {
    final current = state;
    if (current is SalesHistoryLoaded) return current.filters;
    return const ActiveFilters();
  }

  void _applyFilters(List<SaleModel> allSales, ActiveFilters filters) {

    final current = state;
    SortColumn sortCol = SortColumn.dateTime;
    SortDirection sortDir = SortDirection.descending;
    if (current is SalesHistoryLoaded) {
      sortCol = current.sortColumn;
      sortDir = current.sortDirection;
    }

    var filtered = allSales.where((sale) {
      // Search — matches sale ID or any product name in items
      if (filters.searchQuery.isNotEmpty) {
        final q = filters.searchQuery.toLowerCase();
        final matchesId = sale.id.toLowerCase().contains(q);
        final matchesProduct = sale.items
            .any((item) => item.product.name.toLowerCase().contains(q));
        if (!matchesId && !matchesProduct) return false;
      }

      // Payment method — `mixed` is the "show all" sentinel
      if (filters.paymentMethod != PaymentMethod.mixed &&
          sale.paymentMethod != filters.paymentMethod) {
        return false;
      }

      // Date range
      final now = DateTime.now();
      DateTime? from;
      DateTime? to;
      switch (filters.dateRangeFilter) {
        case DateRangeFilter.today:
          from = DateTime(now.year, now.month, now.day);
          to = from.add(const Duration(days: 1));
        case DateRangeFilter.yesterday:
          from = DateTime(now.year, now.month, now.day - 1);
          to = DateTime(now.year, now.month, now.day);
        case DateRangeFilter.last7Days:
          from = now.subtract(const Duration(days: 7));
          to = now;
        case DateRangeFilter.thisMonth:
          from = DateTime(now.year, now.month, 1);
          to = DateTime(now.year, now.month + 1, 1);
        case DateRangeFilter.custom:
          from = filters.customStartDate;
          to = filters.customEndDate?.add(const Duration(days: 1));
      }
      if (from != null && sale.createdAt.isBefore(from)) return false;
      if (to != null && sale.createdAt.isAfter(to)) return false;

      return true;
    }).toList();

    filtered = _sortSales(filtered, sortCol, sortDir);

    final summary = _buildSummary(filtered);

    if (current is SalesHistoryLoaded) {
      emit(current.copyWith(
        filteredSales: filtered,
        summary: summary,
        filters: filters,
        currentPage: 1,
        clearSelectedSale: true,
        sortColumn: sortCol,
        sortDirection: sortDir,
      ));
    } else {
      emit(
        SalesHistoryLoaded(
          allSales: allSales,
          filteredSales: filtered,
          summary: summary,
          filters: filters,
          sortColumn: sortCol,
          sortDirection: sortDir,
        ),
      );
    }
  }

  void _emitLoaded(List<SaleModel> sales, ActiveFilters filters) {
    final filtered = _sortSales(
      List.from(sales),
      SortColumn.dateTime,
      SortDirection.descending,
    );
    emit(
      SalesHistoryLoaded(
        allSales: sales,
        filteredSales: filtered,
        summary: _buildSummary(filtered),
        filters: filters,
      ),
    );

  }

  List<SaleModel> _sortSales(
      List<SaleModel> list,
      SortColumn column,
      SortDirection direction,
      ) {
    list.sort((a, b) {
      int cmp;
      switch (column) {
        case SortColumn.saleId:
          cmp = a.id.compareTo(b.id);
        case SortColumn.dateTime:
          cmp = a.createdAt.compareTo(b.createdAt);
        case SortColumn.itemsCount:
          cmp = a.totalItems.compareTo(b.totalItems);
        case SortColumn.quantity:
          cmp = a.totalQuantity.compareTo(b.totalQuantity);
        case SortColumn.totalAmount:
          cmp = a.totalAmount.compareTo(b.totalAmount);
      }
      return direction == SortDirection.ascending ? cmp : -cmp;
    });
    return list;
  }

  SalesSummaryModel _buildSummary(List<SaleModel> sales) {
    if (sales.isEmpty) {
      return const SalesSummaryModel(
        totalRevenue: 0,
        totalOrders: 0,
        totalItemsSold: 0,
        totalQuantitySold: 0,
        averageOrderValue: 0,
      );
    }
    final totalRevenue = sales.fold(0.0, (s, e) => s + e.totalAmount);
    final totalItems = sales.fold(0, (s, e) => s + e.totalItems);
    final totalQty = sales.fold(0, (s, e) => s + e.totalQuantity);
    return SalesSummaryModel(
      totalRevenue: totalRevenue,
      totalOrders: sales.length,
      totalItemsSold: totalItems,
      totalQuantitySold: totalQty,
      averageOrderValue: totalRevenue / sales.length,
    );
  }

  // ---------------------------------------------------------------------------
  // Mock data (replace with repository)
  // ---------------------------------------------------------------------------

  List<SaleModel> _mockSales() {
    final now = DateTime.now();

    // Reusable mock PosProducts
    final products = [
      PosProduct(id: 'p1', name: 'Coca Cola 330ml', price: 1.50, currentStock: 100, categoryId: 1, unit: 'pcs'),
      PosProduct(id: 'p2', name: 'Pepsi 330ml', price: 1.50, currentStock: 100, categoryId: 1, unit: 'pcs'),
      PosProduct(id: 'p3', name: 'Lays Classic', price: 2.25, currentStock: 50, categoryId: 2, unit: 'pcs'),
      PosProduct(id: 'p4', name: 'Water 1.5L', price: 0.75, currentStock: 200, categoryId: 1, unit: 'pcs'),
    ];

    final cashiers = ['Admin', 'John', 'Mary', 'Sara'];

    return List.generate(28, (i) {
      final index = i + 100;
      final date = now.subtract(Duration(hours: i * 7 + i));
      final method = i % 3 == 0
          ? PaymentMethod.card
          : i % 5 == 0
          ? PaymentMethod.card
          : PaymentMethod.cash;

      final items = [
        SaleItemModel(
          id: 'item-$index-1',
          product: products[0],
          quantity: 2,
          sellingPrice: 1.50,
        ),
        SaleItemModel(
          id: 'item-$index-2',
          product: products[1],
          quantity: 2,
          sellingPrice: 1.50,
        ),
        if (i % 2 == 0)
          SaleItemModel(
            id: 'item-$index-3',
            product: products[2],
            quantity: 2,
            sellingPrice: 2.25,
          ),
        if (i % 3 == 0)
          SaleItemModel(
            id: 'item-$index-4',
            product: products[3],
            quantity: 1,
            sellingPrice: 0.75,
          ),
      ];

      // Mirrors what PosCubit does at real checkout time: run the raw
      // item sum through SaleCalculator so mock rows carry consistent,
      // realistic tax data instead of hand-faked numbers. Every 3rd mock
      // sale simulates tax being enabled (14%, prices exclusive) at the
      // time it was made; the rest simulate tax having been disabled —
      // exercising both branches of the summary/receipt UI.
      final rawSubtotal = items.fold<double>(0, (sum, item) => sum + item.total);
      final taxWasEnabled = i % 3 == 0;
      final totals = SaleCalculator.calculate(
        subtotal: rawSubtotal,
        discountAmount: 0,
        taxEnabled: taxWasEnabled,
        taxPercentage: 14,
        pricesIncludeTax: false,
      );

      return SaleModel(
        id: 'SAL-${index.toString().padLeft(6, '0')}',
        items: items,
        cashierName: cashiers[i % cashiers.length],
        paymentMethod: method,
        status: SaleStatus.completed,
        createdAt: date,
        updatedAt: date,
        notes: i % 4 == 0 ? 'Walk-in customer' : null,
        subtotal: totals.subtotal,
        discountAmount: totals.discountAmount,
        taxEnabled: totals.taxEnabled,
        taxPercentage: totals.taxPercentage,
        taxAmount: totals.taxAmount,
        totalAmount: totals.grandTotal,
      );
    });
  }
}