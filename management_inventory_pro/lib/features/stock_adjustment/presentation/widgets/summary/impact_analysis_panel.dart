import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/stock_adjustment_cubit.dart';
import '../../cubit/stock_adjustment_state.dart';
import 'inventory_value_summary.dart';
import 'movement_preview.dart';
import 'summary_card.dart';

class ImpactAnalysisPanel extends StatelessWidget {
  const ImpactAnalysisPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockAdjustmentCubit, StockAdjustmentState>(
      builder: (context, state) {
        if (state is! StockAdjustmentLoaded) return const SizedBox.shrink();
        final adj = state.adjustment;

        return Container(
          width: 90.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8FF),
            border: const Border(left: BorderSide(color: Color(0xFFC3C5D9))),
          ),
          child: Column(
            children: [
              _PanelHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical:8.w,horizontal: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              label: 'Total Increase',
                              value: '+${adj.totalIncrease} units',
                              valueColor: const Color(0xFF0041C8),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: SummaryCard(
                              label: 'Total Decrease',
                              value: '${adj.totalDecrease} units',
                              valueColor: const Color(0xFFBA1A1A),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      _NetQtyCard(net: adj.netQtyChange),
                      SizedBox(height: 12.h),
                      InventoryValueSummary(adjustment: adj),
                      SizedBox(height: 20.h),
                      MovementPreview(items: adj.items),
                    ],
                  ),
                ),
              ),
              _PanelFooter(),
            ],
          ),
        );
      },
    );
  }
}

class _PanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 14.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFC3C5D9))),
      ),
      child: Row(
        spacing: 5.w,
        children: [
          Icon(Icons.analytics_outlined, size: 28.r, color: const Color(0xFF0041C8)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Impact Analysis',
                style: TextStyle(
                  fontSize: 5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF131B2E),
                ),
              ),
              Text(
                'Real-time inventory changes',
                style: TextStyle(
                  fontSize: 4.sp,
                  color: const Color(0xFF434656),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NetQtyCard extends StatelessWidget {
  final int net;
  const _NetQtyCard({required this.net});

  @override
  Widget build(BuildContext context) {
    final isNeg = net < 0;
    final prefix = net > 0 ? '+' : '';
    return Container(
      padding: EdgeInsets.symmetric(vertical:  14.h,horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFC3C5D9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NET QUANTITY CHANGE',
                style: TextStyle(
                  fontSize: 4.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                  color: const Color(0xFF434656),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '$prefix$net units',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 6.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF131B2E),
                ),
              ),
            ],
          ),
          Icon(
            isNeg ? Icons.trending_down : Icons.trending_up,
            size: 28.r,
            color: isNeg ? const Color(0xFFBA1A1A) : const Color(0xFF0041C8),
          ),
        ],
      ),
    );
  }
}

class _PanelFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:14.h,horizontal: 2.w),
      decoration: const BoxDecoration(
        color: Color(0xFFDAE2FD),
        border: Border(top: BorderSide(color: Color(0xFFC3C5D9))),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 28.r, color: const Color(0xFF434656)),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Adjustments affect COGS and P&L statements.',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 4.sp,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF434656),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
