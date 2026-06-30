import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../data/models/stock_adjustment_model.dart';
import 'adjustment_status_chip.dart';

class AdjustmentInformation extends StatelessWidget {
  final StockAdjustmentModel adjustment;

  const AdjustmentInformation({super.key, required this.adjustment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaField(label: 'ADJ NUMBER', value: adjustment.id),
        SizedBox(width: 4.w),
        _MetaField(label: 'CREATED BY', value: adjustment.createdBy),
        SizedBox(width: 4.w),
        _MetaField(
          label: 'DATE/TIME',
          value: DateFormat('MMM d, yyyy · HH:mm').format(adjustment.createdAt??DateTime.now()),
        ),
        SizedBox(width: 24.w),
        AdjustmentStatusChip(status: adjustment.status),
      ],
    );
  }
}

class _MetaField extends StatelessWidget {
  final String label;
  final String value;

  const _MetaField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 4.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
            color: const Color(0xFF434656),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 4.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF131B2E),
          ),
        ),
      ],
    );
  }
}
