import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:sqflite/sqflite.dart';

import '../models/stock_entry_filter.dart';
import '../models/stock_entry_line_model.dart';
import '../models/stock_entry_model.dart';
import '../models/stock_entry_summary.dart';

class StockEntryDatasource {
  final Database _database;

  const StockEntryDatasource(this._database);

  Future<ApiResult<List<StockEntryModel>>> getEntries({StockEntryFilter? filter}) async {
    try {
      final query =
          """
      SELECT
    e.${DatabaseConstants.idColumn} AS ${DatabaseConstants.stockEntryIdColumn},
    e.${DatabaseConstants.supplierIdColumn},
    sup.company_name AS ${DatabaseConstants.companyNameColumn},
    e.${DatabaseConstants.receiptDateColumn},
    e.${DatabaseConstants.noteColumn},
    e.${DatabaseConstants.createdAtColumn},
    e.${DatabaseConstants.updatedAtColumn},
    e.${DatabaseConstants.totalItemColumn},
    e.${DatabaseConstants.totalItemColumn},
    e.${DatabaseConstants.totalCostColumn},

    l.${DatabaseConstants.idColumn} AS ${DatabaseConstants.lineIdAlias},
    l.${DatabaseConstants.productIdColumn},
    l.${DatabaseConstants.quantityColumn},
    l.${DatabaseConstants.costPriceColumn},

    p.${DatabaseConstants.nameColumn} AS ${DatabaseConstants.productNameAlias},
    p.${DatabaseConstants.skuColumn} ,
    p.${DatabaseConstants.unitIdColumn},

    u.${DatabaseConstants.nameColumn} AS ${DatabaseConstants.unitNameAlias}

FROM ${DatabaseConstants.stockEntryTable} e

INNER JOIN ${DatabaseConstants.supplierTable} sup
    ON sup.${DatabaseConstants.idColumn} = e.${DatabaseConstants.supplierIdColumn}

INNER JOIN ${DatabaseConstants.stockEntryItemTable} l
    ON l.${DatabaseConstants.stockEntryIdColumn} = e.${DatabaseConstants.idColumn}

INNER JOIN ${DatabaseConstants.productTable} p
    ON p.${DatabaseConstants.idColumn} = l.${DatabaseConstants.productIdColumn}

INNER JOIN ${DatabaseConstants.unitTable} u
    ON u.${DatabaseConstants.idColumn} = p.${DatabaseConstants.unitIdColumn}

ORDER BY e.${DatabaseConstants.receiptDateColumn} DESC;
      """;
      final rows = await _database.rawQuery(query);

      final Map<String, StockEntryModel> entries = {};

      for (final row in rows) {
        final entryId = row[DatabaseConstants.stockEntryIdColumn] as String;

        if (!entries.containsKey(entryId)) {
          entries[entryId] = StockEntryModel.fromMap(row);
        }
        entries[entryId]!.lines.add(StockEntryLineModel.fromMap(row));
      }

      final List<StockEntryModel> result = entries.values.toList();
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }

  /// Total count of entries matching the given filter (for pagination).
  Future<int> countEntries({StockEntryFilter? filter}) {
    throw Exception();
  }

  /// Fetch a single entry by its [id].
  Future<StockEntryModel?> getEntryById(String id) {
    throw Exception();
  }

  /// Persist a new stock entry. Returns the saved model (with generated id).
  Future<ApiResult> insertEntry(StockEntryModel entry) async {
   try{
     final entryResponse = await _database.insert(DatabaseConstants.stockEntryTable, entry.toMap());
     for(final line in entry.lines){
       if(line.product.id==null){
         print('product id not exist');
         continue;
       }
       await _database.insert(DatabaseConstants.stockEntryItemTable, {...line.toMap(),
         DatabaseConstants.stockEntryIdColumn:entry.id});
       await _database.rawUpdate(
         '''
  UPDATE ${DatabaseConstants.productTable}
  SET
    ${DatabaseConstants.currentStockColumn}
      = ${DatabaseConstants.currentStockColumn} + ?,
    ${DatabaseConstants.costPriceColumn} = ?,
    ${DatabaseConstants.updatedAtColumn} = ?
  WHERE ${DatabaseConstants.idColumn} = ?
  ''',
         [
           line.quantity,
           line.unitCost,
           DateTime.now().toIso8601String().split('.')
               .first
               .replaceFirst('T', ' ').toString(),
           line.product.id,
         ],
       );
     }
    return ApiResult.success(entryResponse);
   }catch(e){
     return ApiResult.failure(ApiErrorModel(message: e.toString()));
   }

  }

  /// Overwrite an existing entry.
  Future<ApiResult> updateEntry(StockEntryModel entry) async {
    try {
      await _database.transaction((txn) async {
        final oldLines = await _loadOldLines(id:  entry.id,txn:  txn);

        await _reverseOldStock(oldLines,txn);

        await _deleteOldLines(entry.id,txn);

        final now = DateTime.now()
            .toIso8601String()
            .split('.')
            .first
            .replaceFirst('T', ' ');

        await _updateEntryHeader(txn,entry,now);

        await _insertNewLines(txn,entry,now);
      });
      return ApiResult.success(true);
    } catch (e) {
      return ApiResult.failure(
        ApiErrorModel(message: e.toString()),
      );
    }
  }
  Future<List<Map<String, Object?>>>_loadOldLines({required String id, Transaction ?txn}) async {
    return await (txn??_database).query(
      DatabaseConstants.stockEntryItemTable,
      where: '${DatabaseConstants.stockEntryIdColumn} = ?',
      whereArgs: [id],
    );
}
  Future<void> _reverseOldStock(List<Map<String, Object?>>oldLines,Transaction txn) async {
    for (final oldLine in oldLines) {
      await txn.rawUpdate(
        '''
          UPDATE ${DatabaseConstants.productTable}
          SET
            ${DatabaseConstants.currentStockColumn}
              = ${DatabaseConstants.currentStockColumn} - ?
          WHERE ${DatabaseConstants.idColumn} = ?
          ''',
        [
          oldLine[DatabaseConstants.quantityColumn],
          oldLine[DatabaseConstants.productIdColumn],
        ],
      );
    }
  }
  Future<void>_deleteOldLines(String id,Transaction txn) async {
    await txn.delete(
      DatabaseConstants.stockEntryItemTable,
      where: '${DatabaseConstants.stockEntryIdColumn} = ?',
      whereArgs: [id],
    );
  }
  Future<void> _updateEntryHeader(Transaction txn,StockEntryModel entry,String now) async {
    await txn.update(
      DatabaseConstants.stockEntryTable,
      {
        DatabaseConstants.supplierIdColumn: entry.supplier.id,
        DatabaseConstants.noteColumn: entry.notes,
        DatabaseConstants.receiptDateColumn:
        entry.receiptDate.toString(),
        DatabaseConstants.totalItemColumn: entry.totalItems,
        DatabaseConstants.totalQuantityColumn: entry.totalQuantity,
        DatabaseConstants.totalCostColumn: entry.totalCost,
        DatabaseConstants.updatedAtColumn: now,
      },
      where: '${DatabaseConstants.idColumn} = ?',
      whereArgs: [entry.id],
    );
  }
  Future<void> _insertNewLines(Transaction txn,StockEntryModel entry,String now) async {
    for (final line in entry.lines) {
      if (line.product.id == null) continue;

      await txn.insert(
        DatabaseConstants.stockEntryItemTable,
        {
          ...line.toMap(),
          DatabaseConstants.stockEntryIdColumn: entry.id,
        },
      );

      // 6. Apply new stock impact
      await txn.rawUpdate(
        '''
          UPDATE ${DatabaseConstants.productTable}
          SET
            ${DatabaseConstants.currentStockColumn}
              = ${DatabaseConstants.currentStockColumn} + ?,
            ${DatabaseConstants.costPriceColumn} = ?,
            ${DatabaseConstants.updatedAtColumn} = ?
          WHERE ${DatabaseConstants.idColumn} = ?
          ''',
        [
          line.quantity,
          line.unitCost,
          now,
          line.product.id,
        ],
      );
    }
  }
  /// Soft-delete or hard-delete by [id].
  Future<ApiResult> deleteEntry(String stockEntryId) async {
    try {
      await _database.transaction((txn) async {
        final lines =await _loadOldLines(id: stockEntryId,txn: txn);
        // 2. Reverse stock impact
        await _reverseOldStock(lines, txn);
        // 3. Delete stock entry
        // stock_entry_items will be deleted automatically
        // because of ON DELETE CASCADE
        await txn.delete(
          DatabaseConstants.stockEntryTable,
          where: '${DatabaseConstants.idColumn} = ?',
          whereArgs: [stockEntryId],
        );
      });

      return ApiResult.success(true);
    } catch (e) {
      return ApiResult.failure(
        ApiErrorModel(
          message: e.toString(),
        ),
      );
    }
  }

  /// Compute summary statistics (KPI cards) for the current calendar month.
  Future<StockEntrySummary> getSummary() {
    throw Exception();
  }

  /// Generate the next receipt ID string (e.g. "REC-2024-0893").
  Future<String> generateReceiptId() {
    throw Exception();
  }
}
