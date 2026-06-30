import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import '../../../data/models/stock_adjustment_model.dart';
import 'adjustment_information.dart';

class AdjustmentHeader extends StatelessWidget {
  final StockAdjustmentModel adjustment;

  const AdjustmentHeader({super.key, required this.adjustment});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding:  EdgeInsets.only(left: 4.w,top: 8.h,right: 4.w),
        child: PageHeader(title:   'Stock Adjustment',actions: [AdjustmentInformation(adjustment: adjustment)],),
      );
  }
}
