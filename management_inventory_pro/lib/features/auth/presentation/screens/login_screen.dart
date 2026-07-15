import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import 'package:management_inventory_pro/features/auth/presentation/screens/auth_gate.dart';
import 'package:management_inventory_pro/features/home/cubit/home_cubit.dart';
import 'package:management_inventory_pro/features/home/home_screen.dart';
import '../../../../core/dependency_injection/service_locator.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/components/auth_layout.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_header.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'email_verification_screen.dart';
import '../../../../generated/locale_keys.g.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final startOnLandingPage = (!kIsWeb && Platform.isWindows && getIt.isRegistered<StorageService>())
      ? !getIt<StorageService>().hasAnyUser()
      : true;
  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
    listenWhen: (previous, current) => previous!=current,
    listener: (context, state) {
    // Navigation on Authenticated / EmailVerificationRequired is now
    // owned exclusively by AuthDeepLinkListener at the app root, so
    // login triggered from any screen (or a deep link) is handled
    // identically in exactly one place. This listener only shows
    // local feedback now.
    if (state is Authenticated) {
    AppSnackBar.showSuccess(
    context,
    message:
    "${state.user.email} ${LocaleKeys.auth_loginSuccessfully.tr()}",
    );
    }
    else if (state is AuthError) {
    AppSnackBar.showError(context, message: state.message);
    }
    },
    child: AuthLayout(
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _onLoginPressed();
                  return null;
                },
              ),
            },
            child: Form(
              autovalidateMode: AutovalidateMode.onUnfocus,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeader(
                    title: LocaleKeys.auth_login.tr(),
                    subtitle: 'Welcome back to OmniStock',
                  ),
                  SizedBox(height: (48.h).clamp(36.0.h, 60.h)),
                  CustomTextField(
                    label: LocaleKeys.auth_email.tr(),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    hint: 'email@gmail.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  SizedBox(height: (16.h).clamp(12.0.h, 20.0.h)),
                  CustomTextField(
                    label: LocaleKeys.auth_password.tr(),
                    controller: _passwordController,
                    hint: '..........',
                    obscureText: true,
                    validator: Validators.validatePassword,
                    maxLines: 1,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  SizedBox(height: (8.h).clamp(6.0.h, 8.0.h)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        LocaleKeys.auth_forgot_password.tr(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h.clamp(18.0.h, 30.h)),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        text: LocaleKeys.auth_login.tr(),
                        isLoading: state is AuthLoading,
                        onPressed: _onLoginPressed,
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.auth_no_account.tr(),
                        style: AppTextStyles.body,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.auth_register.tr(),
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
