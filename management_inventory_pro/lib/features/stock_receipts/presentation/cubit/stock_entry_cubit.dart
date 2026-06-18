import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/stock_entry_filter.dart';
import '../../data/models/stock_entry_line_model.dart';
import '../../data/models/stock_entry_model.dart';
import '../../data/models/stock_entry_status.dart';
import '../../data/models/stock_entry_summary.dart';
import '../../data/respository/stock_entry_repository.dart';

part 'stock_entry_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StockEntryCubit
//
// Manages the Stock Entry Ledger and the New / Edit form.
// UI layer calls public methods; state drives both screens.
// ─────────────────────────────────────────────────────────────────────────────

class StockEntryCubit extends Cubit<StockEntryState> {
  final StockEntryRepository _repository;

  StockEntryCubit(this._repository) : super(const StockEntryState());

  // ── Ledger ─────────────────────────────────────────────────────────────────

  /// Initial load: summary + first page of entries.
  /// Applies the currently active filter (supplier / date / status) —
  /// this was previously ignoring state.filter entirely.
  Future<void> loadEntries() async {
    final filtered = _applyFilter(_mockEntries, state.filter);
    emit(
      state.copyWith(
        loadStatus: StockEntryLoadStatus.success,
        entries: filtered,
        totalCount: filtered.length,
        summary: _buildSummary(),
      ),
    );
  }

  /// Append the next page of results (infinite-scroll / pagination button).
  Future<void> loadMoreEntries() async {
    if (!state.hasMorePages) return;
    final nextPage = state.currentPage + 1;
    try {
      final more = await _repository.getEntries(
        filter: state.filter,
        page: nextPage,
        pageSize: state.pageSize,
      );
      emit(state.copyWith(
        entries: [...state.entries, ...more],
        currentPage: nextPage,
      ));
    } catch (_) {
      // silently ignore pagination errors; existing data stays visible.
    }
  }

  // ── Search & Filter ────────────────────────────────────────────────────────

  /// Full-text search against receipt ID and supplier name.
  /// Now layers on top of the active filter instead of replacing it, so
  /// typing a query no longer wipes out an active supplier/date/status
  /// filter.
  Future<void> search(String query) async {
    final q = query.toLowerCase();
    final filtered = _applyFilter(_mockEntries, state.filter).where((e) {
      return e.id.toLowerCase().contains(q) ||
          (e.supplierName != null &&
              e.supplierName!.toLowerCase().contains(q));
    }).toList();

    emit(state.copyWith(entries: filtered, totalCount: filtered.length));
  }

  /// Apply filter dimensions. Pass null for a dimension to clear it.
  Future<void> applyFilter({
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

  /// Reset all active filters and reload.
  Future<void> clearFilters() async {
    emit(state.copyWith(filter: const StockEntryFilter()));
    await loadEntries();
  }

  // ── Filtering helper ───────────────────────────────────────────────────────

  /// Applies a [StockEntryFilter] to a list of entries. Centralized here so
  /// loadEntries(), search(), and any future caller all filter consistently.
  List<StockEntryModel> _applyFilter(
    List<StockEntryModel> entries,
    StockEntryFilter filter,
  ) {
    return entries.where((e) {
      if (filter.supplierId != null && e.supplierId != filter.supplierId) {
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
        final start =
            DateTime(range.start.year, range.start.month, range.start.day);
        final end =
            DateTime(range.end.year, range.end.month, range.end.day);
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
    _mockEntries.insert(0, entry);

    emit(
      state.copyWith(
        entries: List.from(_mockEntries),
        totalCount: _mockEntries.length,
        summary: _buildSummary(),
        actionStatus: StockEntryActionStatus.success,
      ),
    );
    }


  /// Update an existing receipt (status must be pending).
  Future<void> updateEntry(StockEntryModel entry) async {
    final index = _mockEntries.indexWhere((e) => e.id == entry.id);

    if (index == -1) return;

    _mockEntries[index] = entry;

    emit(
      state.copyWith(
        entries: List.from(_mockEntries),
        actionStatus: StockEntryActionStatus.success,
      ),
    );
  }

  /// Delete a receipt by id.
  Future<void> deleteEntry(String id) async {
    _mockEntries.removeWhere((e) => e.id == id);

    emit(
      state.copyWith(
        entries: List.from(_mockEntries),
        totalCount: _mockEntries.length,
        summary: _buildSummary(),
        actionStatus: StockEntryActionStatus.success,
      ),
    );
  }

  /// Generate the next receipt ID for the New Entry form.
  Future<String> generateReceiptId() async {
    return await "idx ${DateTime.now().millisecond.toString()} ";
  }

  /// Reset the action status back to idle (call after dialog closes).
  void resetActionStatus() {
    emit(state.copyWith(
      actionStatus: StockEntryActionStatus.idle,
      clearActionError: true,
    ));
  }
}


final _mockEntries = [
  StockEntryModel(
    id: 'REC-2026-001',
    supplierId: '1',
    supplierName: 'ABC Trading',
    receiptDate: DateTime.now(),
    status: StockEntryStatus.verified,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    notes: 'First receipt',
    lines: [
      StockEntryLineModel(
        id: '1',
        productId: '1',
        productName: 'Rice',
        productSku: 'RIC-001',
        quantity: 10,
        unitCost: 50,
      ),
      StockEntryLineModel(
        id: '2',
        productId: '2',
        productName: 'Sugar',
        productSku: 'SUG-001',
        quantity: 5,
        unitCost: 20,
      ),
    ],
  ),

  StockEntryModel(
    id: 'REC-2026-002',
    supplierId: '2',
    supplierName: 'Global Logistics',
    receiptDate: DateTime.now().subtract(const Duration(days: 1)),
    status: StockEntryStatus.pending,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    lines: [
      StockEntryLineModel(
        id: '3',
        productId: '3',
        productName: 'Oil',
        productSku: 'OIL-001',
        quantity: 8,
        unitCost: 120,
      ),
    ],
  ),
];
StockEntrySummary _buildSummary() {
  return StockEntrySummary(
    totalReceipts: _mockEntries.length,

    totalItems: _mockEntries.fold(
      0,
          (sum, entry) => sum + entry.totalItems,
    ),

    totalValue: _mockEntries.fold(
      0.0,
          (sum, entry) => sum + entry.totalValue,
    ),

    pendingReceipts: _mockEntries.where(
          (e) => e.status == StockEntryStatus.pending,
    ).length,

    verifiedReceipts: _mockEntries.where(
          (e) => e.status == StockEntryStatus.verified,
    ).length,

    cancelledReceipts: _mockEntries.where(
          (e) => e.status == StockEntryStatus.cancelled,
    ).length,
  );
}
