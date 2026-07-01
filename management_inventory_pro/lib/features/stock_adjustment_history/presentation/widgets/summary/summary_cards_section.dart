import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../data/models/adjustment_history_kpis.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import 'summary_card.dart';

/// Five KPI cards summarizing the full (unfiltered) adjustment dataset.
class SummaryCardsSection extends StatelessWidget {
  const SummaryCardsSection({super.key});

  static final _intFormat = NumberFormat('#,##0');
  static final _decimalFormat = NumberFormat('#,##0.0');

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StockAdjustmentHistoryCubit,
        StockAdjustmentHistoryState, AdjustmentHistoryKpis>(
      selector: (state) => state.kpis,
      builder: (context, kpis) {
        final isValueNegative = kpis.inventoryValueImpact < 0;

        return Row(
          children: [
            Expanded(
              child: SummaryCard(
                label: 'Total Adjustments',
                value: _intFormat.format(kpis.totalAdjustments),
                trendPct: kpis.totalAdjustmentsTrendPct,
                caption: 'Vs last 30 days',
              ),
            ),
            SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: SummaryCard(
                label: 'Products Adjusted',
                value: _intFormat.format(kpis.productsAdjusted),
                trendPct: kpis.productsAdjustedTrendPct,
                caption: 'Unique SKU impacts',
              ),
            ),
            SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: SummaryCard(
                label: 'Net Quantity Change',
                value:
                    '${kpis.netQuantityChange >= 0 ? '+' : ''}${_intFormat.format(kpis.netQuantityChange)}',
                unit: 'Units',
                valueColor: AppColors.primary,
                caption: 'Inbound net flow',
              ),
            ),
            SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: SummaryCard(
                label: 'Inventory Value Impact',
                value:
                    '${isValueNegative ? '-' : ''}${_intFormat.format(kpis.inventoryValueImpact.abs())}',
                unit: 'EGP',
                valueColor: isValueNegative ? AppColors.error : AppColors.primary,
                caption: 'Total valuation delta',
              ),
            ),
            SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: SummaryCard(
                label: 'Average Adjustment Size',
                value: _decimalFormat.format(kpis.avgAdjustmentSize),
                unit: 'Products',
                caption: 'Per transaction avg',
              ),
            ),
          ],
        );
      },
    );
  }
}
