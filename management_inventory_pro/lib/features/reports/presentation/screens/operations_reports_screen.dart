import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dependency_injection/service_locator.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/repository/reports_stock_adjustment_history_repository.dart';
import '../../data/repository/supplier_purchases_repository.dart';
import '../cubit/stock_adjustment_history_cubit.dart';
import '../cubit/supplier_purchases_cubit.dart';
import 'stock_adjustment_history_screen.dart';
import 'supplier_purchases_screen.dart';

/// Nested under the "Operations" top-level tab in [ReportsScreen]. Same
/// sub-nav chip pattern as [InventoryReportsScreen].
class OperationsReportsScreen extends StatefulWidget {
  const OperationsReportsScreen({super.key});

  @override
  State<OperationsReportsScreen> createState() => _OperationsReportsScreenState();
}

class _OperationsReportsScreenState extends State<OperationsReportsScreen> {
  int _index = 0;

  static const _labels = ['Supplier Purchases', 'Stock Adjustments'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.sm),
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < _labels.length; i++)
                _SubNavChip(label: _labels[i], selected: _index == i, onTap: () => setState(() => _index = i)),
            ],
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _index,
            children: [
              BlocProvider(
                create: (_) => SupplierPurchasesCubit(getIt<SupplierPurchasesRepository>()),
                child: const SupplierPurchasesScreen(),
              ),
              BlocProvider(
                create: (_) => StockAdjustmentHistoryCubit(getIt<ReportsStockAdjustmentHistoryRepository>()),
                child: const StockAdjustmentHistoryScreen(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubNavChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SubNavChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? context.colors.primaryContainer.withOpacity(0.12) : Colors.transparent,
          border: Border.all(color: selected ? context.colors.primary : context.colors.outlineVariant),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySm.copyWith(
            color: selected ? context.colors.primary : context.colors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
