import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/models/report_date_range.dart';

/// Shared filter row: date range + report-specific filters via [trailing]
/// + a "Clear Filters" link.
///
/// Search used to live here too (an inline [TextField] driven by
/// [onSearchChanged]/[searchHint]). Moved out: the reference UI puts
/// per-report search inside the *table's* header ("Filter invoices...",
/// "Search SKU..." — see code.html and Image 2's "Search SKU..." field),
/// not the filter bar. Screens now pass search into
/// [ReportDataTable.headerTrailing] instead — see
/// `_TableSearchField` in each report screen.
///
/// [onRefresh] is kept for API compatibility (some report screens may
/// still want a filter-row refresh affordance) but the reference UI puts
/// Refresh as a header-level action next to Export/Print, not in the
/// filter row — see each screen's `headerActions`. The filter row itself
/// only carries a plain text "Clear Filters" link (matching the
/// reference's Sales Reports filter bar) rather than a bordered
/// icon+label button, to avoid two refresh affordances competing for
/// attention in the same row.
class ReportFilterBar extends StatelessWidget {
  final ReportDateRange selectedRange;
  final ValueChanged<ReportDateRange> onDateRangeChanged;
  final VoidCallback onRefresh;
  final VoidCallback onReset;
  final List<Widget> trailing;

  const ReportFilterBar({
    super.key,
    required this.selectedRange,
    required this.onDateRangeChanged,
    required this.onRefresh,
    required this.onReset,
    this.trailing = const [],
  });

  static const _presets = [
    ReportDateRangePreset.today,
    ReportDateRangePreset.last7Days,
    ReportDateRangePreset.last30Days,
    ReportDateRangePreset.thisMonth,
    ReportDateRangePreset.lastMonth,
  ];

  ReportDateRange _rangeFor(ReportDateRangePreset preset) {
    switch (preset) {
      case ReportDateRangePreset.today:
        return ReportDateRange.today();
      case ReportDateRangePreset.last7Days:
        return ReportDateRange.last7Days();
      case ReportDateRangePreset.last30Days:
        return ReportDateRange.last30Days();
      case ReportDateRangePreset.thisMonth:
        return ReportDateRange.thisMonth();
      case ReportDateRangePreset.lastMonth:
        return ReportDateRange.lastMonth();
      case ReportDateRangePreset.custom:
        return selectedRange;
      case ReportDateRangePreset.yesterday:
        return ReportDateRange.yesterday();
      case ReportDateRangePreset.thisWeek:
        return ReportDateRange.thisWeek();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              // .end, not .center: [ReportSelectFilter] entries now render
              // a label-caps caption above their dropdown, making them
              // taller than the plain [_DateRangeDropdown]. Bottom-aligning
              // keeps every control's actual input box on the same line,
              // matching the reference filter bar.
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _DateRangeDropdown(
                  selected: selectedRange.preset,
                  presets: _presets,
                  onChanged: (preset) => onDateRangeChanged(_rangeFor(preset)),
                ),
                ...trailing,
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: onReset,
            style: TextButton.styleFrom(
              foregroundColor: context.colors.primary,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            ),
            child: Text('Clear Filters', style: AppTextStyles.bodySm.copyWith(color: context.colors.primary)),
          ),
        ],
      ),
    );
  }
}

class _DateRangeDropdown extends StatelessWidget {
  final ReportDateRangePreset selected;
  final List<ReportDateRangePreset> presets;
  final ValueChanged<ReportDateRangePreset> onChanged;

  const _DateRangeDropdown({required this.selected, required this.presets, required this.onChanged});

  String _label(ReportDateRangePreset preset) {
    switch (preset) {
      case ReportDateRangePreset.today:
        return 'Today';
      case ReportDateRangePreset.last7Days:
        return 'Last 7 Days';
      case ReportDateRangePreset.last30Days:
        return 'Last 30 Days';
      case ReportDateRangePreset.thisMonth:
        return 'This Month';
      case ReportDateRangePreset.lastMonth:
        return 'Last Month';
      case ReportDateRangePreset.custom:
        return 'Custom Range';
      case ReportDateRangePreset.yesterday:
        return 'Yesterday';
      case ReportDateRangePreset.thisWeek:
        return 'This Week';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportDateRangePreset>(
          value: selected == ReportDateRangePreset.custom ? null : selected,
          hint: Text(_label(ReportDateRangePreset.custom), style: AppTextStyles.bodySm),
          icon: Icon(Icons.calendar_today_outlined, size: AppIconSize.sm, color: context.colors.outline),
          style: AppTextStyles.bodySm.copyWith(color: context.colors.textPrimary),
          items: presets.map((p) => DropdownMenuItem(value: p, child: Text(_label(p)))).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}