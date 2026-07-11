import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import '../../../product/presentation/products/cubit/product_cubit.dart';
import '../theme/pos_theme_extension.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../sale_history/data/models/sale_item_model.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/pos_product.dart';
import '../cubit/pos_cubit.dart';
import '../cubit/pos_state.dart';
import '../widgets/cart/cart_panel.dart';
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
  bool _isCartVisible = true;
  bool _isAnalyticsVisible = true;
  ScrollController controller = ScrollController();

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

    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Sale completed successfully'),
    //       backgroundColor: AppColors.posSuccess,
    //       duration: Duration(seconds: 2),
    //     ),
    //   );
  }


  @override
  Widget build(BuildContext context) {
    // Layer PosThemeColors on top of the app's active theme (light/dark/
    // system) without core ever knowing this feature exists.
    final baseTheme = Theme.of(context);
    final themeWithPosColors = baseTheme.copyWith(
      extensions: {
        ...baseTheme.extensions.values,
        posColorsFor(baseTheme.brightness),
      },
    );

    return Theme(
      data: themeWithPosColors,
      child: BlocConsumer<PosCubit,PosState>(
        listenWhen: (previous, current) {
          return previous.status != current.status ||
              previous.actionStatus != current.actionStatus;
        },
        listener: (context, state) {
          if(state.actionStatus==ActionStatus.completeSale&&state.status==PosStatus.success){
            AppSnackBar.showSuccess(context, message: 'Sale completed successfully');
            context.read<ProductCubit>().getProducts();
          }else if(state.actionStatus==ActionStatus.completeSale&&state.status==PosStatus.failure){
            AppSnackBar.showError(context, message:'Unable to complete this sale. check your stock');
          }
        },
        builder:(context, state) =>  Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.pagePadding,horizontal:AppSpacing.sm ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: PosSearchBar(onChanged: (query) =>
                              context.read<PosCubit>().searchProducts(query)),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            _isAnalyticsVisible = !_isAnalyticsVisible;
                            if (_isAnalyticsVisible) _isCartVisible = false;
                          }),
                          icon: Icon(_isAnalyticsVisible ? Icons.insights : Icons.insights_outlined),
                          tooltip: 'Toggle Analytics',
                          color: context.posColors.primary,
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            _isCartVisible = !_isCartVisible;
                            if (_isCartVisible) _isAnalyticsVisible = false;
                          }),
                          icon: Icon(_isCartVisible ? Icons.shopping_cart : Icons.shopping_cart_outlined),
                          tooltip: 'Toggle Cart',
                          color: context.posColors.primary,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ProductGrid(
                        selectedId: _lastTappedId,
                        showAnalytics: _isAnalyticsVisible,
                        showCart: _isCartVisible,
                        onProductTap: (product) async =>
                        await _addToCart(product),
                        onViewAnalytics: _viewAnalytics,
                        onViewBestSellers: _viewBestSellers,
                        controller: controller,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isCartVisible) ...[
              Container(width: 1, color: context.posColors.border),
              BlocBuilder<PosCubit, PosState>(
                builder: (context, state) {
                  return BlocBuilder<PosCubit, PosState>(
                    builder: (context, state) {
                      return CartPanel(
                        items: state.cart?.items ?? [],
                        totals: state.totals,
                        selectedPayment: _payment,
                        onSelectPayment: (m) =>
                            setState(() => _payment = m as PaymentMethod),
                        onIncrement: (item) async => await _increment(item),
                        onDecrement: (item) async => await _decrement(item),
                        onRemove: (item) async => await _remove(item),
                        onEditCustomer: () {},
                        onSplitPay: () {},
                        onPrint: () {},
                        onCompleteSale: _completeSale,
                      );
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}