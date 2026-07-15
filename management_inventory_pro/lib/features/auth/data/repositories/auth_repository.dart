import '../../../../core/logger/logger.dart';

import 'package:management_inventory_pro/core/networking/api_result.dart';

import '../models/auth_event_model.dart';
import '../models/auth_user_model.dart';
import '../datasources/auth_remote_data_source.dart';

/// Sits between the Cubit and the datasource. Widgets and the Cubit only
/// ever see [AuthUserModel] / [AuthEventModel] / [ApiResult] — never a
/// Supabase type.
class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  Future<ApiResult<AuthUserModel>> signIn(String email, String password) {
    return remoteDataSource.signIn(email, password);
  }

  Future<ApiResult<AuthUserModel>> signUp(
      String email,
      String password,
      String name,
      ) {
    return remoteDataSource.signUp(email, password, name);
  }

  Future<ApiResult<void>> logout() {
    return remoteDataSource.logout();
  }

  Future<ApiResult<void>> forgotPassword(String email) {
    return remoteDataSource.forgotPassword(email);
  }

  Future<ApiResult<void>> resendVerification(String email) {
    return remoteDataSource.resendVerification(email);
  }

  /// Exchanges an email-verification or password-recovery deep link for a
  /// session. See [AuthRemoteDataSource.exchangeDeepLink] for why this
  /// only surfaces failure — success is communicated via [authEvents].
  Future<ApiResult<AuthUserModel>> exchangeDeepLink(Uri uri)async {
   await DebugLogger.log("========== Repository.exchangeDeepLink ==========");
   await DebugLogger.log(uri.toString());
    return remoteDataSource.exchangeDeepLink(uri);
  }

  Future<ApiResult<void>> updatePassword(String newPassword) {
    return remoteDataSource.updatePassword(newPassword);
  }

  AuthUserModel? getCurrentUser() => remoteDataSource.getCurrentUser();

  bool isLoggedIn() => remoteDataSource.isLoggedIn();

  Stream<AuthEventModel> authEvents() => remoteDataSource.authEvents();
}