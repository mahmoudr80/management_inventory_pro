import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_model.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import 'adjustment_row.dart';
import 'history_table_header.dart';

typedef _RowsViewModel = ({
  List<AdjustmentModel> adjustments,
  String? selectedId,
});

class HistoryTable extends StatefulWidget {
  const HistoryTable({super.key});

  @override
  State<HistoryTable> createState() => _HistoryTableState();
}

class _HistoryTableState extends State<HistoryTable> {
  static const double _minTableWidth = AppBreakpoints.compact;

  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        border: Border.all(
          color: context.colors.outlineVariant,
          width: AppBorder.thin,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = max(_minTableWidth, constraints.maxWidth);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              height: constraints.maxHeight,
              child: Column(
                children: [
                  const HistoryTableHeader(),
                  Divider(
                    height: AppBorder.thin,
                    color: context.colors.outlineVariant,
                  ),
                  Expanded(
                    child:
                        BlocSelector<
                          StockAdjustmentHistoryCubit,
                          StockAdjustmentHistoryState,
                          _RowsViewModel
                        >(
                          selector: (state) => (
                            adjustments: state.filteredAdjustments,
                            selectedId: state.selectedAdjustment?.id,
                          ),
                          builder: (context, data) {
                            if (data.adjustments.isEmpty) {
                              return const _EmptyResults();
                            }

                            return Scrollbar(
                              controller: _verticalController,
                              thumbVisibility: true,
                              child: ListView.builder(
                                controller: _verticalController,
                                itemCount: data.adjustments.length,
                                itemBuilder: (context, index) {
                                  final adjustment = data.adjustments[index];

                                  return AdjustmentRow(
                                    adjustment: adjustment,
                                    isSelected:
                                        adjustment.id == data.selectedId,
                                    onTap: () => context
                                        .read<StockAdjustmentHistoryCubit>()
                                        .selectAdjustment(adjustment),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
          );
        },
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
        style: AppTextStyles.bodyMd.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
