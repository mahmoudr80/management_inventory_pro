import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';

class StockEntryNotesSection extends StatelessWidget {
  const StockEntryNotesSection({super.key, required this.notesController});

  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes (optional)', style: AppTextStyles.labelCaps),
        const SizedBox(height: 6),
        TextFormField(
          controller: notesController,
          maxLines: 3,
          style: AppTextStyles.bodyMd,
          decoration: InputDecoration(
            hintText: 'Internal notes about this receipt...',
            hintStyle: AppTextStyles.bodyMd.copyWith(color: context.colors.outline),
            filled: true,
            fillColor: context.colors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}