import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import 'report_empty_state.dart';
import 'report_error_state.dart';
import 'report_loading_state.dart';

enum ReportColumnAlign { left, right, center }

/// Per-row visual treatment for [ReportDataTable] — e.g. the reference
/// UI's refund row (Image 3, INV-24-005), which gets a tinted background
/// plus a colored left accent border. Deliberately generic (not
/// `isRefund`/`isError`) so any report can flag any row for any reason
/// without ReportDataTable needing to know what that reason is.
class DataRowStyle {
  final Color? backgroundColor;
  final Color? leftBorderColor;

  const DataRowStyle({this.backgroundColor, this.leftBorderColor});
}

/// One column definition for [ReportDataTable]. [cellBuilder] returns the
/// cell content for a given row of type [T] — kept as a builder (not a
/// plain value getter) so a report can render pills, links, or mono-font
/// numbers per column, matching the reference UI's Movement Ledger /
/// Transaction Log tables.
class ReportTableColumn<T> {
  final String label;
  final ReportColumnAlign align;
  final bool sortable;
  final Widget Function(BuildContext context, T row) cellBuilder;

  const ReportTableColumn({
    required this.label,
    required this.cellBuilder,
    this.align = ReportColumnAlign.left,
    this.sortable = false,
  });
}

/// The dense, bordered, hover-highlighted table used by every report.
/// Sorting/searching/pagination are driven externally by the owning
/// cubit; this widget only renders whatever [rows] it's given plus the
/// current sort indicator.
///
/// Phase 3 change: added [isError]/[errorMessage]/[onRetry]. Precedence
/// is error > loading > empty > data — once a query has failed there's
/// nothing to page through, so it takes priority over the other two
/// placeholder states.
class ReportDataTable<T> extends StatelessWidget {
  final String title;
  final List<ReportTableColumn<T>> columns;
  final List<T> rows;
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueChanged<int>? onSort;
  final Widget? headerTrailing;
  final String emptyMessage;

  /// When set, constrains the table body to this height with its own
  /// vertical scroll instead of growing to fit every row — matches the
  /// reference UI's fixed-height "Top Value Items" panel sitting next to
  /// a same-height chart card (see [ReportWorkspace.bentoChart]). Left
  /// null (default) for every report that isn't paired with a chart,
  /// where the table should just take whatever height its rows need.
  final double? maxHeight;

  /// Optional per-row style — see [DataRowStyle]. Returns null for rows
  /// that don't need any special treatment (the common case).
  final DataRowStyle? Function(BuildContext context, T row)? rowStyleBuilder;

  const ReportDataTable({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.onRetry,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.headerTrailing,
    this.emptyMessage = 'No records found.',
    this.maxHeight,
    this.rowStyleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.colors.cardBorder)),
              color: context.colors.tableHeaderBg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.headlineSm.copyWith(color: context.colors.textPrimary)),
                if (headerTrailing != null) headerTrailing!,
              ],
            ),
          ),
          if (isError)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: ReportErrorState(
                message: errorMessage ?? 'Something went wrong loading this report.',
                onRetry: onRetry,
              ),
            )
          else if (isLoading)
            const Padding(padding: EdgeInsets.all(AppSpacing.xxl), child: ReportLoadingState())
          else if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: ReportEmptyState(message: emptyMessage),
            )
          else
            _tableBody(context),
        ],
      ),
    );
  }

  Widget _tableBody(BuildContext context) {
    final scrollable = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: sortColumnIndex,
        sortAscending: sortAscending,
        headingRowColor: WidgetStateProperty.all(context.colors.tableHeaderBg),
        headingTextStyle: AppTextStyles.labelCaps.copyWith(color: context.colors.textSecondary),
        dataTextStyle: AppTextStyles.dataMono.copyWith(color: context.colors.textPrimary),
        dataRowMinHeight: AppSize.tableRowHeight,
        dataRowMaxHeight: AppSize.tableRowHeight,
        columnSpacing: AppSpacing.xl,
        columns: [
          for (var i = 0; i < columns.length; i++)
            DataColumn(
              label: Expanded(
                child: Align(
                  alignment: _alignmentFor(columns[i].align),
                  child: Text(columns[i].label.toUpperCase()),
                ),
              ),
              numeric: columns[i].align == ReportColumnAlign.right,
              onSort: columns[i].sortable && onSort != null ? (index, _) => onSort!(index) : null,
            ),
        ],
        rows: [
          for (final row in rows) _buildRow(context, row),
        ],
      ),
    );

    if (maxHeight == null) return scrollable;
    return SizedBox(
      height: maxHeight,
      child: SingleChildScrollView(child: scrollable),
    );
  }

  DataRow _buildRow(BuildContext context, T row) {
    final style = rowStyleBuilder?.call(context, row);

    return DataRow(
      color: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.hovered)
            ? context.colors.tableRowHover
            : style?.backgroundColor,
      ),
      cells: [
        for (var i = 0; i < columns.length; i++)
          DataCell(
            // The left accent border (reference UI's refund row, Image 3)
            // has no direct DataTable equivalent — DataRow only supports a
            // background color, not a per-row border. Painting a thin
            // colored strip on the leading edge of the first cell reads
            // as the same "flagged row" affordance without needing a
            // custom table implementation.
            i == 0 && style?.leftBorderColor != null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: style!.leftBorderColor!, width: 2)),
                    ),
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: Align(
                      alignment: _alignmentFor(columns[i].align),
                      child: columns[i].cellBuilder(context, row),
                    ),
                  )
                : Align(
                    alignment: _alignmentFor(columns[i].align),
                    child: columns[i].cellBuilder(context, row),
                  ),
          ),
      ],
    );
  }

  Alignment _alignmentFor(ReportColumnAlign align) {
    switch (align) {
      case ReportColumnAlign.left:
        return Alignment.centerLeft;
      case ReportColumnAlign.right:
        return Alignment.centerRight;
      case ReportColumnAlign.center:
        return Alignment.center;
    }
  }
}
