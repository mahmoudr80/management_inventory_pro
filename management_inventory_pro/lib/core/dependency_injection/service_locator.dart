import 'package:get_it/get_it.dart';
import 'package:management_inventory_pro/core/database/database_service.dart';
import 'package:management_inventory_pro/features/product/data/datasource/product_datasource.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(remoteDataSource: getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt()));

  //Database
  DatabaseService databaseService=DatabaseService();
  await databaseService.init();
  getIt.registerSingleton(databaseService);


  //Product
  getIt.registerLazySingleton<ProductLocalDatasource>(() =>
      ProductLocalDatasource(getIt<DatabaseService>().db),);
  getIt.registerLazySingleton(() => ProductRepository(getIt<ProductLocalDatasource>()),);
}
