/// Single source of truth for the app's deep link callback.
///
/// Both email verification and password recovery use the SAME callback
/// URL, per spec — Supabase tells us which flow it is via the auth event
/// it fires (`signedIn` vs `passwordRecovery`) once the link is exchanged,
/// so we don't need — and shouldn't create — separate callback URLs.
class DeepLinkConstants {
  DeepLinkConstants._();

  static const String scheme = 'managementinventory';
  static const String host = 'auth';

  /// e.g. managementinventory://auth
  static const String authCallbackUrl = '$scheme://$host';
}
