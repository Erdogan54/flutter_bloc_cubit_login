import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit_login/login/model/login_request_model.dart';
import 'package:flutter_cubit_login/login/model/login_response.dart';
import 'package:flutter_cubit_login/login/service/Ilogin_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final ILoginService service;
  bool isLoginFail = false;
  bool isLoading = false;

  LoginCubit(this.formKey, this.emailController, this.passwordController,
      {required this.service})
      : super(LoginInitial());

  Future<void> postUserModel() async {
    if (formKey.currentState?.validate() ?? false) {
      changeLodingView();
      final data = await service.postUserLogin(LoginRequestModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim()));
      changeLodingView();

      if (data is LoginResponseModel) {
        emit(LoginComplate(data));
      }
    } else {
      isLoginFail = true;
      emit(LoginValidateState(isLoginFail));
    }
  }

  void changeLodingView() {
    isLoading = !isLoading;
    emit(LoginLoadingState(isLoading));
  }
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginComplate extends LoginState {
  final LoginResponseModel model;

  LoginComplate(this.model);
}

class LoginValidateState extends LoginState {
  final bool isValidateFail;

  LoginValidateState(this.isValidateFail);
}

class LoginLoadingState extends LoginState {
  final bool isLoading;

  LoginLoadingState(this.isLoading);
}
