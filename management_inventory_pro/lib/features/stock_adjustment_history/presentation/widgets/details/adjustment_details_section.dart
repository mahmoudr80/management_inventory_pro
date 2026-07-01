import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/adjustment_model.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import 'adjustment_products_table.dart';
import '../summary/adjustment_summary_card.dart';
import 'detail_footer_actions.dart';
import 'details_empty_state.dart';
import 'details_header.dart';

/// The full right-side detail panel: header, scrollable products table +
/// summary card, and footer actions. Updates instantly when a different
/// row is selected on the left, via `BlocSelector` on `selectedAdjustment`.
class AdjustmentDetailsSection extends StatelessWidget {
  const AdjustmentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(left: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: BlocSelector<StockAdjustmentHistoryCubit,
          StockAdjustmentHistoryState, AdjustmentModel?>(
        selector: (state) => state.selectedAdjustment,
        builder: (context, adjustment) {
          if (adjustment == null) {
            return const DetailsEmptyState();
          }

          final cubit = context.read<StockAdjustmentHistoryCubit>();

          return Column(
            children: [
              DetailsHeader(
                adjustment: adjustment,
                onClose: cubit.clearSelection,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical:  20.h,horizontal: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdjustmentProductsTable(
                        key: ValueKey(adjustment.id),
                        products: adjustment.products,
                      ),
                      SizedBox(height: 16.h),
                      AdjustmentSummaryCard(summary: adjustment.summary),
                    ],
                  ),
                ),
              ),
              DetailFooterActions(
                status: adjustment.status,
                onPrint: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Printing adjustment (mock).')),
                ),
                onExportPdf: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting PDF (mock).')),
                ),
                onContinueEditing: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening draft for editing (mock).')),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
