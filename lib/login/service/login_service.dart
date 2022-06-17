import 'dart:io';

import 'package:flutter_cubit_login/login/model/login_response.dart';
import 'package:flutter_cubit_login/login/model/login_request_model.dart';
import 'package:flutter_cubit_login/login/service/Ilogin_service.dart';

class LoginService extends ILoginService {
  LoginService(super.dio);

  @override
  Future<LoginResponseModel?> postUserLogin(LoginRequestModel model) async {
    final response = await dio.post(loginPath, data: model);
    if (response.statusCode == HttpStatus.ok) {
      return LoginResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}
