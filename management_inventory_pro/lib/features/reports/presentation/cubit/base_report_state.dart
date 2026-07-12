import 'package:flutter/foundation.dart';
import '../../data/models/report_filter_state.dart';

enum ReportStatus { initial, loading, loaded, empty, error }

/// Base state every concrete report state extends. [T] is the report's
/// fully-loaded payload (e.g. a future SalesReportData with summary +
/// table rows already computed).
@immutable
class BaseReportState<T> {
  final ReportStatus status;
  final ReportFilterState filters;
  final T? data;
  final String? errorMessage;

  const BaseReportState({
    required this.status,
    required this.filters,
    this.data,
    this.errorMessage,
  });

  factory BaseReportState.initial(ReportFilterState filters) =>
      BaseReportState<T>(status: ReportStatus.initial, filters: filters);

  bool get isLoading => status == ReportStatus.loading;
  bool get isEmpty => status == ReportStatus.empty;
  bool get isError => status == ReportStatus.error;
  bool get hasData => status == ReportStatus.loaded && data != null;

  BaseReportState<T> copyWith({
    ReportStatus? status,
    ReportFilterState? filters,
    T? data,
    String? errorMessage,
  }) {
    return BaseReportState<T>(
      status: status ?? this.status,
      filters: filters ?? this.filters,
      data: data ?? this.data,
      // Deliberately not falling back to `this.errorMessage` — every
      // state transition (load/refresh/filter change) should clear a
      // stale error unless the caller explicitly sets a new one.
      errorMessage: errorMessage,
    );
  }
}
