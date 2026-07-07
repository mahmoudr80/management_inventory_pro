import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../cubit/stock_adjustment_cubit.dart';
import '../../cubit/stock_adjustment_state.dart';
import '../common/empty_state.dart';
import 'adjustment_row.dart';
import 'adjustment_table_header.dart';

class AdjustmentTable extends StatefulWidget {
  const AdjustmentTable({super.key});

  // Minimum width needed for every column to stay legible. Below this,
  // the table scrolls horizontally instead of squeezing its columns,
  // per the responsive rules for tables that may exceed small windows.
  static const double _minTableWidth = 760;

  @override
  State<AdjustmentTable> createState() => _AdjustmentTableState();
}

class _AdjustmentTableState extends State<AdjustmentTable> {
  // Explicit controller so the Scrollbar isn't left to fall back on the
  // PrimaryScrollController, which isn't attached to this horizontal
  // SingleChildScrollView and throws "no ScrollPosition attached".
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockAdjustmentCubit, StockAdjustmentState>(
      builder: (context, state) {
        if (state is! StockAdjustmentLoaded) return const SizedBox.shrink();
        final cubit = context.read<StockAdjustmentCubit>();
        final items = state.adjustment.items;

        final table = Column(
          children: [
            const AdjustmentTableHeader(),
            if (items.isEmpty)
              const SizedBox(
                height: 200,
                child: EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'No products added yet',
                  subtitle: 'Search for products above to add them',
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  return AdjustmentRow(
                    index: i,
                    item: item,
                    isSelected: state.selectedRowId == item.id,
                    onTap: () => cubit.selectRow(item.id),
                    onQtyChanged: (qty) =>
                        cubit.updateAdjustmentQty(item.id, qty),
                    onDelete: () => cubit.removeProduct(item.id),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
              ),
          ],
        );

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < AdjustmentTable._minTableWidth) {
                  return Scrollbar(
                    controller: _horizontalController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: AdjustmentTable._minTableWidth,
                        child: table,
                      ),
                    ),
                  );
                }
                return table;
              },
            ),
          ),
        );
      },
    );
  }
}
