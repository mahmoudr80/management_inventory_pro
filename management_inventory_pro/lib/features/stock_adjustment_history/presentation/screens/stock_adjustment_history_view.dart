import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme_extension.dart';
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
      color: context.colors.surface,
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
                      const SizedBox(height: AppSpacing.xs),
                      const FiltersSection(),
                      const SizedBox(height: AppSpacing.xs),
                      const Expanded(child: AdjustmentTableSection()),
                      const SizedBox(height: AppSpacing.xxs),
                    ],
                  ),
                ),
              ),
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