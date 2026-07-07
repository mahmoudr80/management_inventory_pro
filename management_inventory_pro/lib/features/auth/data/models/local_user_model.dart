import 'package:hive/hive.dart';

/// A registered profile: a name plus a path to a locally-saved image.
class User {
  final String name;
  final String imagePath;
  final DateTime createdAt;

  User({
    required this.name,
    required this.imagePath,
    required this.createdAt,
  });

  User copyWith({String? name, String? imagePath, DateTime? createdAt}) {
    return User(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'User(name: $name, imagePath: $imagePath)';
}

/// Manual Hive adapter for [User] — no build_runner/code-gen required.
///
/// typeId 0 is reserved for User; if you add more Hive models later,
/// give each a unique typeId (1, 2, 3, ...).
class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      name: fields[0] as String,
      imagePath: fields[1] as String,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(3) // number of fields
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.createdAt);
  }
}
