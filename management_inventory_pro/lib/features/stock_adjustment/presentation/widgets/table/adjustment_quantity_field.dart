import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    if (widget.item.isNegativeInventory) return const Color(0xFFBA1A1A);
    if (widget.item.isOutOfStock) return const Color(0xFFBA1A1A);
    return const Color(0xFFC3C5D9);
  }

  Color get _textColor {
    final qty = widget.item.adjustmentQty;
    if (qty > 0) return const Color(0xFF0041C8);
    if (qty < 0) return const Color(0xFFBA1A1A);
    return const Color(0xFF131B2E);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 32.h,
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
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 5.sp,
          fontWeight: FontWeight.w700,
          color: _textColor,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.item.isNegativeInventory
              ? const Color(0xFFFFDAD6).withOpacity(0.3)
              : Colors.white,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(color: _borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(color: _borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(color: const Color(0xFF0041C8), width: 1.5),
          ),
        ),
      ),
    );
  }
}
