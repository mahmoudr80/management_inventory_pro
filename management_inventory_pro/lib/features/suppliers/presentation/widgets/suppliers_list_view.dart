import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decoration.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/supplier_model.dart';
import '../cubit/suppliers_cubit.dart';
import 'cards/supplier_list_tile.dart';
import 'dialogs/delete_confirm_dialog.dart';

class SuppliersListView extends StatelessWidget {
  const SuppliersListView({
    super.key,
    required this.suppliers,
    this.selectedId,
  });
  final List<SupplierModel> suppliers;
  final String? selectedId;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(color: AppColors.surfaceContainerLowest),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Table header
          _TableHeader(),
          const Divider(height: 1, color: AppColors.outlineVariant),

          // Rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: suppliers.length,
            itemBuilder: (context, i) {
              final s = suppliers[i];
              return SupplierListTile(
                supplier: s,
                isSelected: s.id == selectedId,
                onTap: () => context.read<SuppliersCubit>().selectSupplier(s),
                onEdit: () => context.read<SuppliersCubit>().openEditForm(s),
                onDelete: () => _confirmDelete(context, s),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, SupplierModel s) {
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmDialog(
        supplierName: s.name,
        onConfirm: () => context.read<SuppliersCubit>().deleteSupplier(s.id),
      ),
    );
  }
}


class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 50), // avatar
          Expanded(
            flex: 3,
            child: Text('SUPPLIER NAME', style: AppTextStyles.labelCaps),
          ),
          Expanded(
            flex: 2,
            child: Text('PHONE', style: AppTextStyles.labelCaps),
          ),
          // actions col
          const SizedBox(width: 72),
        ],
      ),
    );
  }
}