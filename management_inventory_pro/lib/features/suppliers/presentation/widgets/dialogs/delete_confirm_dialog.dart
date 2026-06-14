import 'package:flutter/material.dart';
import '../../../../../core/dialogs/app_confirm_dialog.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String supplierName;
  final VoidCallback onConfirm;

  const DeleteConfirmDialog({
    super.key,
    required this.supplierName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(title: 'Delete Supplier',
      message: 'Are you sure you want to delete "$supplierName"? This action cannot be undone.'
      ,    confirmText: 'Delete', icon: Icons.delete_outline,
      iconColor: AppColors.error, iconBackgroundColor: AppColors.errorContainer,
      onConfirm: () {
        onConfirm();
      },);
  }
}
