import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppLogo extends StatelessWidget {
  final double? size;
  final bool showText;

  const AppLogo({super.key, this.size, this.showText = true});

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 120;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(logoSize / 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.inventory_2_rounded,
            color: AppColors.surface,
            size: logoSize * 0.6,
          ),
        ),
        if (showText) ...[
          SizedBox(height: 16),
          Text(
            'OmniStock',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.primaryDark,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
