import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/features/pos/data/models/pos_product.dart';
class CartItemModel {
  final String id;
  final PosProduct product;
  final String variant;
  int quantity;

  CartItemModel({
    required this.product,
    this.variant = '',
    this.quantity = 1, required this.id,
  });

  double get lineTotal => product.price * quantity;

  Map<String, Object?>toMap()=>
      {
        DatabaseConstants.idColumn:id,
        DatabaseConstants.productIdColumn:product.id,
        DatabaseConstants.sellingPriceColumn:product.price,
        DatabaseConstants.quantityColumn:quantity,
        DatabaseConstants.totalColumn:lineTotal

      };
}

class CartModel{
  final String id;
  final String ? note;
  final DateTime ? createdAt;
  final DateTime ? updatedAt;
  final List<CartItemModel>items;

  const CartModel({required this.id,
    this.note, this.createdAt, this.updatedAt, required this.items});

  int get totalItems => items.length;

  num get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  num get totalAmount =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);

  CartModel copyWith({int ? totalItems,num ? totalQuantity,num ? totalAmount,
    String ? note,DateTime ? createdAt,DateTime ? updatedAt, List<CartItemModel>?items
}){
    return CartModel(id: id, items: items??this.items,createdAt: createdAt??this.createdAt,note: note??this.note
    ,updatedAt: updatedAt??this.updatedAt);
  }

  Map<String, Object?>toMap()=>
      {
        DatabaseConstants.idColumn: id,
        DatabaseConstants.totalItemColumn:totalItems,
        DatabaseConstants.totalQuantityColumn:totalQuantity,
        DatabaseConstants.totalAmountColumn:totalAmount,
        DatabaseConstants.noteColumn:note,
        DatabaseConstants.createdAtColumn:(createdAt??DateTime.now()).toIso8601String()
            .split('.')
            .first
            .replaceFirst('T', ' ').toString(),
        DatabaseConstants.updatedAtColumn:(updatedAt??DateTime.now()).toIso8601String()
            .split('.')
            .first
            .replaceFirst('T', ' ').toString(),

      };


}