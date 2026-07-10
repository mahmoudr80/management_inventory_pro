import 'package:flutter/material.dart';
import '../theme/app_theme_extension.dart';
import '../theme/app_decoration.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final String? title;
  final Widget? titleSuffix;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.titleSuffix,
    this.padding,
    this.backgroundColor,
    this.border,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        decoration: widget.border != null
            ? BoxDecoration(
          color: widget.backgroundColor ?? context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: widget.border,
        )
            : AppDecorations.card(
          color: widget.backgroundColor ?? context.colors.surface,
          radius: AppRadius.md,
          borderColor: isHovered ? context.colors.primary : context.colors.border,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null || widget.titleSuffix != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xs,
                  AppSpacing.md,
                  AppSpacing.xs,
                  AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.title != null)
                      Expanded(
                        child: Tooltip(
                          message: widget.title!,
                          child: Text(
                            widget.title!,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headlineSm.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (widget.titleSuffix != null) widget.titleSuffix!,
                  ],
                ),
              ),
              Divider(color: context.colors.border, height: 1.0),
            ],
            Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.lg,
                  ),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}