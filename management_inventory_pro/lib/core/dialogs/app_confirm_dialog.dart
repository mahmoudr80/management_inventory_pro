import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.icon = Icons.warning_amber_rounded,
    this.iconColor = Colors.orange,
    this.iconBackgroundColor = Colors.orangeAccent,
  });

    @override
    Widget build(BuildContext context) {
      return Dialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 120,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.headlineSm,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  message,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context,false),
                      child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                    ),

                    const SizedBox(width: 12),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context,true);
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: iconColor,
                      ),
                      child: Text(confirmText,style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }