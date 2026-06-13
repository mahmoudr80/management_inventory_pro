import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decoration.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/assets.gen.dart';
class SuppliersLoadingState extends StatelessWidget {
  const SuppliersLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(color: AppColors.surfaceContainerLowest),
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
           SizedBox(width:100.r,height:100.r,child: Lottie.asset(Assets.lottie.loading)),
          const SizedBox(height: 16),
          Text('Loading suppliers…', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

