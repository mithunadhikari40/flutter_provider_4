import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/provider_setup.dart';
import 'package:flutter_provider_arch/ui/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_contstants.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();

SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
final bool isLoggedIn = sharedPreferences.getBool(AppConstants.LOGIN_KEY) ?? false;

  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatelessWidget {
  MyApp(this.isLoggedIn);
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: isLoggedIn ? RoutePaths.Home: RoutePaths.Login,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
