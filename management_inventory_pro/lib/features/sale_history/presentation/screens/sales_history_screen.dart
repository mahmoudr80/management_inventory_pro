import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/dependency_injection/service_locator.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/features/sale_history/data/repository/sale_history_repository.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/states/empty_sale_state.dart';
import '../../../home/cubit/home_cubit.dart';
import '../cubit/sales_history_cubit.dart';
import '../widgets/states/error_sale_state.dart';
import '../widgets/states/sale_loaded_body.dart';
import '../widgets/sale_page_header.dart';
import '../widgets/states/loading_sale_state.dart';


class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Page Header ─────────────────────────────────────────────
          const SalePageHeader(),
          const SizedBox(height: AppSpacing.lg),

          // ── Content ─────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
              builder: (context, state) {
                return switch (state) {
                  SalesHistoryInitial() => const SalesLoadingState(),
                  SalesHistoryLoading() => const SalesLoadingState(),
                  SalesHistoryError(:final message) =>
                      SaleErrorState(message: message),
                  SalesHistoryLoaded() =>
                  state.filteredSales.isEmpty
                      ? SaleEmptyBody(
                    filters: state.filters,
                  )
                      : SaleLoadedBody(state: state),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

