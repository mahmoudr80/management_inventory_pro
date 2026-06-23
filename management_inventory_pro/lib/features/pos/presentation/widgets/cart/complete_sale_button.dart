import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/pos/presentation/widgets/cart/payment_buttons.dart';

import '../../../../../core/theme/app_colors.dart';

/// Primary checkout CTA for the POS cart panel.
///
/// This is intentionally the single most visually dominant control in the
/// cart — full width, filled with the brand primary color, with a soft
/// elevated shadow that disappears on press. It sits directly beneath the
/// payment method section and finalizes the sale via a confirmation dialog.
///
/// UI only: this widget does not mutate cart state itself. It surfaces a
/// confirmation dialog and, once the cashier confirms, simply invokes
/// [onConfirm] — the parent (which owns the cart/order state) is
/// responsible for clearing the cart, resetting the payment method, and
/// showing the success snackbar.
class CompleteSaleButton extends StatefulWidget {
  /// Final payable amount (subtotal + tax) to display in the confirmation dialog.
  final double totalAmount;

  /// Total number of items in the cart (sum of line-item quantities).
  final int itemCount;

  /// Name of the customer the sale is being completed for.
  final String customerName;

  /// Currently selected payment method, or null if none has been chosen yet.
  final PaymentMethod? paymentMethod;

  /// Whether the button is interactive. Should be false when the cart is empty.
  final bool isEnabled;

  /// Called once the cashier taps "Confirm Sale" in the dialog.
  final VoidCallback onConfirm;

  const CompleteSaleButton({
    super.key,
    required this.totalAmount,
    required this.itemCount,
    required this.customerName,
    required this.paymentMethod,
    required this.isEnabled,
    required this.onConfirm,
  });

  @override
  State<CompleteSaleButton> createState() => _CompleteSaleButtonState();
}

class _CompleteSaleButtonState extends State<CompleteSaleButton> {
  bool _hovering = false;
  bool _pressed = false;

  String get _paymentLabel {
    switch (widget.paymentMethod) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      default:
        return 'Not selected';
    }
  }

  void _handleTap() {
    if (!widget.isEnabled) return;
    _showConfirmDialog();
  }

  Future<void> _showConfirmDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _CompleteSaleDialog(
        customerName: widget.customerName,
        itemCount: widget.itemCount,
        paymentLabel: _paymentLabel,
        totalAmount: widget.totalAmount,
      ),
    );

    if (confirmed == true) {
      widget.onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.isEnabled;

    final Color background = !enabled
        ? AppColors.posBorder
        : (_pressed || _hovering)
            ? AppColors.posPrimaryDark
            : AppColors.posPrimary;

    final Color foreground = enabled ? Colors.white : AppColors.posTextMuted;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (enabled) setState(() => _hovering = true);
      },
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: _handleTap,
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: double.infinity,
            height: 56, // within the required 52-60px range
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14), // matches active payment-button radius
              boxShadow: enabled && !_pressed
                  ? [
                      BoxShadow(
                        color: AppColors.posPrimary.withAlpha(72),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_checkout_rounded, color: foreground, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Complete Sale',
                  style: TextStyle(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompleteSaleDialog extends StatelessWidget {
  final String customerName;
  final int itemCount;
  final String paymentLabel;
  final double totalAmount;

  const _CompleteSaleDialog({
    required this.customerName,
    required this.itemCount,
    required this.paymentLabel,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.posCardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.posSummaryBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shopping_cart_checkout_rounded, color: AppColors.posPrimary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Complete Sale',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.posTextPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Are you sure you want to finalize this sale?',
                style: TextStyle(fontSize: 13.5, color: AppColors.posTextSecondary, height: 1.4),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.posSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.posBorder),
                ),
                child: Column(
                  children: [
                    _DialogRow(label: 'Customer', value: customerName),
                    const SizedBox(height: 10),
                    _DialogRow(label: 'Items', value: '$itemCount'),
                    const SizedBox(height: 10),
                    _DialogRow(label: 'Payment Method', value: paymentLabel),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: AppColors.posBorder),
                    ),
                    _DialogRow(
                      label: 'Total Amount',
                      value: '\$${totalAmount.toStringAsFixed(2)}',
                      emphasize: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.posBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        foregroundColor: AppColors.posTextPrimary,
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.posPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Confirm Sale', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _DialogRow({required this.label, required this.value, this.emphasize = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasize ? 14 : 13,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
            color: emphasize ? AppColors.posTextPrimary : AppColors.posTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasize ? 16 : 13.5,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            color: emphasize ? AppColors.posPrimary : AppColors.posTextPrimary,
          ),
        ),
      ],
    );
  }
}
