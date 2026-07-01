import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/mock_stock_adjustment_history_repository.dart';
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
        MockStockAdjustmentHistoryRepository(),
      )..loadAdjustments(),
      child: const StockAdjustmentHistoryView(),
    );
  }
}

