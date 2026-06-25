import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/product_ref.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/supplier_ref.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/stock_entry_filter.dart';
import '../../data/models/stock_entry_line_model.dart';
import '../../data/models/stock_entry_model.dart';
import '../../data/models/stock_entry_status.dart';
import '../../data/models/stock_entry_summary.dart';
import '../../data/respository/stock_entry_repository.dart';

part 'stock_entry_state.dart';

class StockEntryCubit extends Cubit<StockEntryState> {
  final StockEntryRepository _repository;

  StockEntryCubit(this._repository) : super(const StockEntryState());
  List<StockEntryModel> _allEntries = [];

  Future<void> loadEntries() async {
    final response = await _repository.getEntries();
    switch (response) {
      case Success(data: final entries):
        final filtered = _applyFilter(entries, state.filter);
        _allEntries = entries;
        emit(
          state.copyWith(
            loadStatus: StockEntryLoadStatus.success,
            entries: filtered,
            totalCount: filtered.length,
            summary: _buildSummary(entries: filtered),
          ),
        );
      case Failure(errorModel: final error):
        emit(
          state.copyWith(
            loadStatus: StockEntryLoadStatus.failure,
            actionError: error.message,
            summary: _buildSummary(),
          ),
        );
    }
  }

  Future<void> loadMoreEntries() async {}

  bool search(String query) {
    final q = query.toLowerCase();
    final filtered = _applyFilter(_allEntries, state.filter).where((e) {
      return e.id.toLowerCase().contains(q) ||
          (e.supplier.name != null &&
              e.supplier.name!.toLowerCase().contains(q)) ||
          (e.supplier.id != null && e.supplier.id!.toLowerCase().contains(q));
    }).toList();
    emit(state.copyWith(entries: filtered, totalCount: filtered.length));
    if (filtered.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void selectSupplier(SupplierRef? supplier) {
    emit(state.copyWith(selectedSupplier: supplier));
  }
  void selectEntry(StockEntryModel entry) {
    emit(state.copyWith(selectedEntry: entry));
  }

  void clearSelection() {
    emit(state.copyWith(clearSelectedEntry: true));
  }

  Future<void> applyFilter({
    SupplierRef? selectedSupplier,
    String? supplierId,
    DateTimeRange? dateRange,
    StockEntryStatus? status,
    bool clearSupplier = false,
    bool clearDate = false,
    bool clearStatus = false,
  }) async {
    final newFilter = state.filter.copyWith(
      supplierId: supplierId,
      dateRange: dateRange,
      status: status,
      clearSupplier: clearSupplier,
      clearDate: clearDate,
      clearStatus: clearStatus,
    );
    emit(state.copyWith(filter: newFilter));
    await loadEntries();
  }

  Future<void> clearFilters() async {
    emit(state.copyWith(filter: const StockEntryFilter()));
    await loadEntries();
  }

  List<StockEntryModel> _applyFilter(
    List<StockEntryModel> entries,
    StockEntryFilter filter,
  ) {
    return entries.where((e) {
      if (filter.supplierId != null && e.supplier.id != filter.supplierId) {
        return false;
      }

      if (filter.status != null && e.status != filter.status) {
        return false;
      }

      if (filter.dateRange != null) {
        final range = filter.dateRange!;
        final day = DateTime(
          e.receiptDate.year,
          e.receiptDate.month,
          e.receiptDate.day,
        );
        final start = DateTime(
          range.start.year,
          range.start.month,
          range.start.day,
        );
        final end = DateTime(range.end.year, range.end.month, range.end.day);
        if (day.isBefore(start) || day.isAfter(end)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  /// Persist a new stock receipt. On success refreshes the ledger.
  Future<void> addEntry(StockEntryModel entry) async {
    // if (isClosed) {
    //   return;
    // }
    emit(state.copyWith(loadStatus: StockEntryLoadStatus.loading));

    final response = await _repository.addEntry(entry);
    switch (response) {
      case Success():
        final filtered = _applyFilter([..._allEntries, entry], state.filter);
        if (isClosed) {
          return;
        }
        emit(
          state.copyWith(
            entries: filtered,
            actionStatus: StockEntryActionStatus.success,
            totalCount: filtered.length,
            summary: _buildSummary(entries: filtered),
            loadStatus: StockEntryLoadStatus.success,
          ),
        );
      case Failure(errorModel: final error):
        if (isClosed) {
          return;
        }
        emit(state.copyWith(actionError: error.message));
    }
  }

  /// Update an existing receipt (status must be pending).
  Future<void> updateEntry(StockEntryModel entry) async {
    final response = await _repository.updateEntry(entry);
    switch (response) {
      case Success():
        final filtered = _applyFilter([
          ..._allEntries.where((e) => e.id != entry.id),
          entry,
        ], state.filter);
        if (isClosed) {
          return;
        }
        emit(
          state.copyWith(
            entries: filtered,
            actionStatus: StockEntryActionStatus.success,
            totalCount: filtered.length,
            summary: _buildSummary(entries: filtered),
            loadStatus: StockEntryLoadStatus.success,
          ),
        );
      case Failure(errorModel: final error):
        if (isClosed) {
          return;
        }
        emit(state.copyWith(actionError: error.message));
    }
  }

  /// Delete a receipt by id.
  Future<void> deleteEntry(String id) async {
    final response = await _repository.deleteEntry(id);
    switch (response) {
      case Success():
        final filtered = _applyFilter(
          _allEntries.where((e) => e.id != id).toList(),
          state.filter,
        );
        if (isClosed) {
          return;
        }
        emit(
          state.copyWith(
            entries: filtered,
            actionStatus: StockEntryActionStatus.success,
            totalCount: filtered.length,
            summary: _buildSummary(entries: filtered),
            loadStatus: StockEntryLoadStatus.success,
          ),
        );
      case Failure(errorModel: final error):
        if (isClosed) {
          return;
        }
        emit(state.copyWith(actionError: error.message));
    }
  }

  Future<String> generateReceiptId() async {
    return Uuid().v4().toString();
  }

  void resetActionStatus() {
    emit(
      state.copyWith(
        actionStatus: StockEntryActionStatus.idle,
        clearActionError: true,
      ),
    );
  }
}

StockEntrySummary _buildSummary({List<StockEntryModel>? entries}) {
  if (entries != null) {
    return StockEntrySummary(
      totalReceipts: entries.length,

      totalItems: entries.fold(
        0,
        (sum, entry) => sum.toInt() + (entry.totalItems ?? 0),
      ),

      totalValue: entries.fold(
        0.0,
        (sum, entry) => sum + (entry.totalCost ?? 0),
      ),

      pendingReceipts: entries
          .where((e) => e.status == StockEntryStatus.pending)
          .length,

      verifiedReceipts: entries
          .where((e) => e.status == StockEntryStatus.verified)
          .length,

      cancelledReceipts: entries
          .where((e) => e.status == StockEntryStatus.cancelled)
          .length,
    );
  }
  return StockEntrySummary(
    totalReceipts: 0,
    totalItems: 0,
    totalValue: 0,
    pendingReceipts: 0,
    cancelledReceipts: 0,
    verifiedReceipts: 0,
  );
}
