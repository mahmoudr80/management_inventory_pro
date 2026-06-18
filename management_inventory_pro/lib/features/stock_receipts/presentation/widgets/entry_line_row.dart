import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/product_dropdown.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/product_ref.dart';
import '../../data/models/stock_entry_line_model.dart';

class EntryLineRow extends StatefulWidget {
  final int index;
  final StockEntryLineModel line;
  final ValueChanged<StockEntryLineModel> onChanged;
  final VoidCallback onRemove;

  const EntryLineRow({
    super.key,
    required this.index,
    required this.line,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<EntryLineRow> createState() => _EntryLineRowState();
}

class _EntryLineRowState extends State<EntryLineRow> {
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _costCtrl;

  ProductRef? _selectedProduct;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    // Seed the dropdown's selection from the existing line, if any.
    // Note: this only has a name/sku to go on (no product id), since
    // StockEntryLineModel doesn't carry one yet — see note below.
    _selectedProduct = widget.line.productName.isNotEmpty
        ? ProductRef(
            id: '',
            name: widget.line.productName,
            sku: widget.line.productSku,
          )
        : null;

    _qtyCtrl = TextEditingController(
      text: widget.line.quantity > 0 ? widget.line.quantity.toString() : '',
    );
    _costCtrl = TextEditingController(
      text: widget.line.unitCost > 0
          ? widget.line.unitCost.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _emit() {
    final qty  = int.tryParse(_qtyCtrl.text) ?? 0;
    final cost = double.tryParse(_costCtrl.text) ?? 0.0;
    widget.onChanged(
      widget.line.copyWith(
        productName: _selectedProduct?.name ?? '',
        productSku: _selectedProduct?.sku,
        quantity: qty,
        unitCost: cost,
      ),
    );
  }

  double get _lineTotal {
    final qty  = int.tryParse(_qtyCtrl.text) ?? 0;
    final cost = double.tryParse(_costCtrl.text) ?? 0.0;
    return qty * cost;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _hovering
            ? AppColors.surfaceContainerLow
            : AppColors.surfaceContainerLowest,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── # ─────────────────────────────────────────────────────────
            SizedBox(
              width: 32.w,
              child: Text(
                '${widget.index + 1}',
                style: AppTextStyles.bodySm
                    .copyWith(color: AppColors.outline),
              ),
            ),

            // ── Product Name / SKU ─────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductDropdown(
                    selected: _selectedProduct,
                    onChanged: (product) {
                      setState(() => _selectedProduct = product);
                      _emit();
                    },
                  ),
                  if (_selectedProduct?.sku != null) ...[
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.only(left: 14.w),
                      child: Text(
                        _selectedProduct!.sku!,
                        style: AppTextStyles.dataMono.copyWith(
                          fontSize: 11,
                          color: AppColors.outline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // ── Qty ────────────────────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Center(
                child: _NumericField(
                  controller: _qtyCtrl,
                  hint: '0',
                  allowDecimal: false,
                  onChanged: (_) => setState(_emit),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // ── Cost Price ─────────────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Center(
                child: _NumericField(
                  controller: _costCtrl,
                  hint: '0.00',
                  allowDecimal: true,
                  prefixText: '\$',
                  onChanged: (_) => setState(_emit),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // ── Line Total (read-only) ─────────────────────────────────────
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _lineTotal > 0
                      ? '\$${_lineTotal.toStringAsFixed(2)}'
                      : '—',
                  style: AppTextStyles.dataMono.copyWith(
                    color: _lineTotal > 0
                        ? AppColors.primary
                        : AppColors.outline,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),

            // ── Remove ────────────────────────────────────────────────────
            SizedBox(
              width: 40.w,
              child: Align(
                alignment: Alignment.centerRight,
                child: Tooltip(
                  message: 'Remove line',
                  child: InkWell(
                    onTap: widget.onRemove,
                    borderRadius: BorderRadius.circular(4.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.remove_circle_outline,
                        size: 16,
                        color: AppColors.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Inline numeric field ──────────────────────────────────────────────────────

class _NumericField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool allowDecimal;
  final String? prefixText;
  final ValueChanged<String>? onChanged;

  const _NumericField({
    required this.controller,
    required this.hint,
    required this.allowDecimal,
    this.prefixText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      keyboardType:
          TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp(r'[\d.]') : RegExp(r'\d'),
        ),
      ],
      style: AppTextStyles.dataMono,
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: AppTextStyles.dataMono.copyWith(
          color: AppColors.outline,
        ),
        hintStyle: AppTextStyles.dataMono.copyWith(color: AppColors.outline),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
    );
  }
}
