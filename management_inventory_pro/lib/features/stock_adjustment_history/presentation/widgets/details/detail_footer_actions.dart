import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_status.dart';

class DetailFooterActions extends StatelessWidget {
  const DetailFooterActions({
    super.key,
    required this.status,
    required this.onPrint,
    required this.onExportPdf,
    required this.onContinueEditing,
  });

  final AdjustmentStatus status;
  final VoidCallback onPrint;
  final VoidCallback onExportPdf;
  final VoidCallback onContinueEditing;

  @override
  Widget build(BuildContext context) {
    final isDraft = status == AdjustmentStatus.draft;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: context.colors.outlineVariant, width: AppBorder.thin)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _OutlinedFooterButton(
                  icon: Icons.print_outlined,
                  label: 'Print',
                  onPressed: onPrint,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _OutlinedFooterButton(
                  icon: Icons.picture_as_pdf_outlined,
                  label: 'Export PDF',
                  onPressed: onExportPdf,
                ),
              ),
            ],
          ),
          if (isDraft) ...[
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinueEditing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primaryContainer,
                  foregroundColor: context.colors.onPrimaryContainer,
                  elevation: 0,
                  side: BorderSide(color: context.colors.primary, width: AppBorder.thin),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  'Continue Editing',
                  style: AppTextStyles.bodySm.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OutlinedFooterButton extends StatelessWidget {
  const _OutlinedFooterButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppIconSize.sm),
      label: Text(
        overflow: TextOverflow.ellipsis,
        label,
        style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w700),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.colors.onSurface,
        side: BorderSide(color: context.colors.outline, width: AppBorder.thin),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}