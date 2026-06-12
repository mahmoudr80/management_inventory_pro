import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decoration.dart';
import '../../../../core/theme/app_text_styles.dart';
class SuppliersLoadingState extends StatelessWidget {
  const SuppliersLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(color: AppColors.surfaceContainerLowest),
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text('Loading suppliers…', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

