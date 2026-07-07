import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
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
  // Matches the app's minimum supported desktop width (AppBreakpoints.compact)
  // rather than a standalone magic number, so both stay in sync if the
  // breakpoint scale ever changes.
  static const double _minTableWidth = AppBreakpoints.compact;

  // Owned here (rather than created inline inside the builder below) so it
  // survives rebuilds and always has exactly one ScrollPosition attached
  // for the Scrollbar to latch onto. Previously the vertical Scrollbar had
  // no controller and this ListView wasn't the route's primary scrollable
  // (it's nested several levels deep under a horizontal
  // SingleChildScrollView), so nothing ever attached a ScrollPosition to
  // it — the Scrollbar fell back to PrimaryScrollController and crashed
  // with "no ScrollPosition attached" as soon as it tried to paint.
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
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant, width: AppBorder.thin),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = max(_minTableWidth, constraints.maxWidth);

          // Header and rows live inside the SAME horizontal
          // SingleChildScrollView so dragging the table sideways keeps the
          // header columns and row columns locked together. The inner
          // ListView still scrolls vertically on its own, via
          // _verticalController.
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              height: constraints.maxHeight,
              child: Column(
                children: [
                  const HistoryTableHeader(),
                  Divider(height: AppBorder.thin, color: AppColors.outlineVariant),
                  Expanded(
                    child: BlocSelector<
                        StockAdjustmentHistoryCubit,
                        StockAdjustmentHistoryState,
                        _RowsViewModel>(
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
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
