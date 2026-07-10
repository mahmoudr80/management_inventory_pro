import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';

class StockEntryEmptyState extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback? onClearFilter;
  final VoidCallback? onAddEntry;

  const StockEntryEmptyState({
    super.key,
    this.isFiltered = false,
    this.onClearFilter,
    this.onAddEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFiltered ? Icons.filter_list_off : Icons.receipt_long_outlined,
            size: 56,
            color: context.colors.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered
                ? 'No receipts match your filters'
                : 'No stock receipts yet',
            style: AppTextStyles.headlineSm.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered
                ? 'Try adjusting or clearing your active filters.'
                : 'Record your first inbound shipment to get started.',
            style: AppTextStyles.bodyMd.copyWith(color: context.colors.outline),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (isFiltered && onClearFilter != null)
            OutlinedButton(
              onPressed: onClearFilter,
              child: const Text('Clear Filters'),
            )
          else if (!isFiltered && onAddEntry != null)
            FilledButton.icon(
              onPressed: onAddEntry,
              icon: const Icon(Icons.add),
              label: const Text('Record Receipt'),
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
              ),
            ),
        ],
      ),
    );
  }
}