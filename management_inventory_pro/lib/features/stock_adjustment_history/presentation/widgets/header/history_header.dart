import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/widgets/primary_button.dart';
import 'package:management_inventory_pro/core/widgets/secondary_button.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';

/// Title, subtitle, and Refresh / Export / Create Adjustment actions.
class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHeader(title: 'Stock Adjustment History',subtitle: 'Review inventory corrections and audit stock adjustments across all warehouses.',
    actions: [
      SecondaryButton(
        icon: Icons.refresh,
        text: 'Refresh',
        onPressed: () =>
            context.read<StockAdjustmentHistoryCubit>().refresh(),
      ),
      SecondaryButton(
        icon: Icons.file_download_outlined,
        text: 'Export',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export started (mock).')),
          );
        },
      ),
      PrimaryButton(text: 'Create Adjustment', onPressed: () {
        // Navigation into the Stock Adjustment creation screen is
        // owned by the app shell / router, not this audit screen.
      },  icon: Icons.add,)

    ],);

  }
}
