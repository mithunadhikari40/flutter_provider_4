import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/ui/views/add_new_place.dart';
import 'package:flutter_provider_arch/ui/views/home_view.dart';
import 'package:flutter_provider_arch/ui/views/login_view.dart';
import 'package:flutter_provider_arch/ui/widgets/map_input.dart';
import 'package:location/location.dart';  

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginView());
        case RoutePaths.AddNewPlace:
        return MaterialPageRoute(builder: (_) => AddNewPlace());
        case RoutePaths.MapInput:
        LocationData locationData = settings.arguments as LocationData;
        return MaterialPageRoute(builder: (_) => MapInput(
          locationData: locationData,
        ));
       default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
