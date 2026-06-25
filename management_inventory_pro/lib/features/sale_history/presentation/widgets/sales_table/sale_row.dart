import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../data/models/sale_item_model.dart';
import '../../../data/models/sale_model.dart';

class SaleRow extends StatefulWidget {
  const SaleRow({
    super.key,
    required this.sale,
    required this.isSelected,
    required this.onTap,
  });

  final SaleModel sale;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<SaleRow> createState() => _SaleRowState();
}

class _SaleRowState extends State<SaleRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final sale = widget.sale;
    Color bgColor = Colors.transparent;
    if (widget.isSelected) {
      bgColor = const Color(0xFFEFF6FF);
    } else if (_isHovered) {
      bgColor = const Color(0xFFF9FAFB);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          color: bgColor,
          child: Row(
            children: [
              // Sale ID
              Expanded(
                flex: 2,
                child: Text(
                  sale.id,
                  style: TextStyle(
                    fontSize: 4.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF111827),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Date & Time
              Expanded(
                flex: 3,
                child: Text(
                  DateFormat('MMM d, yyyy hh:mm a').format(sale.createdAt),
                  style: TextStyle(
                    fontSize: 4.sp,
                    color: const Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Items Count
              Expanded(
                flex: 1,
                child: Text(
                  sale.totalItems.toString(),
                  style: TextStyle(
                    fontSize: 4.sp,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),

              // Quantity
              Expanded(
                flex: 1,
                child: Text(
                  sale.totalQuantity.toString(),
                  style: TextStyle(
                    fontSize: 4.sp,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),

              // Total Amount
              Expanded(
                flex: 2,
                child: Text(
                  '\$${sale.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 4.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Payment Method Badge
              Expanded(
                flex: 2,
                child: _PaymentBadge(method: sale.paymentMethod),
              ),

              // Cashier
              Expanded(
                flex: 2,
                child: Text(
                  sale.cashierName,
                  style: TextStyle(
                    fontSize: 4.sp,
                    color: const Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                size: 5.r,
                color: widget.isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFD1D5DB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  const _PaymentBadge({required this.method});
  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (method) {
      PaymentMethod.cash => ('Cash', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
      PaymentMethod.card => ('Card', const Color(0xFFDBEAFE), const Color(0xFF2563EB)),
      PaymentMethod.mixed => ('Mixed', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 4.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
