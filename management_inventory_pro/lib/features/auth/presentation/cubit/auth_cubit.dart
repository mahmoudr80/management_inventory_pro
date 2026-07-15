import 'dart:async';
import '../../../../core/logger/logger.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import '../../data/models/auth_event_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  StreamSubscription<AuthEventModel>? _authEventSubscription;

  AuthCubit({required AuthRepository authRepository})
      : _repository = authRepository,
        super(AuthInitial()) {
    // Reacts to every auth event Supabase fires — including ones that
    // don't originate from an explicit call on this cubit, e.g. a
    // password-recovery or email-verification deep link being exchanged,
    // or a session getting invalidated on token-refresh failure. Guarded
    // per-event so it never fights with the explicit flows below.
    _authEventSubscription = _repository.authEvents().listen(_onAuthEvent);
  }

  void _onAuthEvent(AuthEventModel authEvent) async{
    await DebugLogger.log("========== _onAuthEvent ==========");
    await DebugLogger.log("Domain Event: ${authEvent.event}");
    await DebugLogger.log("User: ${authEvent.user?.email}");

    if (isClosed) {
      await DebugLogger.log("Cubit is closed");
      return;
    }

    switch (authEvent.event) {
      case DomainAuthEvent.passwordRecovery:
        await  DebugLogger.log("Emit PasswordRecovery");
        emit(PasswordRecovery(email: authEvent.user?.email));
        break;

      case DomainAuthEvent.signedIn:
        await DebugLogger.log("Received SignedIn");

        final user = authEvent.user;

        if (user == null) {
          await DebugLogger.log("User is null");
          return;
        }

        if (user.isEmailVerified) {
          await DebugLogger.log("Emit Authenticated");
          emit(Authenticated(user: user));
        } else {
          await DebugLogger.log("Emit EmailVerificationRequired");
          emit(EmailVerificationRequired(email: user.email));
        }
        break;

      case DomainAuthEvent.signedOut:
        await DebugLogger.log("Received SignedOut");

        if (state is Authenticated) {
          await DebugLogger.log("Emit Unauthenticated");
          emit(Unauthenticated());
        }
        break;

      case DomainAuthEvent.userUpdated:
        await DebugLogger.log("Received UserUpdated");
        break;

      case DomainAuthEvent.tokenRefreshed:
        await DebugLogger.log("Received TokenRefreshed");
        break;

      case DomainAuthEvent.initialSession:
        await DebugLogger.log("Received InitialSession");
        break;

      case DomainAuthEvent.unknown:
        await DebugLogger.log("Received Unknown");
        break;
    }
  }
  /// Call once at app start (from the auth gate / splash decision point).
  /// Restores whatever session Supabase already has persisted — no
  /// custom token storage, no splash loop: exactly one Loading emission
  /// followed by a terminal state.
  Future<void> checkSession() async {
    await DebugLogger.log("checkSession()");

    if (isClosed) {
      await DebugLogger.log("Cubit closed");
      return;
    }

    emit(AuthLoading());
    await DebugLogger.log("Emit AuthLoading");

    if (!_repository.isLoggedIn()) {
      await DebugLogger.log("Repository: not logged in");

      if (isClosed) {
        await DebugLogger.log("Cubit closed");
        return;
      }

      emit(Unauthenticated());
      await DebugLogger.log("Emit Unauthenticated");

      return;
    }

    final user = _repository.getCurrentUser();

    if (user == null) {
      await DebugLogger.log("Current user is null");

      if (isClosed) {
        await DebugLogger.log("Cubit closed");
        return;
      }

      emit(Unauthenticated());
      await DebugLogger.log("Emit Unauthenticated");

      return;
    }

    await DebugLogger.log("Current user: ${user.email}");
    await DebugLogger.log("Email verified: ${user.isEmailVerified}");

    if (isClosed) {
      await DebugLogger.log("Cubit closed");
      return;
    }

    if (user.isEmailVerified) {
      emit(Authenticated(user: user));
      await DebugLogger.log("Emit Authenticated");
    } else {
      emit(EmailVerificationRequired(email: user.email));
      await DebugLogger.log("Emit EmailVerificationRequired");
    }
  }
