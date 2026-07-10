import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';

class DateRangeButton extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String Function(DateTimeRange) formatDateRange;

  const DateRangeButton({
    super.key,
    required this.selectedRange,
    required this.onTap,
    required this.onClear,
    required this.formatDateRange,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selectedRange != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? context.colors.primaryFixed : context.colors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive ? context.colors.primary : context.colors.outline,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color: isActive
                  ? context.colors.onPrimaryFixedVariant
                  : context.colors.outline,
            ),
            const SizedBox(width: 2),
            Text(overflow: TextOverflow.ellipsis,
              isActive ? formatDateRange(selectedRange!) : 'Date range',
              style: AppTextStyles.bodySm.copyWith(
                color: isActive
                    ? context.colors.onPrimaryFixedVariant
                    : context.colors.onSurfaceVariant,
              ),
            ),
            if (isActive && onClear != null) ...[
              const SizedBox(width: 2),
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: context.colors.onPrimaryFixedVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}