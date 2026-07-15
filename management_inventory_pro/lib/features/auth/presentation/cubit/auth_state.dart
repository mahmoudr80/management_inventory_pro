import 'package:flutter/foundation.dart';
import '../../data/models/auth_user_model.dart';

@immutable
abstract class AuthState {}

/// Nothing has happened yet — before the initial session check runs.
class AuthInitial extends AuthState {}

/// Any in-flight auth operation: initial session check, sign in, sign
/// up, logout, forgot-password, resend-verification, deep link exchange,
/// password update.
class AuthLoading extends AuthState {}

/// A confirmed, signed-in Supabase user.
class Authenticated extends AuthState {
  final AuthUserModel user;
  Authenticated({required this.user});
}

/// No active Supabase session. Also the terminal state after logout.
class Unauthenticated extends AuthState {}

/// Sign-up succeeded but the account still needs email confirmation
/// before the app can grant access to protected features.
class EmailVerificationRequired extends AuthState {
  final String email;
  EmailVerificationRequired({required this.email});
}

/// A password-reset email was sent successfully.
class ForgotPasswordSent extends AuthState {
  final String email;
  ForgotPasswordSent({required this.email});
}

/// The password-recovery deep link was opened and Supabase confirmed it —
/// the app should show the "set a new password" screen regardless of
/// whatever screen currently happens to be on top. `email` is best-effort
/// (Supabase includes the user on this event) and may be null.
class PasswordRecovery extends AuthState {
  final String? email;
  PasswordRecovery({this.email});
}

/// `updateUser(password: ...)` succeeded. Terminal state for the Reset
/// Password screen — it should show success and route back to Login.
class PasswordUpdated extends AuthState {}

/// Named `AuthError` (not `Error`) to avoid colliding with dart:core's
/// built-in `Error` type. Always carries an already-friendly message —
/// never a raw exception string.
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
