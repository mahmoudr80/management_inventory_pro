import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/datasource/stock_entry_datasource.dart';

import '../models/stock_entry_filter.dart';
import '../models/stock_entry_model.dart';
import '../models/stock_entry_summary.dart';

 class StockEntryRepository {
   final StockEntryDatasource _datasource;

   const StockEntryRepository(this._datasource);

   /// Load a page of entries matching [filter].
  Future<ApiResult<List<StockEntryModel>>> getEntries({
    StockEntryFilter? filter,
  }) async {
   return await _datasource.getEntries(filter: filter);
  }

  Future<int> countEntries({StockEntryFilter? filter}){
    throw Exception();
  }

  Future<StockEntryModel?> getEntryById(String id){
    throw Exception();
  }

  /// Validate + persist a new receipt. Returns the saved model.
   Future<ApiResult> addEntry(StockEntryModel entry) async {
   return await _datasource.insertEntry(entry);
  }

  /// Update an existing receipt (only allowed while status == pending).
  Future<ApiResult> updateEntry(StockEntryModel entry) async {
    return await _datasource.updateEntry(entry);
  }

  /// Delete a receipt by [id].
  Future<ApiResult> deleteEntry(String id) async {
    return await _datasource.deleteEntry(id);
  }

  /// Fetch aggregated KPI stats.
  Future<StockEntrySummary> getSummary(){
    throw Exception();
  }

  /// Returns the next auto-generated receipt ID.
  Future<String> generateReceiptId(){
    throw Exception();
  }
}
