import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../cubit/stock_adjustment_cubit.dart';
import '../../cubit/stock_adjustment_state.dart';
import 'inventory_value_summary.dart';
import 'movement_preview.dart';
import 'summary_card.dart';

class ImpactAnalysisPanel extends StatelessWidget {
  const ImpactAnalysisPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockAdjustmentCubit, StockAdjustmentState>(
      builder: (context, state) {
        if (state is! StockAdjustmentLoaded) return const SizedBox.shrink();
        final adj = state.adjustment;

        // Panel narrows itself on smaller windows instead of using a
        // single fixed width, so it still fits alongside the table
        // down to the 900px minimum supported width.
        final screenWidth = MediaQuery.sizeOf(context).width;
        final panelWidth = screenWidth < AppBreakpoints.medium ? 280.0 : 340.0;

        return Container(
          width: panelWidth,
          decoration: BoxDecoration(
            color: context.colors.background,
            border: Border(left: BorderSide(color: context.colors.outlineVariant)),
          ),
          child: Column(
            children: [
              const _PanelHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          SizedBox(
                            width: (panelWidth - AppSpacing.sm * 3) / 2,
                            child: SummaryCard(
                              label: 'Total Increase',
                              value: '+${adj.totalIncrease} units',
                              valueColor: context.colors.primary,
                            ),
                          ),
                          SizedBox(
                            width: (panelWidth - AppSpacing.sm * 3) / 2,
                            child: SummaryCard(
                              label: 'Total Decrease',
                              value: '${adj.totalDecrease} units',
                              valueColor: context.colors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _NetQtyCard(net: adj.netQtyChange),
                      const SizedBox(height: AppSpacing.md),
                      InventoryValueSummary(adjustment: adj),
                      const SizedBox(height: AppSpacing.xl),
                      MovementPreview(items: adj.items),
                    ],
                  ),
                ),
              ),
              const _PanelFooter(),
            ],
          ),
        );
      },
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(bottom: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(Icons.analytics_outlined,
              size: AppIconSize.lg, color: context.colors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Impact Analysis',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineSm
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Real-time inventory changes',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NetQtyCard extends StatelessWidget {
  final int net;
  const _NetQtyCard({required this.net});

  @override
  Widget build(BuildContext context) {
    final isNeg = net < 0;
    final prefix = net > 0 ? '+' : '';
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('NET QUANTITY CHANGE', style: AppTextStyles.labelCaps),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '$prefix$net units',
                style: AppTextStyles.dataMono.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          Icon(
            isNeg ? Icons.trending_down : Icons.trending_up,
            size: AppIconSize.lg,
            color: isNeg ? context.colors.error : context.colors.primary,
          ),
        ],
      ),
    );
  }
}

class _PanelFooter extends StatelessWidget {
  const _PanelFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        border: Border(top: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline,
              size: AppIconSize.lg, color: context.colors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Tooltip(
              message: 'Adjustments affect COGS and P&L statements.',
              child: Text(
                'Adjustments affect COGS and P&L statements.',
                overflow: TextOverflow.ellipsis,
                style:
                AppTextStyles.bodySm.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}