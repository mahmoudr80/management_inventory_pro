import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/sale_model.dart';
import '../../cubit/sales_history_cubit.dart';
import 'sale_details_header.dart';
import 'sale_items_table.dart';
import 'payment_summary_card.dart';

class SaleDetailsPanel extends StatelessWidget {
  const SaleDetailsPanel({super.key, required this.sale});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SaleDetailsHeader(sale: sale),
                  SizedBox(height: 8.h),
                  _SectionLabel(label: 'Items'),
                  SizedBox(height: 8.h),
                  SaleItemsTable(items: sale.items),
                  SizedBox(height: 16.h),
                  PaymentSummaryCard(sale: sale),
                  SizedBox(height: 16.h),
                ],
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
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Text(
            'Sale Details',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 4.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close_rounded,
                size: 5.r, color: const Color(0xFF6B7280)),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
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
      style: TextStyle(
        fontSize: 4.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111827),
      ),
    );
  }
}

class _PanelActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.r, vertical: 8.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Print receipt – coming soon',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 4.sp),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(Icons.print_rounded, size: 5.r),
              label: Text(
                'Print Receipt',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 4.sp),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF374151),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showDeleteConfirmation(context),
              icon: Icon(Icons.delete_outline_rounded, size: 5.r),
              label: Text(
                'Delete Sale',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 4.sp),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: const BorderSide(color: Color(0xFFFECACA)),
                backgroundColor: const Color(0xFFFFF5F5),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
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
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 4.sp),
        ),
        content: Text(
          'Are you sure you want to delete this sale? This action cannot be undone.',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 4.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 4.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Delete sale – coming soon',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 4.sp),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626)),
            child: Text(
              'Delete',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 4.sp),
            ),
          ),
        ],
      ),
    );
  }
}
