import 'package:supabase_flutter/supabase_flutter.dart';

/// Converts Supabase's raw [AuthException]s (and generic failures) into
/// user-facing, friendly strings. Kept as its own class — rather than
/// inlined in the datasource — so AuthRemoteDataSource stays focused on
/// "talk to Supabase" and this stays focused on "translate errors".
class AuthErrorMapper {
  AuthErrorMapper._();

  static String map(Object error) {
    if (error is AuthException) {
      return _mapAuthException(error);
    }
    return 'Something went wrong. Please try again.';
  }

  static String _mapAuthException(AuthException e) {
    final code = e.code ?? '';
    final message = e.message.toLowerCase();

    // Prefer Supabase's stable error codes when present; fall back to
    // message sniffing for older client versions that don't set `code`.
    switch (code) {
      case 'invalid_credentials':
        return 'Incorrect email or password. Please try again.';
      case 'user_already_exists':
      case 'user_already_registered':
        return 'An account with this email already exists.';
      case 'email_not_confirmed':
        return 'Please verify your email before signing in.';
      case 'weak_password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'over_email_send_rate_limit':
      case 'over_request_rate_limit':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'user_not_found':
        return 'No account found with this email.';
      case 'same_password':
        return 'New password must be different from your current password.';
      case 'invalid_email':
        return 'Please enter a valid email address.';
    }

    if (message.contains('invalid login credentials')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (message.contains('already registered') ||
        message.contains('already exists')) {
      return 'An account with this email already exists.';
    }
    if (message.contains('email not confirmed')) {
      return 'Please verify your email before signing in.';
    }
    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    if (message.contains('network') || message.contains('socket')) {
      return 'Network error. Please check your connection and try again.';
    }

    // Never surface the raw Supabase string to the user.
    return 'Authentication failed. Please try again.';
  }
}
