import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_item_model.dart';

class AdjustmentQuantityField extends StatefulWidget {
  final StockAdjustmentItemModel item;
  final ValueChanged<int> onChanged;

  const AdjustmentQuantityField({
    super.key,
    required this.item,
    required this.onChanged,
  });

  @override
  State<AdjustmentQuantityField> createState() =>
      _AdjustmentQuantityFieldState();
}

class _AdjustmentQuantityFieldState extends State<AdjustmentQuantityField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    final qty = widget.item.adjustmentQty;
    _controller = TextEditingController(
      text: qty == 0 ? '' : qty > 0 ? '+$qty' : '$qty',
    );
  }

  @override
  void didUpdateWidget(AdjustmentQuantityField old) {
    super.didUpdateWidget(old);
    if (old.item.adjustmentQty != widget.item.adjustmentQty &&
        !_focusNode.hasFocus) {
      final qty = widget.item.adjustmentQty;
      _controller.text = qty == 0 ? '' : qty > 0 ? '+$qty' : '$qty';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit(String value) {
    final cleaned = value.replaceAll('+', '').trim();
    final parsed = int.tryParse(cleaned) ?? 0;
    widget.onChanged(parsed);
    if (parsed > 0) {
      _controller.text = '+$parsed';
    } else if (parsed == 0) {
      _controller.text = '';
    }
  }

  Color get _borderColor {
    if (widget.item.isNegativeInventory) return context.colors.error;
    if (widget.item.isOutOfStock) return context.colors.error;
    return context.colors.outlineVariant;
  }

  Color get _textColor {
    final qty = widget.item.adjustmentQty;
    if (qty > 0) return context.colors.primary;
    if (qty < 0) return context.colors.error;
    return context.colors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    // Narrow numeric field: min/max width keeps it usable without
    // letting it stretch or shrink unpredictably in its table cell.
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 64, maxWidth: 96),
      child: SizedBox(
        height: 36,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textAlign: TextAlign.center,
          onSubmitted: _onSubmit,
          onEditingComplete: () => _onSubmit(_controller.text),
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: false),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[+\-]?\d*')),
          ],
          style: AppTextStyles.dataMono
              .copyWith(fontWeight: FontWeight.w700, color: _textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.item.isNegativeInventory
                ? context.colors.errorContainer.withOpacity(0.3)
                : context.colors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.standard),
              borderSide: BorderSide(color: _borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.standard),
              borderSide: BorderSide(color: _borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.standard),
              borderSide: BorderSide(
                  color: context.colors.primary, width: AppBorder.medium),
            ),
          ),
        ),
      ),
    );
  }
}