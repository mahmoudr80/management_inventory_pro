import 'dart:async';
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
import 'core/logger/logger.dart';
import 'core/navigation/app_navigator.dart';
import 'core/theme/app_colors.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_constants.dart';
import 'core/services/deep_link/deep_link_service.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/auth_gate.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/widgets/auth_deep_link_listener.dart';
import 'features/category/data/datasource/category_datasource.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/home/home_screen.dart';
import 'features/landing page/landing_page.dart';
import 'features/settings/data/models/settings_model.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'features/unit/data/datasource/unit_datasource.dart';
import 'dart:io';


Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await DebugLogger.init();

  FlutterError.onError = (FlutterErrorDetails details) async {
    await DebugLogger.log("========== FLUTTER ERROR ==========");
    await DebugLogger.log(details.exceptionAsString());

    if (details.stack != null) {
      await DebugLogger.log(details.stack.toString());
    }
  };

  await runZonedGuarded(() async {
    await DebugLogger.log("========== APP START ==========");
    await DebugLogger.log("Args: $args");

    Uri? startupUri;
    if (args.isNotEmpty) {
      startupUri = Uri.tryParse(args.first);
    }

    await DebugLogger.log("StartupUri: $startupUri");

    await EasyLocalization.ensureInitialized();
    await DebugLogger.log("EasyLocalization initialized");

    if (!kIsWeb &&
        (Platform.isWindows ||
            Platform.isLinux ||
            Platform.isMacOS)) {
      await windowManager.ensureInitialized();

      const options = WindowOptions(
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

      await DebugLogger.log("Window initialized");
    }

    if (!kIsWeb && Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      await DebugLogger.log("SQLite initialized");
    }

    await DebugLogger.log("Service locator initialized");
    await setupServiceLocator();
    final startOnLandingPage = (!kIsWeb && Platform.isWindows && getIt.isRegistered<StorageService>())
        ? !getIt<StorageService>().hasAnyUser()
        : true; // or whatever sensible default for non-Windows
    await Supabase.initialize(
      url: 'https://vulfkiimpxlhgtusbchw.supabase.co',
      publishableKey: 'sb_publishable_h2-ihk3Rqzq9DKiqCWzz4A_Hj2OHylr',
      authOptions: const FlutterAuthClientOptions(
        detectSessionInUri: false,
      ),
    );

    await DebugLogger.log("Supabase initialized");

    final deepLinkService = DeepLinkService();

    await deepLinkService.registerWindowsProtocol();
    await DebugLogger.log("Protocol registered");

    await deepLinkService.init();
    await DebugLogger.log("DeepLinkService initialized");

    await DebugLogger.log("Calling runApp");

    runApp(
      EasyLocalization(
        supportedLocales: AppConstants.supportedLocales,
        path: AppConstants.translationsPath,
        fallbackLocale: AppConstants.englishLocale,
        child: MyApp(
          deepLinkService: deepLinkService,
          startupUri: startupUri,
            startOnLandingPage:startOnLandingPage
        ),
      ),
    );

    await DebugLogger.log("runApp finished");
  }, (error, stack) async {
    await DebugLogger.log("========== ZONE ERROR ==========");
    await DebugLogger.log(error.toString());
    await DebugLogger.log(stack.toString());
  });
}


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.deepLinkService,
    this.startupUri, this.startOnLandingPage=true,
  });

  final DeepLinkService deepLinkService;
  final Uri? startupUri;
  final bool startOnLandingPage;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, settings) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<AuthCubit>(),
            ),
            BlocProvider(
              create: (_) => getIt<SettingsCubit>(),
            ),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (_, settings) {
              // AuthDeepLinkListener wraps MaterialApp itself — i.e. it sits
              // ABOVE MaterialApp's internal Navigator (the one bound to
              // rootNavigatorKey), never as that Navigator's route content.
              //
              // It used to be passed in as `home:`, which made it the
              // Navigator's *first route*. The very first auth-driven
              // navigation (checkSession() emitting Unauthenticated on
              // essentially every cold start) calls
              // `navigator.pushAndRemoveUntil(..., (route) => false)` on
              // that same rootNavigatorKey, which removes ALL routes —
              // including the one holding AuthDeepLinkListener. That
              // disposed it and cancelled its uriStream subscription
              // permanently, so every deep link arriving after the app's
              // first navigation was silently dropped with no listener to
              // receive it. Living above the Navigator instead means
              // AuthDeepLinkListener is never itself a route, so it can
              // never be popped by routing inside MaterialApp — it persists
              // for the whole app lifetime, exactly as its own doc comment
              // says it should ("above/around MaterialApp's navigator").
              return AuthDeepLinkListener(
                deepLinkService: deepLinkService,
                startupUri: startupUri,
                child: MaterialApp(
                  navigatorKey: rootNavigatorKey, // IMPORTANT
                  debugShowCheckedModeBanner: false,
                  title: AppConstants.appName,
                  scrollBehavior: AppScrollBehavior(),

                  localizationsDelegates:
                  context.localizationDelegates,

                  supportedLocales:
                  context.supportedLocales,

                  locale: context.locale,

                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,

                  themeMode: _themeModeFrom(
                    settings.settings.appearance.themeMode,
                  ),
                  home:  AuthGate(startOnLandingPage:startOnLandingPage)
                ),
              );
            },
          ),
        );
      },
    );
  }
}
class WindowsFirstScreen extends StatelessWidget {
  const WindowsFirstScreen({super.key, required this.deepLinkService});
  final DeepLinkService deepLinkService;
  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final startOnLandingPage = !getIt<StorageService>().hasAnyUser();
    return session==null? AuthDeepLinkListener(deepLinkService: deepLinkService,child: LoginScreen()):
    startOnLandingPage? const LandingPage():
    BlocProvider(
      create: (context) => HomeCubit(),
      child: HomeScreen(),
    );
  }
}
class MobileFirstScreen extends StatelessWidget {
  const MobileFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final startOnLandingPage = !getIt<StorageService>().hasAnyUser();
    return session==null?LoginScreen():
    startOnLandingPage? const Placeholder():
    Placeholder();
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