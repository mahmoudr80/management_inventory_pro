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
    this.loadError,
  });

  bool get hasMorePages => (currentPage * pageSize) < totalCount;

  StockEntryState copyWith({
    StockEntryLoadStatus? loadStatus,
    List<StockEntryModel>? entries,
    StockEntrySummary? summary,
    StockEntryFilter? filter,
    int? currentPage,
    int? totalCount,
    int? pageSize,
    StockEntryActionStatus? actionStatus,
    String? actionError,
    String? loadError,
    bool clearActionError = false,
    bool clearLoadError = false,
  }) =>
      StockEntryState(
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
      ];
}
