import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../data/models/adjustment_model.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import '../summary/adjustment_summary_card.dart';
import 'adjustment_products_table.dart';
import 'detail_footer_actions.dart';
import 'details_empty_state.dart';
import 'details_header.dart';

/// Right-hand detail panel.
///
/// NOTE: this file previously existed in two conflicting copies (one with
/// imports resolving against `widgets/details/`, one assuming a different
/// folder). Keep only this copy — the other one also had a layout bug
/// where the empty state wasn't wrapped in the same bordered container,
/// causing the panel to visibly change shape the moment a row is selected.
class AdjustmentDetailsSection extends StatefulWidget {
  const AdjustmentDetailsSection({super.key});

  @override
  State<AdjustmentDetailsSection> createState() =>
      _AdjustmentDetailsSectionState();
}

class _AdjustmentDetailsSectionState extends State<AdjustmentDetailsSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The bordered/colored container always wraps the content — including
    // the empty state — so the panel's frame doesn't visibly change shape
    // the moment a row gets selected.
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          left: BorderSide(color: AppColors.outlineVariant, width: AppBorder.thin),
        ),
      ),
      child: BlocSelector<
          StockAdjustmentHistoryCubit,
          StockAdjustmentHistoryState,
          AdjustmentModel?>(
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
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdjustmentProductsTable(
                          key: ValueKey(adjustment.id),
                          products: adjustment.products,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AdjustmentSummaryCard(
                          summary: adjustment.summary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              DetailFooterActions(
                status: adjustment.status,
                onPrint: () => _showMessage(
                  context,
                  'Printing adjustment (mock).',
                ),
                onExportPdf: () => _showMessage(
                  context,
                  'Exporting PDF (mock).',
                ),
                onContinueEditing: () => _showMessage(
                  context,
                  'Opening draft for editing (mock).',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
