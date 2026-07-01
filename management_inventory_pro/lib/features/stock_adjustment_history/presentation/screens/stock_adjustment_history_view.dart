
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../cubit/stock_adjustment_history_cubit.dart';
import '../cubit/stock_adjustment_history_state.dart';
import '../widgets/details/adjustment_details_section.dart';
import '../widgets/summary/summary_cards_section.dart';
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

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.marginDesktop,
                    24.h,
                    AppSpacing.marginDesktop,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HistoryHeader(),
                      if (state.selectedAdjustment == null) ...[
                        SizedBox(height: 12.h),
                        const SummaryCardsSection(),
                      ],
                      SizedBox(height: 4.h),
                      const FiltersSection(),
                      SizedBox(height: 4.h),
                      const Expanded(child: AdjustmentTableSection()),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
              state.selectedAdjustment!=null?Expanded(
                flex: 3,
                child: AdjustmentDetailsSection(),)
                  :SizedBox.shrink()


            ],
          );
        },
      ),
    );
  }
}
