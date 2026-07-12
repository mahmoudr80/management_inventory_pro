import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/features/pos/data/models/pos_product.dart';

enum PaymentMethod { cash, card, mixed }

enum SaleStatus { completed, refunded, cancelled }

class SaleItemModel {
  final String id;
  final PosProduct product;

  final int quantity;
  final double sellingPrice;

  const SaleItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.sellingPrice,
  });

  double get total => quantity * sellingPrice;

  factory SaleItemModel.fromMap(Map<String, Object?> map) {
    return SaleItemModel(
      id: map[DatabaseConstants.saleItemId] as String,
      quantity: (map[DatabaseConstants.quantityColumn] as num).toInt(),
      sellingPrice: (map[DatabaseConstants.sellingPriceColumn] as num)
          .toDouble(),
      product: PosProduct(
        id: map[DatabaseConstants.productIdColumn] as String,
        name: map[DatabaseConstants.nameColumn] as String,
        price: (map[DatabaseConstants.productPrice] as num).toDouble(),
        // Historical cost for this line: the snapshot taken at checkout
        // (see CartItemModel.toMap), falling back to the product's
        // current cost_price only for rows written before that column
        // existed. Same COALESCE contract as SalesReport/ProfitReport's
        // _costAgg and Dashboard's _getTopSellingProducts — kept
        // identical everywhere cost is read so no two screens disagree
        // on the fallback rule.
        costPrice:
            ((map[DatabaseConstants.costPriceAtSaleColumn] as num?) ??
                    (map[DatabaseConstants.productCostPrice] as num?) ??
                    0)
                .toDouble(),
        imageUrl: map[DatabaseConstants.imageUrlColumn] as String?,
        sku: map[DatabaseConstants.skuColumn] as String?,
        barcode: map[DatabaseConstants.barcodeColumn] as String?,
      ),
    );
  }
}
