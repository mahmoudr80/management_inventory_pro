import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class StockEntryHeader extends StatelessWidget {
  const StockEntryHeader({
    super.key,
    required this.isEditMode,
    required this.receiptId,
  });

  final bool isEditMode;
  final String receiptId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 600;

        final headerText = Text(
          isEditMode ? 'Edit Stock Receipt' : 'New Stock Receipt',
          style: AppTextStyles.display,
        );

        final badge = receiptId.isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'RECEIPT ID: ',
                      style: AppTextStyles.labelCaps,
                    ),
                    Tooltip(
                      message: receiptId,
                      child: Text(
                        receiptId,
                        style: AppTextStyles.dataMono.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink();

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerText,
              if (receiptId.isNotEmpty) ...[
                const SizedBox(height: 12),
                badge,
              ],
            ],
          );
        }

        return Row(
          children: [
            headerText,
            const Spacer(),
            badge,
          ],
        );
      },
    );
  }
}
