import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/pos/presentation/widgets/cart/payment_buttons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../sale_history/data/models/sale_item_model.dart';
import '../../../data/models/cart_item.dart';
import 'cart_item_row.dart';
import 'complete_sale_button.dart';
import 'customer_card.dart';
import 'order_summary.dart';

class CartPanel extends StatelessWidget {
  final List<CartItemModel> items;
  final PaymentMethod? selectedPayment;
  final ValueChanged<PaymentMethod> onSelectPayment;
  final void Function(CartItemModel) onIncrement;
  final void Function(CartItemModel) onDecrement;
  final void Function(CartItemModel) onRemove;
  final VoidCallback? onEditCustomer;
  final VoidCallback? onSplitPay;
  final VoidCallback? onPrint;
  final String customerName;
  final VoidCallback onCompleteSale;

  const CartPanel({
    super.key,
    required this.items,
    required this.selectedPayment,
    required this.onSelectPayment,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onCompleteSale,
    this.onEditCustomer,
    this.onSplitPay,
    this.onPrint,
    this.customerName = 'Guest Customer',
  });

  static const double _taxRate = 0.085;

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get total => subtotal + (subtotal * _taxRate);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      color: AppColors.posCartBg,
      child: Column(
        children: [
          CustomerCard(customerName: customerName, onEdit: onEditCustomer),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text('ITEM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.posTextMuted, letterSpacing: 0.5)),
                ),
                SizedBox(
                  width: 96,
                  child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.posTextMuted, letterSpacing: 0.5)),
                ),
                SizedBox(
                  width: 70,
                  child: Text('PRICE', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.posTextMuted, letterSpacing: 0.5)),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Cart is empty. Tap a product to add it.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.posTextMuted, fontSize: 13),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.posBorder),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemRow(
                        item: item,
                        onIncrement: () => onIncrement(item),
                        onDecrement: () => onDecrement(item),
                        onRemove: () => onRemove(item),
                      );
                    },
                  ),
          ),
          OrderSummary(subtotal: subtotal),
          PaymentButtons(
            selected: selectedPayment,
            onSelect: onSelectPayment,
            onSplitPay: onSplitPay,
            onPrint: onPrint,
          ),
          // Primary checkout CTA — directly below the payment method section,
          // the single most prominent action in the cart panel.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: CompleteSaleButton(
              totalAmount: total,
              itemCount: itemCount,
              customerName: customerName,
              paymentMethod: selectedPayment,
              isEnabled: items.isNotEmpty,
              onConfirm: onCompleteSale,
            ),
          ),
        ],
      ),
    );
  }
}
