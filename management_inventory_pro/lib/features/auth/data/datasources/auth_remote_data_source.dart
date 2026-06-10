import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';


class AuthRemoteDataSource{

  Future<ApiResult> login(String email, String password) async {
    try{
      AuthResponse response =
      await Supabase.instance.client.auth.signInWithPassword(password: password,email:email );
      User ?user = response.user;
      final session = response.session;
      if(user==null){
        return ApiResult.failure(ApiErrorModel(message: "email or password invalid!"));
      }
      if(session!=null){
        return ApiResult.success(UserModel(email: user.email??'',id: user.id));
      }
      else{
        return ApiResult.failure(ApiErrorModel(message: "email or password invalid!"));
      }
    }on AuthException catch(e){
      return ApiResult.failure(ApiErrorModel(message: e.message));
    }catch(e){
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }

  Future<ApiResult<void>> register(String email, String password, String name) async {

    try {
     await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      return const Success(null);
    }on AuthException catch(e){
      return Failure(ApiErrorModel(message: e.message));
    }
    catch (e) {
      return Failure(
        ApiErrorModel(
          message: 'Unexpected error occurred',
        ),
      );    }

  }

  Future<void> forgotPassword(String email) async {
    // TODO: Implement Supabase forgot password
    throw UnimplementedError();
  }

  Future<void> logout() async {
    // TODO: Implement Supabase logout
    throw UnimplementedError();
  }

  Stream<ApiResult<UserModel>> authStateChanges()  {
    return  Supabase.instance.client.auth.onAuthStateChange.map(
            (data) {

          User ?user = data.session?.user;
          if (user != null) {
            return ApiResult.success(
                UserModel(email: user.email ?? '', id: user.id));
          }
          return ApiResult.failure(
              ApiErrorModel(message: 'user is not authenticated!'));
        }
    );

  }
}


