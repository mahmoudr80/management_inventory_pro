import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/stock_entry_status.dart';

class StockEntryFilter {
  final String? supplierId;
  final DateTimeRange? dateRange;
  final StockEntryStatus? status;
  final String? searchQuery;

  const StockEntryFilter({
    this.supplierId,
    this.dateRange,
    this.status,
    this.searchQuery,
  });

  StockEntryFilter copyWith({
    String? supplierId,
    DateTimeRange? dateRange,
    StockEntryStatus? status,
    String? searchQuery,
    bool clearSupplier = false,
    bool clearDate = false,
    bool clearStatus = false,
    bool clearSearch = false,
  }) =>
      StockEntryFilter(
        supplierId: clearSupplier ? null : supplierId ?? this.supplierId,
        dateRange: clearDate ? null : dateRange ?? this.dateRange,
        status: clearStatus ? null : status ?? this.status,
        searchQuery: clearSearch ? null : searchQuery ?? this.searchQuery,
      );

  bool get isEmpty =>
      supplierId == null &&
          dateRange == null &&
          status == null &&
          (searchQuery == null || searchQuery!.isEmpty);
}