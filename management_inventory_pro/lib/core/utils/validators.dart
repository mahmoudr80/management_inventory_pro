import 'package:easy_localization/easy_localization.dart';
import '../../generated/locale_keys.g.dart';

class Validators {
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.errors_required_field.tr();
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.errors_required_field.tr();
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return LocaleKeys.errors_invalid_email.tr();
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.errors_required_field.tr();
    }
    if (value.length < 6) {
      return LocaleKeys.errors_short_password.tr();
    }
    return null;
  }
}
