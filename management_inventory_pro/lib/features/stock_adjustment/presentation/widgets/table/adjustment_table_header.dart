import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';

class AdjustmentTableHeader extends StatelessWidget {
  const AdjustmentTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: AppSpacing.sm),
          const _HeaderCell('#', flex: 0, width: 24),
          const _HeaderCell('Product Details', flex: 2),
          const _HeaderCell('Current', flex: 1),
          const _HeaderCell('Adjustment', flex: 1),
          const _HeaderCell('New Level', flex: 1),
          const _HeaderCell('Value Impact', flex: 1),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final double? width;
  final TextAlign textAlign;

  const _HeaderCell(
    this.label, {
    required this.flex,
    this.width,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.labelCaps,
    );

    if (width != null) {
      return SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: text,
        ),
      );
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: text,
      ),
    );
  }
}
