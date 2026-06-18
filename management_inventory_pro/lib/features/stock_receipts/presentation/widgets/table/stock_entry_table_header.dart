import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      color: AppColors.surfaceContainerLow,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _Th('Receipt ID', flex: 3, mono: true),
          _Th('Supplier', flex: 4),
          _Th('Items', flex: 2, align: TextAlign.left),
          _Th('Total Value', flex: 3, align: TextAlign.left),
          _Th('Date', flex: 3),
          _Th('Status', flex: 3),
          SizedBox(width: 72.w.clamp(50, 100)), // actions column
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  final String label;
  final int flex;
  final TextAlign align;
  final bool mono;

  const _Th(
      this.label, {
        this.flex = 1,
        this.align = TextAlign.left,
        this.mono = false,
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label.toUpperCase(),
        textAlign: align,
        style: AppTextStyles.labelCaps,
      ),
    );
  }
}