import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> forgotPassword(String email);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // TODO: Inject Supabase client here

  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Implement Supabase login
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    // TODO: Implement Supabase register
    throw UnimplementedError();
  }

  @override
  Future<void> forgotPassword(String email) async {
    // TODO: Implement Supabase forgot password
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement Supabase logout
    throw UnimplementedError();
  }
}
