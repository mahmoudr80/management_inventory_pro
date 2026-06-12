import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decoration.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/suppliers_cubit.dart';

class SuppliersErrorState extends StatelessWidget {
  const SuppliersErrorState({super.key,required this.message});
  final String message;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(color: AppColors.surfaceContainerLowest),
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 40, color: AppColors.error),
          const SizedBox(height: 12),
          Text('Failed to load', style: AppTextStyles.headlineSm),
          const SizedBox(height: 4),
          Text(message, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.read<SuppliersCubit>().loadSuppliers(),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

