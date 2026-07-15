import '../../../../core/logger/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/auth_state.dart';
import 'login_screen.dart';

/// Reached ONLY by opening the password-recovery deep link
/// (`managementinventory://auth?...&type=recovery`) — there is no button
/// anywhere in the app that navigates here directly. The global
/// `AuthDeepLinkListener` pushes this screen the moment [PasswordRecovery]
/// is emitted, replacing whatever was on screen, since a stale recovery
/// session shouldn't be left reachable via back navigation.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateConfirmPassword(String? value) {
    final passwordError = Validators.validatePassword(value);
    if (passwordError != null) return passwordError;
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().updatePassword(_passwordController.text);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (_) {
                  _goToLogin(dialogContext);
                  return null;
                },
              ),
            },
            child: AlertDialog(
              icon: const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 40,
              ),
              title: const Text('Password updated'),
              content: Text(
                'Your password has been changed. Please sign in with your '
                    'new password.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                PrimaryButton(
                  text: 'Back to Login',
                  onPressed: () => _goToLogin(dialogContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goToLogin(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  void initState(){
    super.initState();
     DebugLogger.log(
        "ResetPasswordScreen init");

  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.password_rounded,
                      size: 80.w,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Set a new password',
                      style: AppTextStyles.heading1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Choose a new password for your account.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48.h),
                    CustomTextField(
                      label: 'New Password',
                      controller: _passwordController,
                      hint: '..........',
                      obscureText: true,
                      validator: Validators.validatePassword,
                      maxLines: 1,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      label: 'Confirm New Password',
                      controller: _confirmPasswordController,
                      hint: '..........',
                      obscureText: true,
                      validator: _validateConfirmPassword,
                      maxLines: 1,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    SizedBox(height: 32.h),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        } else if (state is PasswordUpdated) {
                          _showSuccessDialog();
                        }
                      },
                      builder: (context, state) {
                        return PrimaryButton(
                          text: 'Update Password',
                          isLoading: state is AuthLoading,
                          onPressed: _onSubmit,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}