import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/sale_model.dart';
import '../../cubit/sales_history_cubit.dart';
import 'sale_details_header.dart';
import 'sale_items_table.dart';
import 'payment_summary_card.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_decoration.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';


class SaleDetailsPanel extends StatefulWidget {
  const SaleDetailsPanel({super.key, required this.sale});
  final SaleModel sale;

  @override
  State<SaleDetailsPanel> createState() => _SaleDetailsPanelState();
}

class _SaleDetailsPanelState extends State<SaleDetailsPanel> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();
    final sale = widget.sale;

    return Container(
      decoration: AppDecorations.elevatedCard(
        color: AppColors.surface,
        borderColor: AppColors.border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelTopBar(onClose: cubit.clearSelection),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SaleDetailsHeader(sale: sale),
                    SizedBox(height: AppSpacing.md),
                    _SectionLabel(label: 'Items'),
                    SizedBox(height: AppSpacing.sm),
                    SaleItemsTable(items: sale.items),
                    SizedBox(height: AppSpacing.md),
                    PaymentSummaryCard(sale: sale),
                    SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
          _PanelActions(),
        ],
      ),
    );
  }
}


// ---------------------------------------------------------------------------

class _PanelTopBar extends StatelessWidget {
  const _PanelTopBar({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Text(
            'Sale Details',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headlineMd.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close_rounded,
                size: AppIconSize.md, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppIconSize.lg + AppSpacing.xs,
              minHeight: AppIconSize.lg + AppSpacing.xs,
            ),
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
    return Tooltip(
      message: label,
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.headlineSm.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PanelActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Print receipt – coming soon',
                    style: AppTextStyles.bodyMd,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(Icons.print_rounded, size: AppIconSize.md),
            label: Tooltip(
              message: 'Print Receipt',
              child: Text(
                'Print Receipt',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.buttonText.copyWith(color: AppColors.textPrimary),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmation(context),
            icon: Icon(Icons.delete_outline_rounded, size: AppIconSize.md),
            label: Tooltip(
              message: 'Delete Sale',
              child: Text(
                'Delete Sale',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.buttonText.copyWith(color: AppColors.error),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.errorContainer),
              backgroundColor: AppColors.errorContainer.withOpacity(0.3),
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete Sale',
          style: AppTextStyles.headlineSm,
        ),
        content: Text(
          'Are you sure you want to delete this sale? This action cannot be undone.',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonText.copyWith(color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Delete sale – coming soon',
                    style: AppTextStyles.bodyMd,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
                foregroundColor: AppColors.error),
            child: Text(
              'Delete',
              style: AppTextStyles.buttonText.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