// AFTER
  Future<void> signIn(String email, String password) async {
    if (isClosed) return;
    emit(AuthLoading());
    final response = await _repository.signIn(email, password);
    if (isClosed) return;
    switch (response) {
      case Success():
      // Do NOT emit here. Supabase fires `signedIn` on the
      // onAuthStateChange stream as a result of this call, and
      // _onAuthEvent() will emit Authenticated / EmailVerificationRequired
      // from that single source of truth. Emitting here too was causing
      // a second, distinct Authenticated instance -> double-fired
      // listeners -> navigation loop.
        break;
      case Failure(errorModel: final error):
        emit(AuthError(message: error.message));
    }
  }
  Future<void> signUp(String email, String password, String name) async {
    if (isClosed) return;
    emit(AuthLoading());
    final response = await _repository.signUp(email, password, name);
    if (isClosed) return;
    switch (response) {
      case Success(data: final user):
      // Supabase projects with "Confirm email" enabled return a user
      // but no session until the link is clicked — always require
      // verification after sign-up regardless, per spec.
        emit(EmailVerificationRequired(email: user.email));
      case Failure(errorModel: final error):
        emit(AuthError(message: error.message));
    }
  }

  Future<void> resendVerification(String email) async {
    if (isClosed) return;
    emit(AuthLoading());
    final response = await _repository.resendVerification(email);
    if (isClosed) return;
    switch (response) {
      case Success():
        emit(EmailVerificationRequired(email: email));
      case Failure(errorModel: final error):
        emit(AuthError(message: error.message));
    }
  }

  Future<void> forgotPassword(String email) async {
    if (isClosed) return;
    emit(AuthLoading());
    final response = await _repository.forgotPassword(email);
    if (isClosed) return;
    switch (response) {
      case Success():
        if (isClosed) return;
        emit(ForgotPasswordSent(email: email));
      case Failure(errorModel: final error):
        if (isClosed) return;
        emit(AuthError(message: error.message));
    }
  }

  /// Exchanges an incoming `managementinventory://auth` deep link for a
  /// session. Only the failure path is decided here (expired/invalid
  /// link) — on success, [_onAuthEvent] receives Supabase's
  /// `passwordRecovery` or `signedIn` event (fired synchronously inside
  /// the exchange call) and drives the correct terminal state. Deciding
  /// it twice would race between this method's return and the event
  /// stream delivering first.
  Future<void> handleDeepLink(Uri uri) async {
    await DebugLogger.log("========== handleDeepLink ==========");
    await DebugLogger.log("URI: $uri");

    emit(AuthLoading());
    await DebugLogger.log("Emit AuthLoading");

    final response = await _repository.exchangeDeepLink(uri);

    await DebugLogger.log("Repository returned: ${response.runtimeType}");

    switch (response) {
      case Success():
        await DebugLogger.log("exchangeDeepLink SUCCESS");
        break;

      case Failure(errorModel: final error):
        await DebugLogger.log("exchangeDeepLink FAILURE");
        await DebugLogger.log(error.message);

        emit(AuthError(message: error.message));

        await DebugLogger.log("Emit AuthError");

        break;
    }
  }

  /// Sets a new password on the session established by the just-exchanged
  /// recovery link. Call from the Reset Password screen.
  Future<void> updatePassword(String newPassword) async {
    if (isClosed) return;
    emit(AuthLoading());
    final response = await _repository.updatePassword(newPassword);
    if (isClosed) return;
    switch (response) {
      case Success():
        emit(PasswordUpdated());
      case Failure(errorModel: final error):
        emit(AuthError(message: error.message));
    }
  }

  Future<void> logout() async {
    if (isClosed) return;
    emit(AuthLoading());
    final response = await _repository.logout();
    if (isClosed) return;
    switch (response) {
      case Success():
        emit(Unauthenticated());
      case Failure(errorModel: final error):
        emit(AuthError(message: error.message));
    }
  }

  @override
  Future<void> close() {
    _authEventSubscription?.cancel();
    return super.close();
  }
}