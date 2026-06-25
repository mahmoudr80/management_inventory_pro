import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/sales_history_cubit.dart';

class SaleErrorState extends StatelessWidget {
  const SaleErrorState({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline_rounded,
                size: 32.sp, color: const Color(0xFFDC2626)),
          ),
          SizedBox(height: 12.h),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            message,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
          ),
          SizedBox(height: 16.h),
          FilledButton.icon(
            onPressed: cubit.loadSales,
            icon: Icon(Icons.refresh_rounded, size: 16.sp),
            label: const Text('Try Again'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
