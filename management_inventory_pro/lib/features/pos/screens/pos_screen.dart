import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../mock/mock_products.dart';
import '../models/cart_item.dart';
import '../models/pos_product.dart';
import '../widgets/cart/cart_panel.dart';
import '../widgets/cart/payment_buttons.dart';
import '../widgets/pos_search_bar.dart';
import '../widgets/products/product_grid.dart';


class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final List<PosProduct> _allProducts = MockProducts.products;
  final List<CartItem> _cart = [];
  String _query = '';
  String? _lastTappedId;
  PaymentMethod? _payment = PaymentMethod.cash;

  List<PosProduct> get _filteredProducts {
    if (_query.trim().isEmpty) return _allProducts;
    final q = _query.toLowerCase();
    return _allProducts.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  void _addToCart(PosProduct product) {
    if (product.outOfStock) return;
    setState(() {
      _lastTappedId = product.id;
      final existing = _cart.where((c) => c.product.id == product.id).toList();
      if (existing.isNotEmpty) {
        existing.first.quantity += 1;
      } else {
        _cart.add(CartItem(product: product, variant: product.category));
      }
    });
  }

  void _viewBestSellers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening best sellers report...'), duration: Duration(seconds: 1)),
    );
  }
  void _viewAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening sales analytics...'), duration: Duration(seconds: 1)),
    );
  }

  void _increment(CartItem item) {
    setState(() => item.quantity += 1);
  }

  void _decrement(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity -= 1;
      } else {
        _cart.remove(item);
      }
    });
  }

  void _remove(CartItem item) {
    setState(() => _cart.remove(item));
  }

  // Mock implementation: clears the cart, resets the payment method, and
  // returns the screen to its empty POS state, ready for the next customer.
  void _completeSale() {
    setState(() {
      _cart.clear();
      _payment = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sale completed successfully'),
        backgroundColor: AppColors.posSuccess,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
       // const PosSidebar(activeLabel: 'POS'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PosSearchBar(
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ProductGrid(
                    products: _filteredProducts,
                    selectedId: _lastTappedId,
                    onProductTap: _addToCart,
                    onViewAnalytics: _viewAnalytics,
                    onViewBestSellers: _viewBestSellers,

                  ),
                ),
              ],
            ),
          ),
        ),
        Container(width: 1, color: AppColors.posBorder),
        CartPanel(
          items: _cart,
          selectedPayment: _payment,
          onSelectPayment: (m) => setState(() => _payment = m as PaymentMethod),
          onIncrement: _increment,
          onDecrement: _decrement,
          onRemove: _remove,
          onEditCustomer: () {},
          onSplitPay: () {},
          onPrint: () {},
          onCompleteSale: _completeSale,
        ),
      ],
    );
  }
}
