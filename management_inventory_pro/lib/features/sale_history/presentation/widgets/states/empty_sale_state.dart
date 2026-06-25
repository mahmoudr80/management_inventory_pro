import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_filters_bar.dart';

import '../../cubit/sales_history_cubit.dart';
import 'empty_sale_state.dart';

class SaleEmptyBody extends StatelessWidget {
  const SaleEmptyBody({super.key, required this.filters});
  final ActiveFilters filters;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SalesFiltersBar(filters: filters),
        SizedBox(height: 16.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: _EmptySalesState(hasFilters: filters.hasActiveFilters),
          ),
        ),
      ],
    );
  }
}



class _EmptySalesState extends StatelessWidget {
  const _EmptySalesState({super.key, required this.hasFilters});

  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // width: 64.w,
            // height: 64.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasFilters
                  ? Icons.search_off_rounded
                  : Icons.receipt_long_outlined,
              size: 50.r,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            hasFilters ? 'No sales match your filters' : 'No sales found',
            style: TextStyle(
              fontSize: 7.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            hasFilters
                ? 'Try adjusting your search or filter criteria.'
                : 'Completed sales will appear here once recorded.',
            style: TextStyle(
              fontSize: 7.sp,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasFilters)
                OutlinedButton.icon(
                  onPressed: cubit.resetFilters,
                  icon: Icon(Icons.filter_alt_off_rounded, size: 28.r),
                  label:
                  Text('Clear Filters', style: TextStyle(fontSize: 7.sp)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF374151),
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              if (hasFilters) SizedBox(width: 4.w),
              FilledButton.icon(
                onPressed: cubit.refresh,
                icon: Icon(Icons.refresh_rounded, size: 28.r),
                label: Text('Refresh', style: TextStyle(fontSize: 7.sp)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding:
                  EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
