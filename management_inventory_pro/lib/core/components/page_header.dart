import 'package:flutter/material.dart';
import '../theme/app_theme_extension.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? breadcrumb;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.breadcrumb,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompact = Responsive.isCompact(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (breadcrumb != null) ...[breadcrumb!, const SizedBox(height: AppSpacing.sm)],
        if (isCompact)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: title,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  title,
                  style: AppTextStyles.headlineMd.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Tooltip(
                  message: subtitle!,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    subtitle!,
                    maxLines: 2,
                    style: AppTextStyles.bodySm.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ],
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: actions!,
                ),
              ],
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: title,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        title,
                        style: AppTextStyles.headlineMd.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Tooltip(
                        message: subtitle!,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          subtitle!,
                          maxLines: 2,
                          style: AppTextStyles.bodySm.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.lg),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: actions!,
                ),
              ],
            ],
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}