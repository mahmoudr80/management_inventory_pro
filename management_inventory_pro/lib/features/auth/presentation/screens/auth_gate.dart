import 'package:management_inventory_pro/features/auth/data/repositories/auth_repository.dart';
import 'package:management_inventory_pro/features/home/cubit/home_cubit.dart';
import 'package:management_inventory_pro/features/landing%20page/landing_page.dart';

import '../../../../core/dependency_injection/service_locator.dart';
import '../../../../core/logger/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/home/home_screen.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'login_screen.dart';
import 'email_verification_screen.dart';

/// Single decision point placed after the Landing flow, before Auth/Home.
/// Checks the Supabase session exactly once on start (via
/// `AuthCubit.checkSession`) and routes straight to the right screen —
/// no polling, no repeated splash checks.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key, this.startOnLandingPage=true});
final bool startOnLandingPage;
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
// AFTER
  @override
  void initState() {
    DebugLogger.log("AuthGate init");
    super.initState();
    if (mounted) {
      final cubit = context.read<AuthCubit>();
      // Only run the session check once, on the very first AuthGate.
      // If AuthGate gets rebuilt/remounted after we already have a
      // terminal state, re-running checkSession() would re-emit that
      // state and re-trigger every navigation listener again.
      if (cubit.state is AuthInitial) {
        DebugLogger.log("Calling checkSession()");
        cubit.checkSession();
      } else {
        DebugLogger.log("Skipping checkSession() - state already: ${cubit.state}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return widget.startOnLandingPage?LandingPage():
          BlocProvider(create: (BuildContext context) =>HomeCubit(),
              child: const HomeScreen());
        }
        if (state is EmailVerificationRequired) {
          return EmailVerificationScreen(email: state.email);
        }
        if (state is Unauthenticated || state is AuthError) {
          return const LoginScreen();
        }
        // AuthInitial / AuthLoading — brief, one-time check only.
        return Scaffold(
          backgroundColor: context.colors.background,
          body: Center(
            child: CircularProgressIndicator(color: context.colors.primary),
          ),
        );
      },
    );
  }
}