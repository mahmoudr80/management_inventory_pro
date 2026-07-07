import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class MarginCard extends StatelessWidget {
  const MarginCard({
    super.key,
    this.marginPercent,
    required this.sell,
    required this.cost,
  });

  final double? marginPercent;
  final double sell;
  final double cost;

  @override
  Widget build(BuildContext context) {
    final margin = marginPercent;
    if (margin == null) return const SizedBox.shrink();

    final profit = sell - cost;
    final isGood = margin > 20;
    final isOk = margin > 0;

    final bgColor = isGood
        ? AppColors.successContainer
        : isOk
            ? AppColors.warningContainer
            : AppColors.errorContainer;

    final textColor = isGood
        ? AppColors.success
        : isOk
            ? AppColors.onWarningContainer
            : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gross margin',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor,
                  ),
                ),
                Text(
                  '${margin.round()}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Profit / unit',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor,
                  ),
                ),
                Text(
                  '\$${profit.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
