import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dependency_injection/service_locator.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/repository/profit_report_repository.dart';
import '../../data/repository/sales_report_repository.dart';
import '../cubit/profit_report_cubit.dart';
import '../cubit/sales_report_cubit.dart';
import 'inventory_reports_screen.dart';
import 'operations_reports_screen.dart';
import 'profit_report_screen.dart';
import 'sales_report_screen.dart';

/// Entry point wired into the sidebar's "Reports" nav item. All four tabs
/// (Sales / Profit / Inventory / Operations) are live as of Section 3 —
/// the previous Section 2 version rendered Inventory/Operations disabled
/// pending this work.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.pagePadding,
            right: AppSpacing.pagePadding,
            top: AppSpacing.pagePadding,
          ),
          // Horizontal scroll rather than Wrap: these are page-level tabs
          // (one active view at a time), so dropping to a second line
          // would misread as a second row of equally-weighted nav rather
          // than an overflow affordance. The sub-nav chips in
          // InventoryReportsScreen/OperationsReportsScreen use Wrap
          // instead because those sit *within* an already-selected tab
          // and reflowing them doesn't compete with anything above.
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ReportTab(label: 'Sales', selected: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
                const SizedBox(width: AppSpacing.lg),
                _ReportTab(label: 'Profit', selected: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
                const SizedBox(width: AppSpacing.lg),
                _ReportTab(label: 'Inventory', selected: _tabIndex == 2, onTap: () => setState(() => _tabIndex = 2)),
                const SizedBox(width: AppSpacing.lg),
                _ReportTab(label: 'Operations', selected: _tabIndex == 3, onTap: () => setState(() => _tabIndex = 3)),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: context.colors.dividerSubtle),
        Expanded(
          child: IndexedStack(
            index: _tabIndex,
            children: [
              BlocProvider(
                create: (_) => SalesReportCubit(getIt<SalesReportRepository>()),
                child: const SalesReportScreen(),
              ),
              BlocProvider(
                create: (_) => ProfitReportCubit(getIt<ProfitReportRepository>()),
                child: const ProfitReportScreen(),
              ),
              const InventoryReportsScreen(),
              const OperationsReportsScreen(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ReportTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(
                color: selected ? context.colors.primary : context.colors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(height: 2, width: 40, color: selected ? context.colors.primary : Colors.transparent),
          ],
        ),
      ),
    );
  }
}
