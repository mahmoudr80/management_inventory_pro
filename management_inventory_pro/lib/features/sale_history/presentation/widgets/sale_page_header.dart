import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/components/page_header.dart';
import '../cubit/sales_history_cubit.dart';

class SalePageHeader extends StatelessWidget {
  const SalePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();
    return PageHeader(title: 'Sales History',subtitle: 'Review and manage completed sales transactions',
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Export – coming soon'),
                  duration: Duration(seconds: 2)),
            );
          },
          icon: const Icon(Icons.file_upload_outlined, size: AppIconSize.md),
          label: Text('Export', style: AppTextStyles.buttonText.copyWith(color: AppColors.textSecondary)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.border),
            backgroundColor: AppColors.surface,
            padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: cubit.refresh,
          icon: const Icon(Icons.refresh_rounded, size: AppIconSize.md),
          label: Text('Refresh', style: AppTextStyles.buttonText),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        )
      ],);
  }
}
