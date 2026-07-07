import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Static (mock) pagination footer. Per spec, real pagination wiring is
/// out of scope for this audit screen.
class PaginationWidget extends StatelessWidget {
  const PaginationWidget({
    super.key,
    required this.totalCount,
    this.pageSize = 10,
    this.currentPage = 1,
  });

  final int totalCount;
  final int pageSize;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final start = totalCount == 0 ? 0 : ((currentPage - 1) * pageSize) + 1;
    final end = (currentPage * pageSize).clamp(0, totalCount);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $start-$end of $totalCount results',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              _PageButton(icon: Icons.chevron_left, onTap: () {}),
              SizedBox(width: AppSpacing.xxs),
              _PageNumber(label: '$currentPage', isActive: true),
              SizedBox(width: AppSpacing.xxs),
              _PageButton(icon: Icons.chevron_right, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.standard),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(AppRadius.standard),
        ),
        child: Icon(icon, size: AppIconSize.sm, color: AppColors.onSurfaceVariant),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.standard),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySm.copyWith(
          color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
