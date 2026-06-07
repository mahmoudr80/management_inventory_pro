import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/generated/locale_keys.g.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  AuthCubit({required AuthRepository authRepository}) : _repository = authRepository, super(AuthInitial());

  Future<void> login(String email, String password) async {
    if(isClosed)return;
    emit(AuthLoading());
    final response = await _repository.login(email, password);
    switch(response){
      case Success(data:final data):
        if(isClosed)return;
        emit(AuthSuccess(user: data));
      case Failure(errorModel:final error):
        if(isClosed)return;
        emit(AuthFailure(message: error.message));
    }
  }

  Future<void> register(String email, String password, String name) async {
    if(isClosed)return;
    emit(AuthLoading());
    final response = await _repository.register(email, password, name);
    switch(response){
      case Success():
        if(isClosed)return;
        emit(VerifyState(verify:LocaleKeys.auth_verificationEmailSent.tr()));
      case Failure(errorModel:ApiErrorModel error):
        if(isClosed)return;
        emit(AuthFailure(message: error.message));
    }
  }

  Future<void> forgotPassword(String email) async {
    // emit(AuthLoading());
    // try {
    //   await _repository.forgotPassword(email);
    //   emit(AuthInitial()); // Or a specific state like ForgotPasswordEmailSent
    // } catch (e) {
    //   emit(AuthFailure(message: e.toString()));
    // }
  }

  Future<void> logout() async {
    // emit(AuthLoading());
    // try {
    //   await _repository.logout();
    //   emit(AuthInitial());
    // } catch (e) {
    //   emit(AuthFailure(message: e.toString()));
    // }
  }
}

