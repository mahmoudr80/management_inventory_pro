import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/dependency_injection/service_locator.dart';
import 'package:management_inventory_pro/features/stock_adjustment_history/data/datasource/stock_adjustment_history_datasource.dart';
import '../../data/repositories/stock_adjustment_history_repository.dart';
import '../cubit/stock_adjustment_history_cubit.dart';
import 'stock_adjustment_history_view.dart';

/// Stock Adjustment History — audit screen only (no creation flow).
///
/// Body content only: the app shell provides the sidebar / top nav. Layout
/// is a 70/30 desktop split — adjustment list on the left, live-updating
/// detail panel on the right.
class StockAdjustmentHistory extends StatelessWidget {
  const StockAdjustmentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StockAdjustmentHistoryCubit(
        StockAdjustmentHistoryRepository(getIt<StockAdjustmentHistoryDatasource>()),
      )..loadAdjustments(),
      child: const StockAdjustmentHistoryView(),
    );
  }
}

