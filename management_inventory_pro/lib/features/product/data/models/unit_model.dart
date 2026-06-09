// lib/features/products/data/models/unit_model.dart

class UnitModel {
  final String id;
  final String name;

  UnitModel({required this.id, required this.name});

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
