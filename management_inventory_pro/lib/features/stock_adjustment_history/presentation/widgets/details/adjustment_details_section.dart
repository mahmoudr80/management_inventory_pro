import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../data/models/adjustment_model.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import '../summary/adjustment_summary_card.dart';
import 'adjustment_products_table.dart';
import 'detail_footer_actions.dart';
import 'details_empty_state.dart';
import 'details_header.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        border: Border(
          left: BorderSide(
            color: context.colors.outlineVariant,
            width: AppBorder.thin,
          ),
        ),
      ),
      child:
          BlocSelector<
            StockAdjustmentHistoryCubit,
            StockAdjustmentHistoryState,
            AdjustmentModel?
          >(
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
                            AdjustmentSummaryCard(summary: adjustment.summary),
                          ],
                        ),
                      ),
                    ),
                  ),

                  DetailFooterActions(
                    status: adjustment.status,
                    onPrint: () =>
                        _showMessage(context, 'Printing adjustment (mock).'),
                    onExportPdf: () =>
                        _showMessage(context, 'Exporting PDF (mock).'),
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
      SnackBar(content: Text(message, overflow: TextOverflow.ellipsis)),
    );
  }
}
