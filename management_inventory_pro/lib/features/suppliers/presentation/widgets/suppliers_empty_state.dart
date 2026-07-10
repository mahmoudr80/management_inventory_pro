import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/theme/app_decoration.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/suppliers_cubit.dart';

class SuppliersEmptyState extends StatelessWidget {
  const SuppliersEmptyState({super.key,required this.hasQuery});
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(color: context.colors.surfaceContainerLowest),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        children: [
          Icon(
            hasQuery ? Icons.search_off_outlined : Icons.storefront_outlined,
            size: 44,
            color: context.colors.outlineVariant,
          ),
          const SizedBox(height: 12),
          Text(
            hasQuery ? 'No suppliers match your search' : 'No suppliers yet',
            style: AppTextStyles.headlineSm.copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Text(
            hasQuery ? 'Try different keywords or clear the search.' : 'Add your first supplier to get started.',
            style: AppTextStyles.bodySm.copyWith(color: context.colors.outlineVariant),
            textAlign: TextAlign.center,
          ),
          if (!hasQuery) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.read<SuppliersCubit>().openAddForm(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Supplier'),
              style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}