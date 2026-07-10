import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';
import 'core/dependency_injection/service_locator.dart';
import 'core/theme/app_colors.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_constants.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/category/data/datasource/category_datasource.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/home/home_screen.dart';
import 'features/landing page/landing_page.dart';
import 'features/settings/models/settings_model.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'features/unit/data/datasource/unit_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();


  if (!kIsWeb &&
      (Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS)) {
    print("windowManager.ensureInitialized");

    await windowManager.ensureInitialized();

    WindowOptions options = const WindowOptions(
      size: Size(1280, 720),
      center: true,
    );

    windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setMinimumSize(
        const Size(1050, 680),
      );

      await windowManager.show();
      await windowManager.focus();
    });
  }

  if (!kIsWeb && Platform.isWindows) {
    print("sqfliteFfiInit");
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }


  // Initialize Dependency Injection & database init
  await setupServiceLocator();
  // Sets up Hive inside the "personal" folder next to the .exe.
  final startOnLandingPage = !getIt<StorageService>().hasAnyUser();

  await Supabase.initialize(
    url: 'https://vulfkiimpxlhgtusbchw.supabase.co',
    publishableKey: 'sb_publishable_h2-ihk3Rqzq9DKiqCWzz4A_Hj2OHylr',
  );
  runApp(
    EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: AppConstants.translationsPath,
      fallbackLocale: AppConstants.englishLocale,
      child:  MyApp(startOnLandingPage: startOnLandingPage,),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startOnLandingPage});
  final bool startOnLandingPage;
  @override
  Widget build(BuildContext context) {
    // ScreenUtil init for responsive UI
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Standard mobile screen size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return  MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
            BlocProvider<SettingsCubit>(create: (context) => getIt<SettingsCubit>()),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {
              return MaterialApp(
                scrollBehavior: AppScrollBehavior(),
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: _themeModeFrom(settingsState.settings.appearance.themeMode),
                home:
                !kIsWeb && defaultTargetPlatform == TargetPlatform.windows ?
                startOnLandingPage ? const LandingPage() :
                BlocProvider(
                  create: (context) => HomeCubit(),
                  child: HomeScreen(),
                ) : LoginScreen(),
              );
            },
          ),
        );
      },
    );
  }
}


class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

/// Maps the Settings feature's [ThemeModeOption] to Flutter's
/// [ThemeMode], used to drive `MaterialApp.themeMode`. Kept here in
/// `main.dart` (the composition root) rather than in `core/theme`,
/// since core theme files intentionally never import from features.
ThemeMode _themeModeFrom(ThemeModeOption option) {
  switch (option) {
    case ThemeModeOption.light:
      return ThemeMode.light;
    case ThemeModeOption.dark:
      return ThemeMode.dark;
    case ThemeModeOption.system:
      return ThemeMode.system;
  }
}