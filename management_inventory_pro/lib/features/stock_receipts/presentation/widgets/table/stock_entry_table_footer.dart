import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';

class FooterRow extends StatelessWidget {
  final bool isLoading;
  final int loadedCount;
  final int totalCount;
  final VoidCallback onLoadMore;

  const FooterRow({
    super.key,
    required this.isLoading,
    required this.loadedCount,
    required this.totalCount,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: context.colors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Showing $loadedCount of $totalCount receipts',
            style: AppTextStyles.bodySm.copyWith(color: context.colors.outline),
          ),
          const Spacer(),
          if (isLoading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.primary,
              ),
            )
          else
            TextButton(
              onPressed: onLoadMore,
              style: TextButton.styleFrom(
                foregroundColor: context.colors.primary,
                visualDensity: VisualDensity.compact,
                textStyle: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
              ),
              child: const Text('Load more'),
            ),
        ],
      ),
    );
  }
}