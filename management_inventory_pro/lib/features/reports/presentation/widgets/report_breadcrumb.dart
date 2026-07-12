import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// The "Reports > Stock Movement" trail shown above every report's title
/// in the reference UI. None of the report screens rendered
/// [ReportWorkspace.breadcrumb] before this — the slot existed on
/// [PageHeader] but nothing supplied it. Deliberately static text, not a
/// tappable link: there's no report-list route to link back to, the tab
/// bar in [ReportsScreen] / [InventoryReportsScreen] /
/// [OperationsReportsScreen] already is the "back to reports" affordance.
class ReportBreadcrumb extends StatelessWidget {
  final String currentLabel;
  final String parentLabel;

  const ReportBreadcrumb({
    super.key,
    required this.currentLabel,
    this.parentLabel = 'Reports',
  });

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodySm.copyWith(color: context.colors.textSecondary);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(parentLabel, style: mutedStyle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(Icons.chevron_right, size: 16, color: context.colors.outline),
        ),
        Text(
          currentLabel,
          style: mutedStyle.copyWith(color: context.colors.primary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
