import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dialogs/dialog_utils.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_model.dart';
import '../../cubit/stock_entry_cubit.dart';
import 'stock_entry_details_header.dart';
import 'stock_entry_lines_table.dart';
import 'stock_entry_cost_summary_card.dart';

class StockEntryDetailsPanel extends StatelessWidget {
  const StockEntryDetailsPanel({super.key, required this.entry});

  final StockEntryModel entry;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StockEntryCubit>();

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelTopBar(onClose: cubit.clearSelection),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StockEntryDetailsHeader(entry: entry),
                  const SizedBox(height: 12),
                  const _SectionLabel(label: 'Lines'),
                  const SizedBox(height: 8),
                  StockEntryLinesTable(lines: entry.lines),
                  const SizedBox(height: 16),
                  StockEntryCostSummaryCard(entry: entry),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _PanelActions(entry: entry),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PanelTopBar extends StatelessWidget {
  const _PanelTopBar({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colors.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Receipt Details',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall,
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: context.colors.outline,
            ),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Close panel',
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        label.toUpperCase(),
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.labelCaps,
      ),
    );
  }
}

class _PanelActions extends StatelessWidget {
  const _PanelActions({required this.entry});
  final StockEntryModel entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Print receipt – coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.print_rounded, size: 16),
              label: const Text('Print'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.onSurface,
                side: BorderSide(color: context.colors.outlineVariant),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.error,
                side: BorderSide(color: context.colors.errorContainer),
                backgroundColor: context.colors.errorContainer.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    await showDeleteConfirmation(
      context: context,
      title: 'Delete Receipt',
      itemName: entry.id,
      onConfirm: () {
        context.read<StockEntryCubit>().deleteEntry(entry.id);
        context.read<StockEntryCubit>().clearSelection();
      },
    );
  }
}