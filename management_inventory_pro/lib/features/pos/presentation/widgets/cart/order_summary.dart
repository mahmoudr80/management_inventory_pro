import 'package:flutter/material.dart';
import '../../theme/pos_theme_extension.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double taxRate;

  const OrderSummary({
    super.key,
    required this.subtotal,
    this.taxRate = 0.085,
  });

  double get tax => subtotal * taxRate;
  double get total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      decoration: BoxDecoration(color: context.posColors.summaryBg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: context.posColors.textPrimary),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: context.posColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: context.posColors.textSecondary, fontSize: 13.5)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(color: context.posColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}