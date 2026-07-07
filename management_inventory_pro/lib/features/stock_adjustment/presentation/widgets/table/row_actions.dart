import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';

class RowActions extends StatelessWidget {
  final VoidCallback onDelete;

  const RowActions({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Remove row (Del)',
      child: InkWell(
        onTap: onDelete,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        hoverColor: AppColors.errorContainer,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            Icons.delete_outline,
            size: AppIconSize.lg,
            color: AppColors.outline,
          ),
        ),
      ),
    );
  }
}
