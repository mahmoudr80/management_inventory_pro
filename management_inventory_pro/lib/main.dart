import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:management_inventory_pro/features/home/cubit/home_cubit.dart';
import 'package:management_inventory_pro/features/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'core/dependency_injection/service_locator.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/app_constants.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (!kIsWeb &&
      (Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS)) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(
        Size(1000, 650)
    );
  }

  // Initialize Dependency Injection
  await setupServiceLocator();

  await Supabase.initialize(
    url: 'https://vulfkiimpxlhgtusbchw.supabase.co',
    anonKey: 'sb_publishable_h2-ihk3Rqzq9DKiqCWzz4A_Hj2OHylr',
  );
  runApp(
    EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: AppConstants.translationsPath,
      fallbackLocale: AppConstants.englishLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtil init for responsive UI
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Standard mobile screen size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
          ],
          child: MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                primary: AppColors.primary,
              ),
              scaffoldBackgroundColor: AppColors.background,
              useMaterial3: true,
            ),
            home:
            !kIsWeb && defaultTargetPlatform == TargetPlatform.windows ?
            BlocProvider(
              create: (context) => HomeCubit(),
              child: HomeScreen(),
            ) : LoginScreen(),
          ),
        );
      },
    );
  }
}
