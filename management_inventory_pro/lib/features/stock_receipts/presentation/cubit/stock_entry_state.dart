//part of 'stock_entry_cubit2.dart';
part of 'stock_entry_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StockEntryState
// ─────────────────────────────────────────────────────────────────────────────

enum StockEntryLoadStatus { initial, loading, success, failure }
enum StockEntryActionStatus { idle, loading, success, failure }

class StockEntryState extends Equatable {
  // ── Ledger (list screen) ───────────────────────────────────────────────────
  final StockEntryLoadStatus loadStatus;
  final List<StockEntryModel> entries;
  final StockEntrySummary summary;
  final StockEntryFilter filter;
  final int currentPage;
  final int totalCount;
  final int pageSize;
  final SupplierRef ?selectedSupplier;
  final StockEntryModel ?selectedEntry;
  final bool? clearSelectedEntry;

  // ── Action feedback (add / update / delete) ────────────────────────────────
  final StockEntryActionStatus actionStatus;
  final String? actionError;

  // ── General error for load ─────────────────────────────────────────────────
  final String? loadError;

  const StockEntryState({
    this.loadStatus = StockEntryLoadStatus.initial,
    this.entries = const [],
    this.summary = const StockEntrySummary.empty(),
    this.filter = const StockEntryFilter(),
    this.currentPage = 1,
    this.totalCount = 0,
    this.pageSize = 20,
    this.actionStatus = StockEntryActionStatus.idle,
    this.actionError,
    this.loadError, this.selectedSupplier, this.selectedEntry, this.clearSelectedEntry=false,
  });

  bool get hasMorePages => (currentPage * pageSize) < totalCount;
  static const _unset = Object();
  StockEntryState copyWith({
    StockEntryLoadStatus? loadStatus,
    List<StockEntryModel>? entries,
    StockEntrySummary? summary,
    StockEntryFilter? filter,
    int? currentPage,
    int? totalCount,
    Object? selectedSupplier = _unset,
    Object? selectedEntry = _unset,
    int? pageSize,
    StockEntryActionStatus? actionStatus,
    String? actionError,
    String? loadError,
    bool clearActionError = false,
    bool clearLoadError = false,
    bool clearSelectedEntry = false,

  }) =>
      StockEntryState(
        selectedEntry:selectedEntry==_unset?
        this.selectedEntry:selectedEntry as StockEntryModel?,
        clearSelectedEntry: clearSelectedEntry,
        loadStatus: loadStatus ?? this.loadStatus,
        entries: entries ?? this.entries,
        summary: summary ?? this.summary,
        filter: filter ?? this.filter,
        currentPage: currentPage ?? this.currentPage,
        totalCount: totalCount ?? this.totalCount,
        pageSize: pageSize ?? this.pageSize,
        actionStatus: actionStatus ?? this.actionStatus,
        actionError: clearActionError ? null : actionError ?? this.actionError,
        loadError: clearLoadError ? null : loadError ?? this.loadError,
          selectedSupplier: selectedSupplier == _unset
              ? this.selectedSupplier
              : selectedSupplier as SupplierRef?
      );

  @override
  List<Object?> get props => [
        loadStatus,
        entries,
        summary,
        filter,
        currentPage,
        totalCount,
        pageSize,
        actionStatus,
        actionError,
        loadError,
        selectedSupplier,
        selectedEntry,
        selectedEntry,
        clearSelectedEntry
      ];
}
