import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme_extension.dart';
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
        hoverColor: context.colors.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            Icons.delete_outline,
            size: AppIconSize.lg,
            color: context.colors.outline,
          ),
        ),
      ),
    );
  }
}