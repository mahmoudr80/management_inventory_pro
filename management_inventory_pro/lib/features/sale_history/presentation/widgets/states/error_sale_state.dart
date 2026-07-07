import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

import '../../cubit/sales_history_cubit.dart';

class SaleErrorState extends StatelessWidget {
  const SaleErrorState({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();

    // error_sale_state.dart
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline_rounded,
                  size: AppIconSize.xl, color: AppColors.error),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Something went wrong',
              style: AppTextStyles.headlineSm.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Tooltip(
              message: message,
              child: Text(
                message,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: cubit.loadSales,
              icon: Icon(Icons.refresh_rounded, size: AppIconSize.sm),
              label: Text('Try Again', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onPrimary)),
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
      ),
    );

  }
}
