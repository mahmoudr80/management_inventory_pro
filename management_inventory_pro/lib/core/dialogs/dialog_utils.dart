import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_confirm_dialog.dart';

Future<void> showDeleteConfirmation({
  required BuildContext context,
  required String title,
  required String itemName,
  required VoidCallback onConfirm,
}) async {
  await showDialog(
    context: context,
    builder: (_) => AppConfirmDialog(
      title: title,
      message:
      'Are you sure you want to delete "$itemName"? This action cannot be undone.',
      confirmText: 'Delete',
      icon: Icons.delete_outline,
      iconColor: AppColors.error,
      iconBackgroundColor: AppColors.errorContainer,
      onConfirm: onConfirm,
    ),
  );
}