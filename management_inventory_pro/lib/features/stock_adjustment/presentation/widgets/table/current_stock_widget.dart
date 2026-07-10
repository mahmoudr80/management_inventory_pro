import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';

class CurrentStockWidget extends StatelessWidget {
  final double currentStock;
  final String unit;

  const CurrentStockWidget({
    super.key,
    required this.currentStock,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currentStock',
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.dataMono.copyWith(
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
      ),
    );
  }
}