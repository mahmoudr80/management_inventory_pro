import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class FooterRow extends StatelessWidget {
  final bool isLoading;
  final int loadedCount;
  final int totalCount;
  final VoidCallback onLoadMore;

  const FooterRow({super.key,
    required this.isLoading,
    required this.loadedCount,
    required this.totalCount,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      color: AppColors.surfaceContainerLow,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text(
            'Showing $loadedCount of $totalCount receipts',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
          ),
          const Spacer(),
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          else
            TextButton(
              onPressed: onLoadMore,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
                textStyle: AppTextStyles.bodySm
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              child: const Text('Load more'),
            ),
        ],
      ),
    );
  }
}