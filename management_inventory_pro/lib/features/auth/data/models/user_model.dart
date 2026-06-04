class UserModel {
  final String id;
  final String email;
  final String? name;

  UserModel({required this.id, required this.email, this.name});

  // Placeholder for fromJson
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }

  // Placeholder for toJson
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}
