import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
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
import '../../features/sale_history/data/datasource/sale_history_datasource.dart';
import '../../features/sale_history/data/repository/sale_history_repository.dart';
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
import '../database/database_service.dart';
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

  // Settings — registered as a lazy *singleton* (not a factory like
  // AuthCubit) since MaterialApp needs one long-lived instance whose
  // appearance.themeMode drives the whole app's theme.
  getIt.registerLazySingleton<SettingsCubit>(
        () => SettingsCubit(themePreferenceService: getIt<ThemePreferenceService>()),
  );

  if(!kIsWeb&&Platform.isWindows){
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
    getIt.registerLazySingleton(() => StockAdjustmentHistoryRepository(getIt<StockAdjustmentHistoryDatasource>()),);


    final storageService = StorageService();
    await storageService.init();

    getIt.registerSingleton<StorageService>(storageService);
  }


}