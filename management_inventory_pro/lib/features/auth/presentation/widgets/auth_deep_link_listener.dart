import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../core/dependency_injection/service_locator.dart';
import '../../../../core/logger/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_navigator.dart';
// TODO: confirm this import path matches where DeepLinkService actually
// lives in the project — it wasn't part of the files reviewed for this
// change, so the path below is inferred, not verified.
import '../../../../core/services/deep_link/deep_link_service.dart';
import 'package:management_inventory_pro/features/home/home_screen.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../home/cubit/home_cubit.dart';
import '../../../landing page/landing_page.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../screens/reset_password_screen.dart';
import '../screens/login_screen.dart';
import '../screens/email_verification_screen.dart';

/// Wrap the app's root content with this — above/around `MaterialApp`'s
/// navigator, below the `BlocProvider<AuthCubit>`.
///
/// Owns two responsibilities, both deliberately centralized here so there
/// is exactly ONE of each in the whole app:
///
///  1. The single subscription to [DeepLinkService.uriStream]. Every URI
///     that arrives (cold-start or while running) is forwarded straight
///     into `AuthCubit.handleDeepLink(uri)` — no parsing, no auth logic,
///     no navigation happens here. `DeepLinkService` remains pure
///     infrastructure; this widget is the one place a link becomes an
///     auth operation.
///
///  2. Force-navigation off the resulting [AuthState], no matter which
///     screen currently happens to be on top (the app may have been open
///     on Home, or on `EmailVerificationScreen`, when the user clicked
///     the email link). Uses the global [rootNavigatorKey] instead of a
///     local [BuildContext] since this listener sits above any single
///     screen's context.
///
/// [deepLinkService] must be the same instance that already had
/// `registerWindowsProtocol()` and `init()` called on it in `main()`
/// before `runApp()` — this widget does not create or initialize it,
/// only subscribes to it.
class AuthDeepLinkListener extends StatefulWidget {
  final Widget child;
  final DeepLinkService deepLinkService;
  final Uri? startupUri;

  const AuthDeepLinkListener({
    super.key,
    required this.child,
    required this.deepLinkService,
    this.startupUri,
  });

  @override
  State<AuthDeepLinkListener> createState() => _AuthDeepLinkListenerState();
}

class _AuthDeepLinkListenerState extends State<AuthDeepLinkListener> {
  StreamSubscription<Uri>? _linkSubscription;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();

    DebugLogger.log("AuthDeepLinkListener init");
    DebugLogger.log("startupUri = ${widget.startupUri}");

    if(mounted){
      _authCubit = context.read<AuthCubit>();

    }

    if (widget.startupUri != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        await DebugLogger.log("Calling handleDeepLink(startupUri)");
        _authCubit.handleDeepLink(widget.startupUri!);
      });
    }

     DebugLogger.log("Subscribing to uriStream");

    _linkSubscription = widget.deepLinkService.uriStream.listen((uri) async{
      await  DebugLogger.log("uriStream received: $uri");
      _authCubit.handleDeepLink(uri);
    });
  }

  @override
  void dispose() {
    // Cancel our own subscription only. DeepLinkService's lifecycle
    // (and its own `dispose()`) belongs to whoever created it — this
    // listener never owns or closes the service itself.
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
      current is PasswordRecovery ||
          current is Authenticated ||
          current is Unauthenticated ||
          current is EmailVerificationRequired,
      listener: (context, state) async{
       await DebugLogger.log(
            "BlocListener state: ${state.runtimeType}");

        final navigator = rootNavigatorKey.currentState;

       await DebugLogger.log(
            "Navigator null = ${navigator == null}");

        if (navigator == null) return;


        if (state is PasswordRecovery) {
          // Reached ONLY via the recovery deep link — see
          // ResetPasswordScreen's own doc comment. A stale recovery
          // session shouldn't be left reachable via back navigation.
          print("Navigate -> ResetPasswordScreen");
          await DebugLogger.log(
              "Navigate -> ResetPassword");
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
                (route) => false,
          );
        } // AFTER
       else if (state is Authenticated) {
      // Covers both explicit sign-in AND a verification deep link
      // resolving while the user is sitting on some other screen
      // (e.g. EmailVerificationScreen) that has no local listener
      // for this transition.
      //
      // Same "first-run -> show LandingPage" decision that used to live
      // in LoginScreen. It has to live here now, since this is the only
      // widget that navigates on Authenticated.
      final startOnLandingPage = (!kIsWeb &&
          Platform.isWindows &&
          getIt.isRegistered<StorageService>())
          ? !getIt<StorageService>().hasAnyUser()
          : true;

      await DebugLogger.log("Navigate -> ${startOnLandingPage ? 'Landing' : 'Home'}");

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => startOnLandingPage
              ? const LandingPage()
              : BlocProvider(
            create: (BuildContext context) => HomeCubit(),
            child: const HomeScreen(),
          ),
        ),
            (route) => false,
      );
    }else if (state is EmailVerificationRequired) {
          await DebugLogger.log(
              "Navigate -> EmailVerification");
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => EmailVerificationScreen(email: state.email),
            ),
                (route) => false,
          );
        } else if (state is Unauthenticated) {
          await DebugLogger.log(
              "Navigate -> Login");
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
          );
        }
      },
      child: widget.child,
    );
  }
}