import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/components/auth_layout.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_header.dart';
import 'login_screen.dart';
import 'email_verification_screen.dart';
import '../../../../generated/locale_keys.g.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
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

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
    listener: (context, state) {
    // Navigation on EmailVerificationRequired is owned exclusively by
    // AuthDeepLinkListener at the app root now.
    if (state is AuthError) {
    AppSnackBar.showError(context, message: state.message);
    }
    },
    child: AuthLayout(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: LocaleKeys.auth_register.tr(),
                subtitle: 'Join OmniStock today',
              ),
              SizedBox(height: 48.h),
              CustomTextField(
                label: 'Full Name',
                controller: _nameController,
                validator: Validators.validateRequired,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                label: LocaleKeys.auth_email.tr(),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                label: LocaleKeys.auth_password.tr(),
                controller: _passwordController,
                maxLines: 1,
                obscureText: true,
                validator: Validators.validatePassword,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                maxLines: 1,
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: true,
                validator: _validateConfirmPassword,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              SizedBox(height: 32.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: LocaleKeys.auth_register.tr(),
                    isLoading: state is AuthLoading,
                    onPressed: _onRegisterPressed,
                  );
                },
              ),
              SizedBox(height: 24.h),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    LocaleKeys.auth_have_account.tr(),
                    style: AppTextStyles.body,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      LocaleKeys.auth_login.tr(),
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
    );
  }
}
