import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/suppliers/data/models/supplier_model.dart';
import 'package:sqflite/sqflite.dart';

class SupplierLocalDatasource{
  final Database _database;
  SupplierLocalDatasource(this._database);

  Future <ApiResult>getSuppliers() async {
   try{
     String query = "SELECT * FROM ${DatabaseConstants.supplierTable} order by ${DatabaseConstants.createdAtColumn} desc;";
     List<Map<String, dynamic>> response = await _database.rawQuery(query);
     List<SupplierModel> suppliers= [];
       for (final Map<String, dynamic> element in response) {
         suppliers.add(SupplierModel.fromJson(element));
       }
     return ApiResult.success(suppliers);
   }catch(e){
     return ApiResult.failure(ApiErrorModel(message: e.toString()));
   }
  }
  Future <ApiResult>addSupplier(SupplierModel supplier) async {
    try{
      final supplierJson = supplier.toJson();
      String query = "SELECT * FROM ${DatabaseConstants.supplierTable} order by ${DatabaseConstants.createdAtColumn} desc;";
      final response = await _database.insert(DatabaseConstants.supplierTable, supplierJson);
      return ApiResult.success(response);
    }catch(e){
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }
  Future <ApiResult>updateSupplier(SupplierModel supplier) async {
    try{
      final supplierJson = supplier.toJson();
      final response = await _database.update(DatabaseConstants.supplierTable, supplierJson,
          where: "${DatabaseConstants.idColumn} =  ?",whereArgs: [supplier.id]);
      return ApiResult.success(response);
    }catch(e){
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }
  Future <ApiResult>deleteSupplier(String id) async {
    try{
      final response = await _database.delete(DatabaseConstants.supplierTable,
          where: "${DatabaseConstants.idColumn} =  ?",whereArgs: [id]);
      return ApiResult.success(response);
    }catch(e){
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }
}