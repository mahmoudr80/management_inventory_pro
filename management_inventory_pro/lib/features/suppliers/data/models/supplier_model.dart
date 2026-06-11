class SupplierModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupplierModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
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
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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
