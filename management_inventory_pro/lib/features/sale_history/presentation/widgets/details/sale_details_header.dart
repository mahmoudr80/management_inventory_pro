import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../data/models/sale_item_model.dart';
import '../../../data/models/sale_model.dart';

class SaleDetailsHeader extends StatelessWidget {
  const SaleDetailsHeader({super.key, required this.sale});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Sale ID row with status badge
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.r, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.receipt_rounded,
                  size: 28.r,
                  color: const Color(0xFF2563EB),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  sale.id,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 4.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              _StatusBadge(status: sale.status),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          SizedBox(height: 12.h),

          // Info grid
          _InfoRow(
            label: 'Date & Time',
            value: DateFormat('MMM d, yyyy hh:mm a').format(sale.createdAt),
          ),
          SizedBox(height: 8.h),
          _InfoRow(
            label: 'Cashier',
            value: sale.cashierName,
          ),
          SizedBox(height: 8.h),
          _InfoRow(
            label: 'Payment Method',
            value: switch (sale.paymentMethod) {
              PaymentMethod.cash => 'Cash',
              PaymentMethod.card => 'Card',
              PaymentMethod.mixed => 'Mixed',
            },
          ),
          if (sale.notes != null && sale.notes!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _InfoRow(
              label: 'Notes',
              value: sale.notes!,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final SaleStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      SaleStatus.completed => ('Completed', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
      SaleStatus.refunded  => ('Refunded',  const Color(0xFFFEF3C7), const Color(0xFFD97706)),
      SaleStatus.cancelled => ('Cancelled', const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 3.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 3.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 3.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }
}
