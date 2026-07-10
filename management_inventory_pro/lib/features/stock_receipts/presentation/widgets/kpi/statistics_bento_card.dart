import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_decoration.dart';
import '../../../../../core/theme/app_text_styles.dart';

class StatBentoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final Widget? badge;
  final String? footer;
  final IconData? decorativeIcon;
  final Widget? customFooter;

  const StatBentoCard({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.badge,
    this.footer,
    this.decorativeIcon,
    this.customFooter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.card(),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Tooltip(
                message: title,
                child: Text(
                  title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelCaps,
                ),
              ),
              const SizedBox(height: 8),
              Tooltip(
                message: value,
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.display.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              if (badge != null) ...[
                const SizedBox(height: 16),
                badge!,
              ],
              if (footer != null) ...[
                const SizedBox(height: 8),
                Tooltip(
                  message: footer!,
                  child: Text(
                    footer!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
              if (customFooter != null) ...[
                const SizedBox(height: 8),
                customFooter!,
              ],
            ],
          ),
          if (decorativeIcon != null)
            Positioned(
              bottom: -16,
              right: -16,
              child: Icon(
                decorativeIcon,
                size: 96,
                color: context.colors.onSurface.withOpacity(0.06),
              ),
            ),
        ],
      ),
    );
  }
}