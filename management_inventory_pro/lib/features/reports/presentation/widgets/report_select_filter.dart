import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// One option in a [ReportSelectFilter] — [value] is what gets written
/// into `ReportFilterState.extra[key]` (e.g. a supplier id), [label] is
/// what's shown (e.g. the supplier's company name).
class ReportSelectOption {
  final String value;
  final String label;

  const ReportSelectOption({required this.value, required this.label});
}

/// Generic "All X" + option-list dropdown for the four Phase 3
/// Professional Filters (Payment Method, Category, Supplier, Product).
/// Deliberately one widget instead of four near-identical ones — each
/// call site only differs in [label], [options], and which
/// `ReportFilterState.extra` key it writes to via [onChanged]. Sits in
/// [ReportFilterBar.trailing], which was reserved for exactly this in
/// Section 1.
class ReportSelectFilter extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<ReportSelectOption> options;
  final ValueChanged<String?> onChanged;

  const ReportSelectFilter({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Reference UI (code.html) puts a label-caps caption above each of
    // these dropdowns — "CATEGORY", "SUPPLIER", "PAYMENT" — not just
    // placeholder text inside the control. Previously this widget only
    // rendered the "All {label}" hint, so that caption never appeared.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.labelCaps.copyWith(color: context.colors.textSecondary),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: selectedValue,
              hint: Text('All $label', style: AppTextStyles.bodySm),
              icon: Icon(Icons.expand_more, size: AppIconSize.sm, color: context.colors.outline),
              style: AppTextStyles.bodySm.copyWith(color: context.colors.textPrimary),
              items: [
                DropdownMenuItem<String?>(value: null, child: Text('All $label')),
                for (final option in options)
                  DropdownMenuItem<String?>(value: option.value, child: Text(option.label)),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
