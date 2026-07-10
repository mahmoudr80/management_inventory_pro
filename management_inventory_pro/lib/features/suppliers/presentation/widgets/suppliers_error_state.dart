import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/theme/app_decoration.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/suppliers_cubit.dart';

class SuppliersErrorState extends StatelessWidget {
  const SuppliersErrorState({super.key,required this.message});
  final String message;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(color: context.colors.surfaceContainerLowest),
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 40, color: context.colors.error),
          const SizedBox(height: 12),
          Text('Failed to load', style: AppTextStyles.headlineSm),
          const SizedBox(height: 4),
          Text(message, style: AppTextStyles.bodySm.copyWith(color: context.colors.onSurfaceVariant)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.read<SuppliersCubit>().loadSuppliers(),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}