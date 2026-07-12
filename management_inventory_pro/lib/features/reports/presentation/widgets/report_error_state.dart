import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Phase 3 addition. Sections 1-3 gave every `BaseReportState<T>` an
/// `isError`/`errorMessage`, but no report screen actually rendered it —
/// `BlocBuilder`s only ever branched on `isLoading` / rows.isEmpty. This
/// is the missing third state, styled to match [ReportEmptyState] /
/// [ReportLoadingState] so the three read as one family rather than one
/// being an afterthought.
class ReportErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ReportErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 40, color: context.colors.error),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySm.copyWith(color: context.colors.textSecondary),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: AppIconSize.sm),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.error,
                side: BorderSide(color: context.colors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
