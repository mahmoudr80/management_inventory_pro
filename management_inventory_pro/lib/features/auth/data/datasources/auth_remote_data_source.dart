import '../../../../core/logger/logger.dart';

import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/deep_link_constants.dart';
import '../mapping/auth_error_mapper.dart';
import '../models/auth_event_model.dart';
import '../models/auth_user_model.dart';

/// Responsible ONLY for talking to Supabase Auth. No business rules, no
/// state management, no UI concerns — that all lives in the repository /
/// cubit layers above this.
class AuthRemoteDataSource {
  SupabaseClient get _client => Supabase.instance.client;

  Future<ApiResult<AuthUserModel>> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      final session = response.session;

      if (user == null || session == null) {
        return ApiResult.failure(
          ApiErrorModel(message: 'Incorrect email or password. Please try again.'),
        );
      }
      return ApiResult.success(AuthUserModel.fromSupabaseUser(user));
    } on AuthException catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    }
  }

  /// Returns the created [AuthUserModel] on success. Callers should check
  /// `isEmailVerified` / whether a session came back to decide if email
  /// verification is required before granting access.
  ///
  /// `emailRedirectTo` points the confirmation email's link at our single
  /// deep link callback instead of Supabase's default hosted page.
  Future<ApiResult<AuthUserModel>> signUp(
      String email,
      String password,
      String name,
      ) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: name.trim().isEmpty ? null : {'name': name.trim()},
        emailRedirectTo: DeepLinkConstants.authCallbackUrl,
      );
      final user = response.user;
      if (user == null) {
        return ApiResult.failure(
          ApiErrorModel(message: 'Unable to create account. Please try again.'),
        );
      }
      return ApiResult.success(AuthUserModel.fromSupabaseUser(user));
    } on AuthException catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    }
  }

  Future<ApiResult<void>> forgotPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: DeepLinkConstants.authCallbackUrl,
      );
      return const Success(null);
    } on AuthException catch (e) {
      print("forget password ======================");
      print(e.toString());
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));

    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    }
  }

  Future<ApiResult<void>> resendVerification(String email) async {
    try {
      await _client.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: DeepLinkConstants.authCallbackUrl,
      );
      return const Success(null);
    } on AuthException catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    }
  }

  Future<ApiResult<void>> logout() async {
    try {
      await _client.auth.signOut();
      return const Success(null);
    } on AuthException catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    }
  }

  /// Exchanges an incoming deep link (from the verification or
  /// password-recovery email) for a live Supabase session. Only reports
  /// failure here (expired/invalid link); on success, the *kind* of link
  /// (recovery vs. verification) is communicated separately via
  /// [authEvents] — Supabase fires `passwordRecovery` or `signedIn`
  /// accordingly, based on the `type` parameter embedded in the link.
  Future<ApiResult<AuthUserModel>> exchangeDeepLink(Uri uri) async {
   await DebugLogger.log("========== EXCHANGE ==========");
   await DebugLogger.log("URI: $uri");
   await DebugLogger.log("scheme = ${uri.scheme}");
   await DebugLogger.log("host = ${uri.host}");
   await DebugLogger.log("path = ${uri.path}");
   await DebugLogger.log("query = ${uri.query}");
   await DebugLogger.log("queryParameters = ${uri.queryParameters}");
   await DebugLogger.log("fragment = ${uri.fragment}");

    try {
      final response = await _client.auth.getSessionFromUrl(uri);

      await DebugLogger.log("getSessionFromUrl SUCCESS");

      return ApiResult.success(
        AuthUserModel.fromSupabaseUser(response.session.user),
      );
    } on AuthException catch (e) {
     await DebugLogger.log("getSessionFromUrl ERROR");
     await DebugLogger.log(e.toString());

      return ApiResult.failure(
        ApiErrorModel(message: AuthErrorMapper.map(e)),
      );
    }
  }
  /// Sets a new password on the currently-recovered session (the one
  /// established moments earlier by [exchangeDeepLink]).
  Future<ApiResult<void>> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      return const Success(null);
    } on AuthException catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: AuthErrorMapper.map(e)));
    }
  }

  /// Synchronous read of whoever Supabase currently has cached in memory
  /// (restored automatically from its persisted session on app start).
  AuthUserModel? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AuthUserModel.fromSupabaseUser(user);
  }

  bool isLoggedIn() => _client.auth.currentSession != null;

  /// Emits every Supabase auth event (sign in, sign out, token refresh,
  /// password recovery, user update, session recovery), mapped to our own
  /// [DomainAuthEvent] vocabulary. Supersedes the previous
  /// user-only-diff stream — the cubit needs the *event kind*, not just
  /// the before/after user, to tell a recovery link from a normal sign-in.
  Stream<AuthEventModel> authEvents() {
    return _client.auth.onAuthStateChange.map((data) {
      DebugLogger.log("========== AUTH EVENT ==========");
      DebugLogger.log("Event: ${data.event}");
      DebugLogger.log("Has Session: ${data.session != null}");
      DebugLogger.log("User: ${data.session?.user.email}");
      DebugLogger.log("Email Verified: ${data.session?.user.emailConfirmedAt != null}");

      final user = data.session?.user;

      return AuthEventModel(
        event: _mapEvent(data.event),
        user: user != null
            ? AuthUserModel.fromSupabaseUser(user)
            : null,
      );
    });
  }
  DomainAuthEvent _mapEvent(AuthChangeEvent event) {
    switch (event) {
      case AuthChangeEvent.signedIn:
        return DomainAuthEvent.signedIn;
      case AuthChangeEvent.passwordRecovery:
        return DomainAuthEvent.passwordRecovery;
      case AuthChangeEvent.userUpdated:
        return DomainAuthEvent.userUpdated;
      case AuthChangeEvent.signedOut:
        return DomainAuthEvent.signedOut;
      case AuthChangeEvent.tokenRefreshed:
        return DomainAuthEvent.tokenRefreshed;
      case AuthChangeEvent.initialSession:
        return DomainAuthEvent.initialSession;
      default:
        return DomainAuthEvent.unknown;
    }
  }
}