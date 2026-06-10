
import 'package:management_inventory_pro/core/database/database_constants.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? createdAt;

  CategoryModel({required this.id, required this.name,  this.createdAt});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json[DatabaseConstants.idColumn] as int,
    name: json[DatabaseConstants.nameColumn] as String,
    createdAt: json[DatabaseConstants.createdAtColumn]as String,
  );

  Map<String, dynamic> toJson() => {DatabaseConstants.idColumn: id,
    DatabaseConstants.nameColumn: name,DatabaseConstants.createdAtColumn:createdAt??DateTime.now().toString()};
}
