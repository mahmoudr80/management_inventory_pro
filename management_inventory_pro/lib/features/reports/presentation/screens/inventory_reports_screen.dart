import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dependency_injection/service_locator.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/repository/inventory_valuation_repository.dart';
import '../../data/repository/low_stock_repository.dart';
import '../../data/repository/out_of_stock_repository.dart';
import '../../data/repository/stock_movement_repository.dart';
import '../cubit/inventory_valuation_cubit.dart';
import '../cubit/low_stock_cubit.dart';
import '../cubit/out_of_stock_cubit.dart';
import '../cubit/stock_movement_cubit.dart';
import 'inventory_valuation_screen.dart';
import 'low_stock_screen.dart';
import 'out_of_stock_screen.dart';
import 'stock_movement_screen.dart';

/// Nested under the "Inventory" top-level tab in [ReportsScreen]. Reuses
/// the same pill sub-nav pattern rather than a second [TabBar] widget, so
/// there's one navigation idiom across the whole Reports feature.
class InventoryReportsScreen extends StatefulWidget {
  const InventoryReportsScreen({super.key});

  @override
  State<InventoryReportsScreen> createState() => _InventoryReportsScreenState();
}

class _InventoryReportsScreenState extends State<InventoryReportsScreen> {
  int _index = 0;

  static const _labels = ['Valuation', 'Low Stock', 'Out of Stock', 'Stock Movement'];

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
                create: (_) => InventoryValuationCubit(getIt<InventoryValuationRepository>()),
                child: const InventoryValuationScreen(),
              ),
              BlocProvider(
                create: (_) => LowStockCubit(getIt<LowStockRepository>()),
                child: const LowStockScreen(),
              ),
              BlocProvider(
                create: (_) => OutOfStockCubit(getIt<OutOfStockRepository>()),
                child: const OutOfStockScreen(),
              ),
              BlocProvider(
                create: (_) => StockMovementCubit(getIt<StockMovementRepository>()),
                child: const StockMovementScreen(),
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
