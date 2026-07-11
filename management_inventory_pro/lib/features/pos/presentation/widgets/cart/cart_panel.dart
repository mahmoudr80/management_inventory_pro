import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/services/sale_calculator.dart';
import 'package:management_inventory_pro/features/pos/presentation/widgets/cart/payment_buttons.dart';
import '../../theme/pos_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../sale_history/data/models/sale_item_model.dart';
import '../../../data/models/cart_item.dart';
import 'cart_item_row.dart';
import 'complete_sale_button.dart';
import 'customer_card.dart';
import 'order_summary.dart';

class CartPanel extends StatelessWidget {
  final List<CartItemModel> items;

  /// Tax/discount breakdown for [items], already computed by
  /// `SaleCalculator` via `PosCubit`. This panel and everything inside it
  /// (`OrderSummary`, `CompleteSaleButton`) only ever display this — they
  /// never calculate tax themselves.
  final SaleTotals totals;

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
    required this.totals,
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

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isCompact(context) ? 320 : 420,
      color: context.posColors.cartBg,
      child: Column(
        children: [
          CustomerCard(customerName: customerName, onEdit: onEditCustomer),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding, vertical: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('ITEM', style: AppTextStyles.labelCaps.copyWith(color: context.posColors.textMuted)),
                ),
                SizedBox(
                  width: 96,
                  child: Text('QTY', textAlign: TextAlign.center, style: AppTextStyles.labelCaps.copyWith(color: context.posColors.textMuted)),
                ),
                SizedBox(
                  width: 70,
                  child: Text('PRICE', textAlign: TextAlign.right, style: AppTextStyles.labelCaps.copyWith(color: context.posColors.textMuted)),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                child: Text(
                  'Cart is empty. Tap a product to add it.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySm.copyWith(color: context.posColors.textMuted),
                ),
              ),
            )
                : ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: context.posColors.border),
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
          OrderSummary(totals: totals),
          PaymentButtons(
            selected: selectedPayment,
            onSelect: onSelectPayment,
            onSplitPay: onSplitPay,
            onPrint: onPrint,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.cardPadding, 0, AppSpacing.cardPadding, AppSpacing.cardPadding),
            child: CompleteSaleButton(
              totalAmount: totals.grandTotal,
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