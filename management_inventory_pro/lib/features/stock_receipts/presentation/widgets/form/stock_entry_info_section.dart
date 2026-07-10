import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/supplier_ref.dart';
import '../supplier_dropdown.dart';

class StockEntryInfoSection extends StatelessWidget {
  const StockEntryInfoSection({
    super.key,
    required this.receiptDate,
    this.selectedSupplier,
    required this.onChanged,
    this.onTap,
  });

  final DateTime receiptDate;
  final SupplierRef? selectedSupplier;
  final void Function(SupplierRef?) onChanged;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 600;

        final supplierColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SUPPLIER', style: AppTextStyles.labelCaps),
            const SizedBox(height: 6),
            SupplierDropdown(
              selected: selectedSupplier,
              onChanged: onChanged,
            ),
          ],
        );

        final dateColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RECEIPT DATE', style: AppTextStyles.labelCaps),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  border: Border.all(color: context.colors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${receiptDate.year}-'
                            '${receiptDate.month.toString().padLeft(2, '0')}-'
                            '${receiptDate.day.toString().padLeft(2, '0')}',
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: context.colors.outline,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              supplierColumn,
              const SizedBox(height: 16),
              dateColumn,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: supplierColumn),
            const SizedBox(width: 16),
            Expanded(child: dateColumn),
          ],
        );
      },
    );
  }
}