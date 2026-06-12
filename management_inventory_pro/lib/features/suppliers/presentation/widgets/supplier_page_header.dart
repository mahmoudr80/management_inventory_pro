import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/page_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/suppliers_cubit.dart';
import '../cubit/suppliers_state.dart';

class SupplierPageHeader extends StatelessWidget {
  const SupplierPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuppliersCubit, SuppliersState>(
        buildWhen: (prev, curr) => prev.suppliers.length != curr.suppliers.length,
        builder: (context, state) =>
            PageHeader(title: 'Add Supplier',
              subtitle: 'Manage and monitor ${state.suppliers.length} vendor partnerships.' ,
              actions: [_PageHeaderContent()],));
  }
}

class _PageHeaderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => context.read<SuppliersCubit>().openAddForm(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Supplier'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              textStyle: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600),
            ),
          )]);
  }
}

