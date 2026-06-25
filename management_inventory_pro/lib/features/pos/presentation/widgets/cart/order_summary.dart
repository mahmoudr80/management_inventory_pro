import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

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
      decoration: const BoxDecoration(color: AppColors.posSummaryBg),
      child: Column(
        children: [
          // _SummaryRow(label: 'Subtotal', value: subtotal),
          // const SizedBox(height: 8),
          // _SummaryRow(label: 'Tax (${(taxRate * 100).toStringAsFixed(1)}%)', value: tax),
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: Divider(height: 1, color: Color(0xFFC6CCEC)),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.posTextPrimary),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.posPrimary),
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
        Text(label, style: const TextStyle(color: AppColors.posTextSecondary, fontSize: 13.5)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: const TextStyle(color: AppColors.posTextPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
