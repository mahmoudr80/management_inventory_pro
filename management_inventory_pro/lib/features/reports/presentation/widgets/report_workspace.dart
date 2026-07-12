import 'package:flutter/material.dart';
import '../../../../core/components/page_header.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// The single reusable shell every report screen is built from:
/// Header -> Filters -> Summary Cards -> Chart/Table Area -> Pagination.
/// Concrete report screens supply each slot; none of them lay out this
/// structure themselves.
///
/// Layout note: the header band (breadcrumb/title/actions) is pinned
/// above the scrollable body, not part of it — matches the reference
/// UI, where the page header never moves while filters/table scroll
/// underneath it. Everything below the header — filter bar, summary
/// cards, chart/table, pagination — scrolls as one region.
///
/// [bentoChart] switches the chart+table area between the reference UI's
/// two observed patterns:
///  - `false` (default): chart full-width above the table (Sales Report's
///    "Revenue Trend" above "Transaction Log").
///  - `true`: chart and table side by side, chart taking 1/3 and the
///    table 2/3 (Inventory Valuation's "Value by Category" donut next to
///    "Top Value Items"), collapsing to stacked below
///    [AppBreakpoints.medium] so it never overflows on a narrower
///    desktop window.
class ReportWorkspace extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? breadcrumb;
  final List<Widget>? headerActions;
  final Widget filterBar;
  final Widget summaryCards;
  final Widget? chart;
  final Widget table;
  final Widget? pagination;
  final bool bentoChart;

  const ReportWorkspace({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumb,
    this.headerActions,
    required this.filterBar,
    required this.summaryCards,
    this.chart,
    required this.table,
    this.pagination,
    this.bentoChart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderBand(
          title: title,
          subtitle: subtitle,
          breadcrumb: breadcrumb,
          actions: headerActions,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                filterBar,
                const SizedBox(height: AppSpacing.lg),
                summaryCards,
                const SizedBox(height: AppSpacing.lg),
                _chartAndTable(),
                if (pagination != null) pagination!,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chartAndTable() {
    if (chart == null) return table;

    if (!bentoChart) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [chart!, const SizedBox(height: AppSpacing.lg), table],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.medium) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [chart!, const SizedBox(height: AppSpacing.lg), table],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 1, child: chart!),
              const SizedBox(width: AppSpacing.lg),
              Expanded(flex: 2, child: table),
            ],
          ),
        );
      },
    );
  }
}

/// Non-scrolling header band. Title row is a [Wrap] rather than a fixed
/// [Row] so header actions (Refresh / Export / Print, etc.) drop to a
/// second line instead of overflowing when the window is narrow —
/// [PageHeader] itself lays breadcrumb/title/actions out for the
/// desktop case, but has no knowledge of the available width, so the
/// narrow-width decision (hide actions from PageHeader, render them
/// as a wrapped row underneath instead) is made here.
class _HeaderBand extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? breadcrumb;
  final List<Widget>? actions;

  const _HeaderBand({
    required this.title,
    this.subtitle,
    this.breadcrumb,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: context.colors.cardBorder)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < AppBreakpoints.compact;
          final header = PageHeader(
            title: title,
            subtitle: subtitle,
            breadcrumb: breadcrumb,
            actions: narrow ? null : actions,
          );

          if (!narrow || actions == null || actions!.isEmpty) return header;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              const SizedBox(height: AppSpacing.sm),
              Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: actions!),
            ],
          );
        },
      ),
    );
  }
}
