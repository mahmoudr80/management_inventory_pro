import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';

class AppSnackBar {

  static void showError(BuildContext context, {required String message, int ?duration}) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration??600),width: 200.w,
        content: Text(message),
        backgroundColor: Colors.red.withAlpha(200),
        behavior: SnackBarBehavior.floating,
        shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, { required String message, int? duration}) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: Duration(milliseconds:duration??600),width: 200.w,
clipBehavior: Clip.antiAlias,
        content: Text(message),
        backgroundColor: AppColors.primary.withAlpha(200),
        behavior: SnackBarBehavior.floating,
        shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}