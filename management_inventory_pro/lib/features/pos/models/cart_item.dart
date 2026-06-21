import 'pos_product.dart';

class CartItem {
  final PosProduct product;
  final String variant;
  int quantity;

  CartItem({
    required this.product,
    this.variant = '',
    this.quantity = 1,
  });

  double get lineTotal => product.price * quantity;
}
