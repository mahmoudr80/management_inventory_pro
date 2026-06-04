import '../models/user_model.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  Future<UserModel> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  Future<UserModel> register(String email, String password, String name) async {
    return await remoteDataSource.register(email, password, name);
  }

  Future<void> forgotPassword(String email) async {
    return await remoteDataSource.forgotPassword(email);
  }

  Future<void> logout() async {
    return await remoteDataSource.logout();
  }
}
