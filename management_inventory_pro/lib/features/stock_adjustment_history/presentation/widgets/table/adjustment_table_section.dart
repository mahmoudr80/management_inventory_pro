import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import 'history_table.dart';
import 'pagination_widget.dart';

/// Combines the scrollable [HistoryTable] with the mock [PaginationWidget]
/// footer below it.
class AdjustmentTableSection extends StatelessWidget {
  const AdjustmentTableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Expanded(child: HistoryTable() ),
        BlocSelector<StockAdjustmentHistoryCubit, StockAdjustmentHistoryState,
            int>(
          selector: (state) => state.filteredAdjustments.length,
          builder: (context, count) => PaginationWidget(totalCount: count),
        ),
      ],
    );
  }
}
