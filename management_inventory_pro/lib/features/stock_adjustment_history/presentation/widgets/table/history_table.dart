import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/adjustment_model.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import 'adjustment_row.dart';
import 'history_table_header.dart';

typedef _RowsViewModel = ({
  List<AdjustmentModel> adjustments,
  String? selectedId,
});

/// Renders the sticky header plus the scrollable, selectable list of
/// filtered adjustment rows. Uses `BlocSelector` to limit rebuilds to
/// just the filtered list + selected id.
class HistoryTable extends StatelessWidget {
  const HistoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const HistoryTableHeader(),
          Expanded(
            child: BlocSelector<StockAdjustmentHistoryCubit,
                StockAdjustmentHistoryState, _RowsViewModel>(
              selector: (state) => (
                adjustments: state.filteredAdjustments,
                selectedId: state.selectedAdjustment?.id,
              ),
              builder: (context, data) {
                if (data.adjustments.isEmpty) {
                  return const _EmptyResults();
                }
                return ListView.builder(
                  itemCount: data.adjustments.length,
                  itemBuilder: (context, index) {
                    final adjustment = data.adjustments[index];
                    return AdjustmentRow(
                      adjustment: adjustment,
                      isSelected: adjustment.id == data.selectedId,
                      onTap: () => context
                          .read<StockAdjustmentHistoryCubit>()
                          .selectAdjustment(adjustment),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No adjustments match the current filters.',
        style: TextStyle(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}
