import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/sale_model.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key, required this.sale});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    // All values derived from SaleModel & SaleItemModel — no extra fields needed
    final subtotal = sale.totalAmount;
    final totalQty = sale.totalQuantity;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 3.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 10.h),
          _SummaryRow(
            label: 'Total Items',
            value: sale.totalItems.toString(),
          ),
          _SummaryRow(
            label: 'Total Quantity',
            value: totalQty.toString(),
          ),
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
          _SummaryRow(
            label: 'Total',
            value: '\$${subtotal.toStringAsFixed(2)}',
            labelStyle: TextStyle(
              fontSize: 4.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
            valueStyle: TextStyle(
              fontSize: 4.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: labelStyle ??
                  TextStyle(
                    fontSize: 3.sp,
                    color: const Color(0xFF6B7280),
                  ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: valueStyle ??
                TextStyle(
                  fontSize: 3.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
          ),
        ],
      ),
    );
  }
}
