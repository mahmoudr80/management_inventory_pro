import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:sqflite/sqflite.dart';
import '../models/sale_item_model.dart';
import '../models/sale_model.dart';

class SaleHistoryDatasource {
  final Database _database;

  const SaleHistoryDatasource(this._database);

  Future<ApiResult> getSales() async {
    try {
      final rows = await _database.rawQuery('''
SELECT
    s.${DatabaseConstants.idColumn} AS ${DatabaseConstants.saleIdColumn},
    s.${DatabaseConstants.totalItemColumn},
    s.${DatabaseConstants.totalQuantityColumn},
    s.${DatabaseConstants.subtotalColumn},
    s.${DatabaseConstants.discountAmountColumn},
    s.${DatabaseConstants.taxEnabledColumn},
    s.${DatabaseConstants.taxPercentageColumn},
    s.${DatabaseConstants.taxAmountColumn},
    s.${DatabaseConstants.totalAmountColumn},
    s.${DatabaseConstants.noteColumn},
    s.${DatabaseConstants.createdAtColumn},
    s.${DatabaseConstants.updatedAtColumn},
    s.${DatabaseConstants.paymentMethodColumn},
    s.${DatabaseConstants.cashierNameColumn},
    s.${DatabaseConstants.statusColumn},

    si.id AS ${DatabaseConstants.saleItemId},
    si.${DatabaseConstants.productIdColumn},
    si.${DatabaseConstants.quantityColumn},
    si.${DatabaseConstants.sellingPriceColumn},
    si.${DatabaseConstants.totalColumn},
    si.${DatabaseConstants.costPriceAtSaleColumn},

    p.${DatabaseConstants.nameColumn},
    p.${DatabaseConstants.skuColumn},
    p.${DatabaseConstants.barcodeColumn},
    p.${DatabaseConstants.imageUrlColumn},
    p.${DatabaseConstants.sellingPriceColumn} AS ${DatabaseConstants.productPrice},
    p.${DatabaseConstants.costPriceColumn} AS ${DatabaseConstants.productCostPrice}

FROM ${DatabaseConstants.saleTable} s

INNER JOIN ${DatabaseConstants.saleItemTable} si
    ON si.${DatabaseConstants.saleIdColumn} = s.${DatabaseConstants.idColumn}

INNER JOIN ${DatabaseConstants.productTable} p
    ON p.${DatabaseConstants.idColumn} = si.${DatabaseConstants.productIdColumn}

ORDER BY s.${DatabaseConstants.createdAtColumn} DESC
''');
      final Map<String, SaleModel> salesMap = {};

      for (final row in rows) {
        final saleId = row['sale_id'] as String;

        final item = SaleItemModel.fromMap(row);

        if (!salesMap.containsKey(saleId)) {
          salesMap[saleId] = SaleModel.fromMap(map: row, saleId: saleId);
        }
        salesMap[saleId]!.items.add(item);
      }

      return ApiResult.success(salesMap.values.toList());
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }
}
