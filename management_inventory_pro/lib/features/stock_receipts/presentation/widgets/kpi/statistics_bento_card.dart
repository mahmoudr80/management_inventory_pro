import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
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
    return Container(//constraints: BoxConstraints(maxHeight: 150.h),
      padding: const EdgeInsets.all(24),
      decoration:AppDecorations.card() ,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTextStyles.labelCaps,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: AppTextStyles.display.copyWith(
                    color: valueColor ?? AppColors.onBackground,
                    fontSize: 20.sp.clamp(15, 28)
                ),
              ),
              if (badge != null) ...[
                const SizedBox(height: 16),
                badge!,
              ],
              if (footer != null) ...[
                const SizedBox(height: 8),
                Text(footer!, style: AppTextStyles.bodySm.
                copyWith(color: AppColors.outline,fontSize: 10.sp.clamp(8,15))),
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
                color: AppColors.onSurface.withOpacity(0.06),
              ),
            ),
        ],
      ),
    );
  }
}