import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_model.dart';
import '../table/status_chip.dart';

/// Top section of the right detail panel: adjustment id, status, created
/// date, and the reason / created-by info chips.
class DetailsHeader extends StatelessWidget {
  const DetailsHeader({
    super.key,
    required this.adjustment,
    required this.onClose,
  });

  final AdjustmentModel adjustment;
  final VoidCallback onClose;

  static final _dateFormat = DateFormat('d MMM, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant, width: AppBorder.thin)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Tooltip(message: 'Adjustment Details', child: Text(
                  'Adjustment Details', overflow: TextOverflow.ellipsis, style: AppTextStyles.headlineSm))),
              IconButton(
                onPressed: onClose,
                icon: Icon(Icons.close, size: AppIconSize.lg, color: AppColors.onSurfaceVariant),
                splashRadius: AppSpacing.xl,
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: adjustment.id,
                      child: Text(
                        adjustment.id,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.dataMono.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Tooltip(
                      message: 'Created on ${_dateFormat.format(adjustment.dateTime)}',
                      child: Text(
                        'Created on ${_dateFormat.format(adjustment.dateTime)}',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(status: adjustment.status),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Reason',
                  icon: adjustment.reason.icon,
                  iconColor: adjustment.reason.color,
                  value: adjustment.reason.label,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _InfoTile(
                  label: 'Created By',
                  icon: Icons.person_outline,
                  iconColor: AppColors.onSurfaceVariant,
                  value: adjustment.createdBy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border.all(color: AppColors.outlineVariant, width: AppBorder.thin),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message: label.toUpperCase(),
            child: Text(
              label.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelCaps,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(icon, size: AppIconSize.md, color: iconColor),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Tooltip(
                  message: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
