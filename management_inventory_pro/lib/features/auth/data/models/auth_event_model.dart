import 'auth_user_model.dart';

/// Mirrors Supabase's `AuthChangeEvent`, translated into our own domain
/// vocabulary. Kept separate from the raw Supabase enum for the same
/// reason [AuthUserModel] exists instead of passing `supabase.User`
/// around: nothing above the datasource should import `supabase_flutter`.
enum DomainAuthEvent {
  signedIn,
  passwordRecovery,
  userUpdated,
  signedOut,
  tokenRefreshed,
  initialSession,
  unknown,
}

class AuthEventModel {
  final DomainAuthEvent event;
  final AuthUserModel? user;

  const AuthEventModel({required this.event, this.user});
}
