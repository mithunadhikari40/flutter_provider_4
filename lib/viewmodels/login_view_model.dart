import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/services/authentication_service.dart';
import 'package:flutter_provider_arch/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  final AuthenticationService authenticationService;

  LoginViewModel({this.authenticationService});

  Future<bool> login(int userId) async {
    setBusy(true);

    //noftify the login screen to show progress
    bool response = await authenticationService.login(userId);
    setBusy(false);
    return response;
    //notify the login screen to stop showing progress
  }
}
