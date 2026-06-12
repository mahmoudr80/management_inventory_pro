import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:management_inventory_pro/core/database/database_service.dart';
import 'package:management_inventory_pro/features/product/data/datasource/product_datasource.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
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
  }


}
