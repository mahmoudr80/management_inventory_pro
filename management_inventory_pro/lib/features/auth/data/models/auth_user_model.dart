import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Supabase-facing user. Deliberately minimal — id/email/verification
/// status only. Business/profile data (name, avatar, preferences) lives
/// in the separate local `User` model (local_user_model.dart) and is
/// never merged into this one.
class AuthUserModel {
  final String id;
  final String email;
  final String? name;
  final DateTime? emailConfirmedAt;

  AuthUserModel({
    required this.id,
    required this.email,
    this.name,
    this.emailConfirmedAt,
  });

  /// True once Supabase has recorded a confirmed email timestamp.
  bool get isEmailVerified => emailConfirmedAt != null;

  factory AuthUserModel.fromSupabaseUser(supabase.User user) {
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String?,
      emailConfirmedAt: user.emailConfirmedAt != null
          ? DateTime.tryParse(user.emailConfirmedAt!)
          : null,
    );
  }

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      emailConfirmedAt: json['emailConfirmedAt'] != null
          ? DateTime.tryParse(json['emailConfirmedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'emailConfirmedAt': emailConfirmedAt?.toIso8601String(),
    };
  }
}
