import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

import '../buttons/reset_button.dart';
import '../buttons/save_button.dart';

/// Page title + subtitle on the left, Save/Reset actions on the right.
/// Wraps to a column on narrower desktop widths so the buttons never push
/// the title off-screen.
class PageHeaderSection extends StatelessWidget {
  final bool hasUnsavedChanges;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onReset;

  const PageHeaderSection({
    super.key,
    required this.hasUnsavedChanges,
    required this.isSaving,
    required this.onSave,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 640;

        final titleBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Settings', style: AppTextStyles.display),
            SizedBox(height: AppSpacing.xxs),
            Text('Configure Inventory Pro for your business.', style: AppTextStyles.bodyMd),
          ],
        );

        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResetButton(onConfirm: onReset),
            SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 160,
              child: SaveButton(
                enabled: hasUnsavedChanges,
                isSaving: isSaving,
                onPressed: onSave,
              ),
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock,
              SizedBox(height: AppSpacing.lg),
              actions,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleBlock),
            actions,
          ],
        );
      },
    );
  }
}
