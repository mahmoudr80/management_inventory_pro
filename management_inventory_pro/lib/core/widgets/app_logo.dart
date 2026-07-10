import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class AppLogo extends StatelessWidget {
  final double? size;
  final bool showText;

  const AppLogo({super.key, this.size, this.showText = true});

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? AppIconSize.xl * 3.75;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: context.colors.primary,
            borderRadius: BorderRadius.circular(logoSize / 4),
            boxShadow: [
              BoxShadow(
                color: context.colors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.inventory_2_rounded,
            color: context.colors.surface,
            size: logoSize * 0.6,
          ),
        ),
        if (showText) ...[
          SizedBox(height: AppSpacing.lg),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: logoSize * 2.5),
            child: Text(
              'OmniStock',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2.copyWith(
                color: context.colors.primaryDark,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}