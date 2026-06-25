import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/sale_summary_model.dart';

class SalesSummarySection extends StatelessWidget {
  const SalesSummarySection({super.key, required this.summary});

  final SalesSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      SummaryCardData(
        label: 'Total Sales Revenue',
        value: '\$${summary.totalRevenue.toStringAsFixed(2)}',
        icon: Icons.attach_money_rounded,
        iconColor: const Color(0xFF16A34A),
        iconBg: const Color(0xFFDCFCE7),
        trend: '+18.6% vs last period',
        trendPositive: true,
      ),
      SummaryCardData(
        label: 'Total Orders',
        value: summary.totalOrders.toString(),
        icon: Icons.receipt_long_rounded,
        iconColor: const Color(0xFF2563EB),
        iconBg: const Color(0xFFDBEAFE),
        trend: '+12.4% vs last period',
        trendPositive: true,
      ),
      SummaryCardData(
        label: 'Total Items Sold',
        value: summary.totalItemsSold.toString(),
        icon: Icons.inventory_2_rounded,
        iconColor: const Color(0xFFD97706),
        iconBg: const Color(0xFFFEF3C7),
        trend: '+15.3% vs last period',
        trendPositive: true,
      ),
      SummaryCardData(
        label: 'Total Quantity',
        value: summary.totalQuantitySold.toString(),
        icon: Icons.bar_chart_rounded,
        iconColor: const Color(0xFF7C3AED),
        iconBg: const Color(0xFFEDE9FE),
        trend: '+10.7% vs last period',
        trendPositive: true,
      ),
      SummaryCardData(
        label: 'Average Order Value',
        value: '\$${summary.averageOrderValue.toStringAsFixed(2)}',
        icon: Icons.trending_up_rounded,
        iconColor: const Color(0xFF0891B2),
        iconBg: const Color(0xFFCFFAFE),
        trend: '+5.2% vs last period',
        trendPositive: true,
      ),
    ];
    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(
            child: _SummaryCard(data: card),
          ),
          if (card != cards.last)
            SizedBox(width: 8.w),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final SummaryCardData data;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(data.icon, color: data.iconColor, size: 5.sp),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            data.label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 4.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            data.value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 4.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                data.trendPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 5.sp,
                color: data.trendPositive
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFDC2626),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  data.trend,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 4.sp,
                    color: data.trendPositive
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                    fontWeight: FontWeight.w500,
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
