import 'package:management_inventory_pro/core/database/database_constants.dart';

class UnitModel {
  final String id;
  final String name;
  final String symbol;

  UnitModel({required this.id, required this.name, required this.symbol});

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        id: json[DatabaseConstants.idColumn] as String,
        name: json[DatabaseConstants.nameColumn] as String,
        symbol: json[DatabaseConstants.symbolColumn] as String,
      );

  Map<String, dynamic> toJson() => {DatabaseConstants.idColumn: id,
    DatabaseConstants.nameColumn: name,DatabaseConstants.symbolColumn:symbol};
}
