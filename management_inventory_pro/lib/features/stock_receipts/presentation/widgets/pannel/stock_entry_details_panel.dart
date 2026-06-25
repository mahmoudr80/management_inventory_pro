import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/dialogs/dialog_utils.dart';
import '../../../../../core/theme/app_colors.dart';
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
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.outlineVariant),
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
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StockEntryDetailsHeader(entry: entry),
                  SizedBox(height: 12.h),
                  _SectionLabel(label: 'Lines'),
                  SizedBox(height: 8.h),
                  StockEntryLinesTable(lines: entry.lines),
                  SizedBox(height: 16.h),
                  StockEntryCostSummaryCard(entry: entry),
                  SizedBox(height: 16.h),
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
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant),
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
              size: 28.r,
              color: AppColors.outline,
            ),
            //padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 4.w, minHeight: 28.h),
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
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.bodySmall,
    );
  }
}

class _PanelActions extends StatelessWidget {
  const _PanelActions({required this.entry});
  final StockEntryModel entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
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
                foregroundColor: AppColors.onSurface,
                side: BorderSide(color: AppColors.outlineVariant),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                textStyle: AppTextStyles.bodySm
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: Color(0xFFFECACA)),
                backgroundColor: const Color(0xFFFFF5F5),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                textStyle: AppTextStyles.bodySm
                    .copyWith(fontWeight: FontWeight.w600),
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
