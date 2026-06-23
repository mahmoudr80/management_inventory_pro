import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/cart_item.dart';

class CartItemRow extends StatefulWidget {
  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemRow({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  State<CartItemRow> createState() => _CartItemRowState();
}

class _CartItemRowState extends State<CartItemRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.posSurface : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.posTextPrimary,
                    ),
                  ),
                  if (item.variant.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.variant,
                      style: const TextStyle(fontSize: 12, color: AppColors.posTextMuted),
                    ),
                  ],
                  // if (_hovered) ...[
                  //   const SizedBox(height: 6),
                  //   GestureDetector(
                  //     onTap: widget.onRemove,
                  //     child: const Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(Icons.delete_outline_rounded, size: 14, color: AppColors.error),
                  //         SizedBox(width: 4),
                  //         Text(
                  //           'Remove',
                  //           style: TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                  const SizedBox(height: 6),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 120),
                    opacity: _hovered ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !_hovered,
                      child: GestureDetector(
                        onTap: widget.onRemove,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 14,
                              color: AppColors.posError,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Remove',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.posError,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 96,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _QtyButton(icon: Icons.remove, onTap: widget.onDecrement),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                  _QtyButton(icon: Icons.add, onTap: widget.onIncrement),
                ],
              ),
            ),
            SizedBox(
              width: 70,
              child: Text(
                '\$${item.lineTotal.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.posTextPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.posBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: AppColors.posTextPrimary),
      ),
    );
  }
}
