import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../cubit/stock_adjustment_history_cubit.dart';
import '../cubit/stock_adjustment_history_state.dart';
import '../widgets/summary/adjustment_details_section.dart';
import '../widgets/table/adjustment_table_section.dart';
import '../widgets/filters/filters_section.dart';
import '../widgets/header/history_header.dart';
import 'history_error_state.dart';

class StockAdjustmentHistoryView extends StatelessWidget {
  const StockAdjustmentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: BlocBuilder<StockAdjustmentHistoryCubit,
          StockAdjustmentHistoryState>(
        buildWhen: (previous, current) => previous.status != current.status
            ||   previous.selectedAdjustment != current.selectedAdjustment,
        builder: (context, state) {
          if (state.status == StockAdjustmentHistoryStatus.loading ||
              state.status == StockAdjustmentHistoryStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == StockAdjustmentHistoryStatus.error) {
            return ErrorState(
              message: state.error ?? 'Something went wrong.',
              onRetry: () => context
                  .read<StockAdjustmentHistoryCubit>()
                  .loadAdjustments(),
            );
          }

          final hasSelection = state.selectedAdjustment != null;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // flex 10 (full width) with nothing selected, flex 7 once the
              // right panel appears — so the list visibly expands/contracts
              // rather than leaving empty space where the panel would be.
              Expanded(
                flex: hasSelection ? 7 : 10,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.pagePadding,
                    AppSpacing.xl,
                    AppSpacing.pagePadding,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HistoryHeader(),
                      // Filters (and, once wired up, the KPI summary row)
                      // are page-level chrome — they must not depend on
                      // whether a row is selected, so they're unconditional
                      // here rather than gated on state.selectedAdjustment.
                      const SizedBox(height: AppSpacing.xs),
                      const FiltersSection(),
                      const SizedBox(height: AppSpacing.xs),
                      const Expanded(child: AdjustmentTableSection()),
                      const SizedBox(height: AppSpacing.xxs),
                    ],
                  ),
                ),
              ),
              // Only mounted once a row is selected — AdjustmentDetailsSection
              // still has its own internal empty-state handling, but we don't
              // want that empty state ("Select an adjustment...") taking up
              // 30% of the screen when nothing's picked, so we skip mounting
              // it entirely here instead.
              if (hasSelection)
                const Expanded(
                  flex: 3,
                  child: AdjustmentDetailsSection(),
                ),
            ],
          );
        },
      ),
    );
  }
}
