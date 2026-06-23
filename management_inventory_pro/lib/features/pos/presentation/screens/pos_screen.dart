import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/dependency_injection/service_locator.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:management_inventory_pro/features/product/presentation/products/cubit/product_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/pos_product.dart';
import '../cubit/pos_cubit.dart';
import '../cubit/pos_state.dart';
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
  String? _lastTappedId;
  PaymentMethod? _payment = PaymentMethod.cash;

  Future<void> _addToCart(PosProduct product) async {
    if (product.outOfStock) return;
    await context.read<PosCubit>().addToCart(product);
  }

  void _viewBestSellers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening best sellers report...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _viewAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening sales analytics...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _increment(CartItemModel item) async {
    await context.read<PosCubit>().increaseQuantity(item.product.id);
  }

  Future<void> _decrement(CartItemModel item) async {

    await context.read<PosCubit>().decreaseQuantity(item.product.id);

  }

  Future<void> _remove(CartItemModel item) async {
    await context.read<PosCubit>().removeItem(item.product.id);

  }

  Future<void> _completeSale() async {
    await context.read<PosCubit>().completeSale();

    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sale completed successfully'),
          backgroundColor: AppColors.posSuccess,
          duration: Duration(seconds: 2),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PosSearchBar(onChanged: (query) => context.read<PosCubit>().searchProducts(query)),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocProvider(
                    create: (context) =>
                        ProductCubit(getIt<ProductRepository>())..getProducts(),
                    child: ProductGrid(
                      selectedId: _lastTappedId,
                      onProductTap:(product) async =>  await _addToCart(product),
                      onViewAnalytics: _viewAnalytics,
                      onViewBestSellers: _viewBestSellers,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(width: 1, color: AppColors.posBorder),
        BlocBuilder<PosCubit,PosState>(
  builder: (context, state) {
    return CartPanel(
          items: state.cart?.items??[],
          selectedPayment: _payment,
          onSelectPayment: (m) => setState(() => _payment = m as PaymentMethod),
          onIncrement: (item) async =>await _increment(item),
          onDecrement:(item) async => await _decrement(item),
          onRemove:(item) async => await _remove(item) ,
          onEditCustomer: () {},
          onSplitPay: () {},
          onPrint: () {},
          onCompleteSale: _completeSale,
        );
  },
),
      ],
    );
  }
}
