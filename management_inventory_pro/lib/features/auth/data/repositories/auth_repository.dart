import 'package:management_inventory_pro/core/networking/api_result.dart';

import '../models/auth_user_model.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  Future<ApiResult> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  Future<ApiResult> register(String email, String password, String name) async {
    return await remoteDataSource.register(email, password, name);
  }
  Stream<ApiResult<AuthUserModel>> authStateChanges(){
    return remoteDataSource.authStateChanges();
  }
  Future<void> forgotPassword(String email) async {
    return await remoteDataSource.forgotPassword(email);
  }

  Future<void> logout() async {
    return await remoteDataSource.logout();
  }
}
