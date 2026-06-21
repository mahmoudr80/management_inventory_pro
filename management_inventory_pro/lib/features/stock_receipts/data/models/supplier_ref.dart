import 'package:management_inventory_pro/features/suppliers/data/models/supplier_model.dart';

import '../../../../core/database/database_constants.dart';

class SupplierRef {
  final String ?id;
  final String ?name;

  const SupplierRef({required this.id, required this.name});

  factory SupplierRef.fromMap(Map<String,dynamic>map){
    return SupplierRef(
      id: map[DatabaseConstants.supplierIdColumn] as String?,
      name: map[DatabaseConstants.companyNameColumn ] as String?,
    );
  }
  factory SupplierRef.fromSupplierModel(SupplierModel supplier){
    return SupplierRef(
      id: supplier.id,
      name: supplier.companyName,
    );
  }
   Map<String,String?> toMap(){
    return {
      'supplier_id': id,
      'supplier_name': name,
    };
  }
}