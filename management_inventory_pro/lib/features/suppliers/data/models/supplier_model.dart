import 'package:management_inventory_pro/core/database/database_constants.dart';

class SupplierModel {
  final String id;
  final String companyName;
  final String phone;
  final String email;
  final String address;
  final String? note;
  final DateTime? createdAt;
  final DateTime ?updatedAt;

  const SupplierModel({
    required this.id,
    required this.companyName,
    required this.phone,
    required this.email,
    required this.address,
    this.note,
     this.createdAt,
     this.updatedAt,
  });

  SupplierModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      companyName: name ?? companyName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      note: notes ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json[DatabaseConstants.idColumn] as String,
      companyName: json[DatabaseConstants.companyNameColumn] as String,
      phone: json[DatabaseConstants.phoneColumn] as String,
      email: json[DatabaseConstants.emailColumn] as String,
      address: json[DatabaseConstants.addressColumn] as String,
      note: json[DatabaseConstants.noteColumn] as String?,
      createdAt: DateTime.parse(json[DatabaseConstants.createdAtColumn] as String),
      updatedAt: DateTime.parse(json[DatabaseConstants.updatedAtColumn] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      DatabaseConstants.idColumn: id,
      DatabaseConstants.companyNameColumn: companyName,
      DatabaseConstants.phoneColumn: phone,
      DatabaseConstants.emailColumn: email,
      DatabaseConstants.addressColumn: address,
      DatabaseConstants.noteColumn: note,
      DatabaseConstants.createdAtColumn: createdAt?.toIso8601String()??DateTime.now().toString(),
      DatabaseConstants.updatedAtColumn: updatedAt?.toIso8601String()??DateTime.now().toString(),
    };
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplierModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
