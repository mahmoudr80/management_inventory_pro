import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/services/sale_calculator.dart';
import '../../theme/pos_theme_extension.dart';

/// Renders the cart's tax/discount breakdown. Never calculates anything
/// itself — [totals] is always produced upstream by `SaleCalculator` (via
/// `PosCubit`) and simply displayed here.
class OrderSummary extends StatelessWidget {
  final SaleTotals totals;

  const OrderSummary({
    super.key,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      decoration: BoxDecoration(color: context.posColors.summaryBg),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: totals.subtotal),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Discount', value: -totals.discountAmount),
          // Tax row disappears completely when tax is disabled.
          if (totals.taxEnabled) ...[
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Tax (${totals.taxPercentage.toStringAsFixed(0)}%)',
              value: totals.taxAmount,
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: context.posColors.textPrimary),
              ),
              Text(
                '\$${totals.grandTotal.toStringAsFixed(2)}',
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
    final isNegative = value < 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: context.posColors.textSecondary, fontSize: 13.5)),
        Text(
          '${isNegative ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
          style: TextStyle(color: context.posColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}