import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_filters_bar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_decoration.dart';
import '../../../../../core/theme/app_dimens.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../cubit/sales_history_cubit.dart';


class SaleEmptyBody extends StatelessWidget {
  const SaleEmptyBody({super.key, required this.filters});
  final ActiveFilters filters;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SalesFiltersBar(filters: filters),
            SizedBox(height: AppSpacing.lg),
            // NOTE: this was `Expanded(...)`. Expanded needs a bounded height
            // from an ancestor, but SingleChildScrollView gives unbounded
            // height along its scroll axis — that combination threw a
            // RenderFlex "unbounded height constraints" assertion the instant
            // filteredSales became empty (i.e. the moment a filter matched
            // nothing), which is what looked like the app "stopping".
            // A plain Container sized by its child fixes it; ConstrainedBox
            // keeps the empty-state card from looking cramped on tall windows.
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 320),
              child: Container(
                decoration: AppDecorations.card(
                  color: AppColors.surface,
                  borderColor: AppColors.border,
                ),
                child: _EmptySalesState(hasFilters: filters.hasActiveFilters),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class _EmptySalesState extends StatelessWidget {
  const _EmptySalesState({super.key, required this.hasFilters});

  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();

    return Center(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasFilters
                      ? Icons.search_off_rounded
                      : Icons.receipt_long_outlined,
                  size: AppIconSize.xl * 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Tooltip(
                message: hasFilters ? 'No sales match your filters' : 'No sales found',
                child: Text(
                  hasFilters ? 'No sales match your filters' : 'No sales found',
                  style: AppTextStyles.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Tooltip(
                message: hasFilters
                    ? 'Try adjusting your search or filter criteria.'
                    : 'Completed sales will appear here once recorded.',
                child: Text(
                  hasFilters
                      ? 'Try adjusting your search or filter criteria.'
                      : 'Completed sales will appear here once recorded.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                alignment: WrapAlignment.center,
                children: [
                  if (hasFilters)
                    OutlinedButton.icon(
                      onPressed: cubit.resetFilters,
                      icon: Icon(Icons.filter_alt_off_rounded, size: AppIconSize.lg),
                      label:
                      Text('Clear Filters', style: AppTextStyles.bodyMd),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: cubit.refresh,
                    icon: Icon(Icons.refresh_rounded, size: AppIconSize.lg),
                    label: Text('Refresh', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onPrimary)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding:
                      EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
