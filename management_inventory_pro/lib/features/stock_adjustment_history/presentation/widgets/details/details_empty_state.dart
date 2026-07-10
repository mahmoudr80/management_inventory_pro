import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';

class DetailsEmptyState extends StatelessWidget {
  const DetailsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fact_check_outlined,
              size: AppIconSize.xl,
              color: context.colors.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              overflow: TextOverflow.ellipsis,
              'Select an adjustment to view its details',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySm.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}