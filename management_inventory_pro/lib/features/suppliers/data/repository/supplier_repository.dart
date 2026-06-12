import 'package:management_inventory_pro/features/suppliers/data/datasource/supplier_datasource.dart';

import '../../../../core/networking/api_result.dart';
import '../models/supplier_model.dart';

class SupplierRepository {
  final SupplierLocalDatasource _datasource;

  const SupplierRepository(this._datasource);

  Future <ApiResult>getSuppliers() async{
    return await _datasource.getSuppliers();
  }
  Future <ApiResult>addSupplier(SupplierModel supplier) async{
    return await _datasource.addSupplier(supplier);
  }
  Future <ApiResult>updateSupplier(SupplierModel supplier) async{
    return await _datasource.updateSupplier(supplier);
  }
  Future <ApiResult>deleteSupplier(String id) async{
    return await _datasource.deleteSupplier(id);
  }
}