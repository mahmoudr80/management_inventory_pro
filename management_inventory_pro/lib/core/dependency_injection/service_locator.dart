import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:management_inventory_pro/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:management_inventory_pro/features/reports/data/datasource/low_stock_local_datasource.dart';
import 'package:management_inventory_pro/features/reports/data/datasource/out_of_stock_local_datasource.dart';
import 'package:management_inventory_pro/features/reports/data/datasource/profit_report_local_datasource.dart';
import 'package:management_inventory_pro/features/reports/data/repository/inventory_valuation_repository.dart';
import 'package:management_inventory_pro/features/reports/data/repository/low_stock_repository.dart';
import 'package:management_inventory_pro/features/reports/data/repository/out_of_stock_repository.dart';
import 'package:management_inventory_pro/features/reports/data/repository/profit_report_repository.dart';
import 'package:management_inventory_pro/features/reports/data/repository/reports_stock_adjustment_history_repository.dart';
import 'package:management_inventory_pro/features/reports/data/repository/sales_report_repository.dart';
import 'package:management_inventory_pro/features/reports/data/repository/stock_movement_repository.dart';
import 'package:management_inventory_pro/features/reports/data/repository/supplier_purchases_repository.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/category/data/datasource/category_datasource.dart';
import '../../features/category/data/respository/category_repository.dart';
import '../../features/dashboard/data/datasource/dashboard_datasource.dart';
import '../../features/dashboard/data/repository/dashboard_repository.dart';
import '../../features/pos/data/datasource/pos_datasource.dart';
import '../../features/pos/data/repository/pos_repository.dart';
import '../../features/product/data/datasource/product_datasource.dart';
import '../../features/product/data/respository/product_repository.dart';
import '../../features/reports/data/datasource/inventory_valuation_local_datasource.dart';
import '../../features/reports/data/datasource/sales_report_local_datasource.dart';
import '../../features/reports/data/datasource/stock_adjustment_history_local_datasource.dart';
import '../../features/reports/data/datasource/stock_movement_local_datasource.dart';
import '../../features/reports/data/datasource/supplier_purchases_local_datasource.dart';
import '../../features/sale_history/data/datasource/sale_history_datasource.dart';
import '../../features/sale_history/data/repository/sale_history_repository.dart';
import '../../features/settings/data/datasource/settings_local_datasource.dart';
import '../../features/settings/data/local/settings_preferences_service.dart';
import '../../features/settings/data/repository/settings_repository.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/stock_adjustment/data/datasource/stock_adjustment_datasource.dart';
import '../../features/stock_adjustment/data/repository/stock_adjustment_repository.dart';
import '../../features/stock_adjustment_history/data/datasource/stock_adjustment_history_datasource.dart';
import '../../features/stock_adjustment_history/data/repositories/stock_adjustment_history_repository.dart';
import '../../features/stock_receipts/data/datasource/stock_entry_datasource.dart';
import '../../features/stock_receipts/data/respository/stock_entry_repository.dart';
import '../../features/suppliers/data/datasource/supplier_datasource.dart';
import '../../features/suppliers/data/repository/supplier_repository.dart';
import '../../features/unit/data/datasource/unit_datasource.dart';
import '../../features/unit/data/respository/unit_repository.dart';
import '../components/sidebar/cubit/sidebar_cubit.dart';
import '../database/database_service.dart';
import '../services/deep_link/deep_link_service.dart';
import '../storage/sidebar_preference_service.dart';
import '../storage/storage_service.dart';
import '../theme/theme_preference_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(remoteDataSource: getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt()));

  // Theme mode persistence (all platforms — shared_preferences works
  // everywhere, unlike the Windows-only Hive StorageService below).
  final themePreferenceService = ThemePreferenceService();
  getIt.registerSingleton<ThemePreferenceService>(themePreferenceService);

  // Settings preferences (all platforms — shared_preferences, same tech
  // as ThemePreferenceService above). Backs every settings section that
  // has no SQLite column. Registered here, cross-platform, so it's ready
  // regardless of whether the Windows-only SettingsRepository below ends
  // up registered too.
  final settingsPreferencesService = SettingsPreferencesService();
  getIt.registerSingleton<SettingsPreferencesService>(settingsPreferencesService);

  // Settings — registered as a lazy *singleton* (not a factory like
  // AuthCubit) since MaterialApp needs one long-lived instance whose
  // appearance.themeMode drives the whole app's theme. settingsRepository
  // and storageService are looked up defensively (isRegistered) since
  // they're only registered on Windows, below — this factory runs lazily,
  // after setupServiceLocator() has finished, so by the time it executes
  // those registrations (if applicable) are already in place.
  getIt.registerLazySingleton<SettingsCubit>(
        () => SettingsCubit(
      themePreferenceService: getIt<ThemePreferenceService>(),
      settingsPreferencesService: getIt<SettingsPreferencesService>(),
      settingsRepository: getIt.isRegistered<SettingsRepository>()
          ? getIt<SettingsRepository>()
          : null,
      storageService: getIt.isRegistered<StorageService>()
          ? getIt<StorageService>()
          : null,
    ),
  );

  if(!kIsWeb&&Platform.isWindows){

    final storageService = StorageService();
    await storageService.init();
    getIt.registerSingleton<StorageService>(storageService);

    //Database
    DatabaseService databaseService=DatabaseService();
    await databaseService.init();
    getIt.registerSingleton(databaseService);



    //Product
    getIt.registerLazySingleton<ProductLocalDatasource>(() =>
        ProductLocalDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => ProductRepository(getIt<ProductLocalDatasource>()),);

    //Unit
    getIt.registerLazySingleton<UnitLocalDatasource>(() =>
        UnitLocalDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => UnitRepository(getIt<UnitLocalDatasource>()),);

    //category
    getIt.registerLazySingleton<CategoryLocalDatasource>(() =>
        CategoryLocalDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => CategoryRepository(getIt<CategoryLocalDatasource>()),);


    //Supplier
    getIt.registerLazySingleton<SupplierLocalDatasource>(() =>
        SupplierLocalDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => SupplierRepository(getIt<SupplierLocalDatasource>()),);


    //Stock receipts
    getIt.registerLazySingleton<StockEntryDatasource>(() =>
        StockEntryDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => StockEntryRepository(getIt<StockEntryDatasource>()),);

    //pos
    getIt.registerLazySingleton<PosDatasource>(() =>
        PosDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => PosRepository(getIt<PosDatasource>()),);




    //pos
    getIt.registerLazySingleton<SaleHistoryDatasource>(() =>
        SaleHistoryDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => SaleHistoryRepository(getIt<SaleHistoryDatasource>()),);

    //dashboard
    getIt.registerLazySingleton<DashboardDatasource>(() =>
        DashboardDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => DashboardRepository(getIt<DashboardDatasource>()),);

    //stock adjustment
    getIt.registerLazySingleton<StockAdjustmentDatasource>(() =>
        StockAdjustmentDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => StockAdjustmentRepository(getIt<StockAdjustmentDatasource>()),);

    //stock adjustment history
    getIt.registerLazySingleton<StockAdjustmentHistoryDatasource>(() =>
        StockAdjustmentHistoryDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<StockAdjustmentHistoryRepository>(() => StockAdjustmentHistoryRepository(getIt<StockAdjustmentHistoryDatasource>()),);

    //settings
    getIt.registerLazySingleton<SettingsLocalDatasource>(() =>
        SettingsLocalDatasource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton(() => SettingsRepository(getIt<SettingsLocalDatasource>()),);


    getIt.registerLazySingleton<PosCubit>(() => PosCubit(getIt<PosRepository>(),
        settingsRepository: getIt<SettingsRepository>()),);


    
    getIt.registerLazySingleton<InventoryValuationLocalDataSource>
      (() => InventoryValuationLocalDataSource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<InventoryValuationRepository>
      (() => InventoryValuationRepository(getIt<InventoryValuationLocalDataSource>()),);

    getIt.registerLazySingleton<LowStockLocalDataSource>
      (() => LowStockLocalDataSource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<LowStockRepository>
      (() => LowStockRepository(getIt<LowStockLocalDataSource>()),);

    getIt.registerLazySingleton<OutOfStockLocalDataSource>
      (() => OutOfStockLocalDataSource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<OutOfStockRepository>
      (() => OutOfStockRepository(getIt<OutOfStockLocalDataSource>()),);


    getIt.registerLazySingleton<ProfitReportLocalDataSource>
      (() => ProfitReportLocalDataSource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<ProfitReportRepository>
      (() => ProfitReportRepository(getIt<ProfitReportLocalDataSource>()),);

    getIt.registerLazySingleton<SalesReportLocalDataSource>
      (() => SalesReportLocalDataSource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<SalesReportRepository>
      (() => SalesReportRepository(getIt<SalesReportLocalDataSource>()),);


    getIt.registerLazySingleton<StockMovementLocalDataSource>
      (() => StockMovementLocalDataSource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<StockMovementRepository>
      (() => StockMovementRepository(getIt<StockMovementLocalDataSource>()),);

    getIt.registerLazySingleton<SupplierPurchasesLocalDataSource>
      (() => SupplierPurchasesLocalDataSource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<SupplierPurchasesRepository>
      (() => SupplierPurchasesRepository(getIt<SupplierPurchasesLocalDataSource>()),);


    getIt.registerLazySingleton<ReportsStockAdjustmentHistoryLocalDataSource>
      (() => ReportsStockAdjustmentHistoryLocalDataSource(getIt<DatabaseService>().db),);
    getIt.registerLazySingleton<ReportsStockAdjustmentHistoryRepository>
      (() => ReportsStockAdjustmentHistoryRepository(getIt<ReportsStockAdjustmentHistoryLocalDataSource>()),);


  }


// Sidebar UI state persistence (all platforms — shared_preferences,
  // same reasoning as ThemePreferenceService/SettingsPreferencesService).
  final sidebarPreferenceService = SidebarPreferenceService();
  getIt.registerSingleton<SidebarPreferenceService>(sidebarPreferenceService);

  getIt.registerLazySingleton<SidebarCubit>(
        () => SidebarCubit(getIt<SidebarPreferenceService>()),
  );
}
