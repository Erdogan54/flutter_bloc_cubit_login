// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter_cubit_login/login/model/login_request_model.dart';
import 'package:flutter_cubit_login/login/model/login_response.dart';

abstract class ILoginService {
  final Dio dio;

  ILoginService(this.dio);

  final String loginPath = IloginServicePath.LOGIN.rawValue;

  Future<LoginResponseModel?> postUserLogin(LoginRequestModel model);
}

enum IloginServicePath { LOGIN }

extension IloginServicePathExtension on IloginServicePath {
  String get rawValue {
    switch (this) {
      case IloginServicePath.LOGIN:
        return "/login";
    }
  }
}
