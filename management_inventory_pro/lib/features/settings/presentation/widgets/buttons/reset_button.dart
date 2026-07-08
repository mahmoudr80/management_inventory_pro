import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import 'package:management_inventory_pro/core/widgets/primary_button.dart';
import 'package:management_inventory_pro/core/widgets/secondary_button.dart';

/// "Reset Defaults" action. Confirms via a lightweight dialog before
/// calling [onConfirm] — restoring defaults discards every unsaved (and,
/// until Save is pressed, saved-looking) edit, so it shouldn't fire on a
/// single misclick.
class ResetButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const ResetButton({super.key, required this.onConfirm});

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Restore Defaults?', style: AppTextStyles.headlineSm),
        content: Text(
          'This resets every setting on this page back to its default value. '
          "You'll still need to press Save Changes to keep it.",
          style: AppTextStyles.bodyMd,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        actions: [
          SizedBox(
            width: 120,
            child: SecondaryButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 120,
            child: PrimaryButton(
              text: 'Restore',
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      text: 'Reset Defaults',
      icon: Icons.restart_alt_rounded,
      onPressed: () => _confirm(context),
    );
  }
}
