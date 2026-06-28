import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:management_inventory_pro/core/database/database_service.dart';
import 'package:management_inventory_pro/features/dashboard/data/datasource/dashboard_datasource.dart';
import 'package:management_inventory_pro/features/dashboard/data/repository/dashboard_repository.dart';
import 'package:management_inventory_pro/features/pos/data/datasource/pos_datasource.dart';
import 'package:management_inventory_pro/features/pos/data/repository/pos_repository.dart';
import 'package:management_inventory_pro/features/product/data/datasource/product_datasource.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:management_inventory_pro/features/sale_history/data/datasource/sale_history_datasource.dart';
import 'package:management_inventory_pro/features/sale_history/data/repository/sale_history_repository.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/datasource/stock_entry_datasource.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/respository/stock_entry_repository.dart';
import 'package:management_inventory_pro/features/suppliers/data/datasource/supplier_datasource.dart';
import 'package:management_inventory_pro/features/unit/data/datasource/unit_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/category/data/datasource/category_datasource.dart';
import '../../features/category/data/respository/category_repository.dart';
import '../../features/suppliers/data/repository/supplier_repository.dart';
import '../../features/unit/data/respository/unit_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(remoteDataSource: getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt()));

  if(!kIsWeb&&Platform.isWindows){
    print("DatabaseService init");
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

  }


}
