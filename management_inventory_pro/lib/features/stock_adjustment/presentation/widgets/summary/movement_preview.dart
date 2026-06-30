import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import 'movement_preview_item.dart';

class MovementPreview extends StatelessWidget {
  final List<StockAdjustmentItemModel> items;

  const MovementPreview({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final filtered = items.where((i) => i.adjustmentQty != 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            children: [
              Text(
                'MOVEMENT PREVIEW',
                style: TextStyle(
                  fontSize: 4.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                  color: const Color(0xFF434656),
                ),
              ),
              const Expanded(
                child: Divider(
                  indent: 8,
                  color: Color(0xFFC3C5D9),
                ),
              ),
            ],
          ),
        ),
        if (filtered.isEmpty)
          Text(
            'No adjustments yet',
            style: TextStyle(
              fontSize: 4.sp,
              color: const Color(0xFF737688),
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ...filtered.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: MovementPreviewItem(item: item),
            ),
          ),
      ],
    );
  }
}
