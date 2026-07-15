import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/components/auth_layout.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_header.dart';
import 'login_screen.dart';

/// Shown after sign-up, or on app start if a returning user still has an
/// unverified email. Not a new auth feature — it's the presentation-layer
/// counterpart to the `EmailVerificationRequired` cubit state.
class EmailVerificationScreen extends StatefulWidget {
  final String email;
  const EmailVerificationScreen({super.key, required this.email});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FocusNode _resendFocusNode = FocusNode();

  void _onResend() {
    context.read<AuthCubit>().resendVerification(widget.email);
  }

  void _onBackToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _resendFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _onBackToLogin();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackBar.showError(context, message: state.message);
          } else if (state is EmailVerificationRequired) {
            AppSnackBar.showSuccess(
              context,
              message: 'Verification email sent to ${state.email}.',
            );
          }
        },
        child: AuthLayout(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: 'Verify your email',
                subtitle:
                    'We sent a verification link to ${widget.email}. '
                    'Please check your inbox to continue.',
              ),
              SizedBox(height: 32.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: 'Resend verification email',
                    isLoading: state is AuthLoading,
                    onPressed: _onResend,
                  );
                },
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: _onBackToLogin,
                child: Text(
                  'Back to Login',
                  style: AppTextStyles.body.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
