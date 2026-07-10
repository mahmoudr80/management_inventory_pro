import 'package:flutter/material.dart';
import '../../theme/pos_theme_extension.dart';
import '../../../../sale_history/data/models/sale_item_model.dart';


class PaymentButtons extends StatelessWidget {
  final PaymentMethod? selected;
  final ValueChanged<PaymentMethod> onSelect;
  final VoidCallback? onSplitPay;
  final VoidCallback? onPrint;

  const PaymentButtons({
    super.key,
    required this.selected,
    required this.onSelect,
    this.onSplitPay,
    this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _PaymentButton(
                  label: 'Cash',
                  icon: Icons.payments_outlined,
                  active: selected == PaymentMethod.cash,
                  onTap: () => onSelect(PaymentMethod.cash),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentButton(
                  label: 'Card',
                  icon: Icons.credit_card_rounded,
                  active: selected == PaymentMethod.card,
                  onTap: () => onSelect(PaymentMethod.card),
                  filled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSplitPay,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.posColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    foregroundColor: context.posColors.textPrimary,
                  ),
                  icon: const Icon(Icons.call_split_rounded, size: 18),
                  label: const Text('Split Pay', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onPrint,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.posColors.border),
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  foregroundColor: context.posColors.textPrimary,
                ),
                child: const Icon(Icons.print_outlined, size: 19),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final bool filled;

  const _PaymentButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isActiveStyle = active;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActiveStyle ? context.posColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActiveStyle ? context.posColors.primary : context.posColors.border,
            width: isActiveStyle ? 0 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isActiveStyle ? Colors.white : context.posColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isActiveStyle ? Colors.white : context.posColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}