import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/components/page_header.dart';
import '../cubit/sales_history_cubit.dart';

class SalePageHeader extends StatelessWidget {
  const SalePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();
    return PageHeader(title: 'Sales History',subtitle: 'Review and manage completed sales transactions',
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Export – coming soon'),
                  duration: Duration(seconds: 2)),
            );
          },
          icon: Icon(Icons.file_upload_outlined, size: 5.sp),
          label: Text('Export', style: TextStyle(fontSize: 5.sp)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF374151),
            side: const BorderSide(color: Color(0xFFD1D5DB)),
            backgroundColor: Colors.white,
            padding:
            EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: cubit.refresh,
          icon: Icon(Icons.refresh_rounded, size: 5.sp),
          label: Text('Refresh', style: TextStyle(fontSize: 5.sp)),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            padding:
            EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        )
      ],);
  }
}
