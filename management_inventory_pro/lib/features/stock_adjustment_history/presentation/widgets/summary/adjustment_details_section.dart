import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../data/models/adjustment_model.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import '../details/adjustment_products_table.dart';
import '../details/detail_footer_actions.dart';
import '../details/details_empty_state.dart';
import '../details/details_header.dart';
import '../summary/adjustment_summary_card.dart';

class AdjustmentDetailsSection extends StatefulWidget {
  const AdjustmentDetailsSection({super.key});

  @override
  State<AdjustmentDetailsSection> createState() =>
      _AdjustmentDetailsSectionState();
}

class _AdjustmentDetailsSectionState
    extends State<AdjustmentDetailsSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        StockAdjustmentHistoryCubit,
        StockAdjustmentHistoryState,
        AdjustmentModel?>(
      selector: (state) => state.selectedAdjustment,
      builder: (context, adjustment) {
        if (adjustment == null) {
          return const DetailsEmptyState();
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            border: Border(
              left: BorderSide(
                color: AppColors.outlineVariant,
                width: AppBorder.thin,
              ),
            ),
          ),
          child: Column(
            children: [
              DetailsHeader(
                adjustment: adjustment,
                onClose: context
                    .read<StockAdjustmentHistoryCubit>()
                    .clearSelection,
              ),

              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.lg,
                    ),
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

              DetailFooterActions(
                status: adjustment.status,
                onPrint: () => _showSnackBar(
                  context,
                  'Printing adjustment (mock).',
                ),
                onExportPdf: () => _showSnackBar(
                  context,
                  'Exporting PDF (mock).',
                ),
                onContinueEditing: () => _showSnackBar(
                  context,
                  'Opening draft for editing (mock).',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
