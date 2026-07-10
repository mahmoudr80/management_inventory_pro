import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class DraftStatus extends StatelessWidget {
  final bool isSaved;

  const DraftStatus({super.key, required this.isSaved});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: context.colors.outlineVariant),
          ),
          child: Text(
            'Ctrl+S',
            style: AppTextStyles.labelCaps,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Tooltip(
            message: isSaved ? 'Draft Saved' : 'Unsaved changes',
            child: Text(
              isSaved ? 'Draft Saved' : 'Unsaved changes',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm.copyWith(
                color: isSaved ? context.colors.success : context.colors.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}