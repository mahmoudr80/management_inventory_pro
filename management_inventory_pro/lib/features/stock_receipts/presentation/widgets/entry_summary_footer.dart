import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EntrySummaryFooter extends StatelessWidget {
  final int totalItems;
  final double subtotal;
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const EntrySummaryFooter({
    super.key,
    required this.totalItems,
    required this.subtotal,
    required this.isLoading,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isNarrow = constraints.maxWidth < 600;

          final chips = [
            _SummaryChip(
              label: 'ITEMS',
              value: totalItems.toString(),
            ),
            _SummaryChip(
              label: 'SUBTOTAL',
              value: '\$${subtotal.toStringAsFixed(2)}',
              valueMono: true,
            ),
          ];

          final buttons = [
            OutlinedButton(
              onPressed: isLoading ? null : onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurfaceVariant,
                side: const BorderSide(color: AppColors.outlineVariant),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Cancel', style: AppTextStyles.bodyMd),
            ),
            ElevatedButton.icon(
              onPressed: isLoading ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : const Icon(Icons.save_outlined, size: 18),
              label: Text(
                isLoading ? 'Saving…' : 'Save & Update Stock',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ];

          if (isNarrow) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: chips[0]),
                    const SizedBox(width: 12),
                    Expanded(child: chips[1]),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: buttons[0]),
                    const SizedBox(width: 12),
                    Expanded(child: buttons[1]),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              chips[0],
              const SizedBox(width: 16),
              chips[1],
              const Spacer(),
              buttons[0],
              const SizedBox(width: 12),
              buttons[1],
            ],
          );
        },
      ),
    );
  }
}

// ── Summary Chip ──────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final bool valueMono;

  const _SummaryChip({
    required this.label,
    required this.value,
    this.valueMono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.labelCaps),
          const SizedBox(height: 2),
          Text(
            value,
            style: valueMono
                ? AppTextStyles.dataMono.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                  )
                : AppTextStyles.headlineSm,
          ),
        ],
      ),
    );
  }
}
