import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/services/api.dart';
import 'package:flutter_provider_arch/core/services/authentication_service.dart';
import 'package:flutter_provider_arch/core/services/db_service.dart';
import 'package:flutter_provider_arch/core/services/home_view_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ..._independantService,
  ..._dependentService
];

List<SingleChildWidget> _independantService = [
  Provider.value(value: Api()),
  Provider.value(value: DbService())
];

List<SingleChildWidget> _dependentService = [
  ProxyProvider2(
    update: (BuildContext context, Api api, DbService dbService,
        AuthenticationService authenticationService) {
      return AuthenticationService(api: api, dbService: dbService);
    },
  ),
  ProxyProvider2(
    update: (BuildContext context, Api api, DbService dbService,
        HomeViewService homeService) {
      return HomeViewService(api: api, dbService: dbService);
    },
  ),
];
