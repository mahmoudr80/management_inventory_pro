import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppLogo(size: 80.w.clamp(60, 100), showText: false),
        SizedBox(height: 24.h.clamp(18.0, 30)),
        Text(title, style: AppTextStyles.heading1, textAlign: TextAlign.center),
        SizedBox(height: 8.h.clamp(6, 10)),
        Text(
          subtitle,
          style: AppTextStyles.subtitle.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
