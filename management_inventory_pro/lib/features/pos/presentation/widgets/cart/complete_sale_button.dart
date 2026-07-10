import 'package:flutter/material.dart';
import '../../theme/pos_theme_extension.dart';
import '../../../../sale_history/data/models/sale_item_model.dart';

class CompleteSaleButton extends StatefulWidget {
  final double totalAmount;
  final int itemCount;
  final String customerName;
  final PaymentMethod? paymentMethod;
  final bool isEnabled;
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
        ? context.posColors.border
        : (_pressed || _hovering)
        ? context.posColors.primaryDark
        : context.posColors.primary;

    final Color foreground = enabled ? Colors.white : context.posColors.textMuted;

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
            height: 56,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
              boxShadow: enabled && !_pressed
                  ? [
                BoxShadow(
                  color: context.posColors.primary.withAlpha(72),
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
      backgroundColor: context.posColors.cardBg,
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
                      color: context.posColors.summaryBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.shopping_cart_checkout_rounded, color: context.posColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Complete Sale',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: context.posColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Are you sure you want to finalize this sale?',
                style: TextStyle(fontSize: 13.5, color: context.posColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.posColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.posColors.border),
                ),
                child: Column(
                  children: [
                    _DialogRow(label: 'Customer', value: customerName),
                    const SizedBox(height: 10),
                    _DialogRow(label: 'Items', value: '$itemCount'),
                    const SizedBox(height: 10),
                    _DialogRow(label: 'Payment Method', value: paymentLabel),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: context.posColors.border),
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
                        side: BorderSide(color: context.posColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        foregroundColor: context.posColors.textPrimary,
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.posColors.primary,
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
            color: emphasize ? context.posColors.textPrimary : context.posColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasize ? 16 : 13.5,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            color: emphasize ? context.posColors.primary : context.posColors.textPrimary,
          ),
        ),
      ],
    );
  }
}