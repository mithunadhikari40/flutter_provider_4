import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/ui/views/add_new_place.dart';
import 'package:flutter_provider_arch/ui/views/home_view.dart';
import 'package:flutter_provider_arch/ui/views/login_view.dart';
import 'package:flutter_provider_arch/ui/views/place_detail_view.dart';
import 'package:flutter_provider_arch/ui/widgets/map_input.dart';
import 'package:flutter_provider_arch/viewmodels/home_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginView());
      case RoutePaths.AddNewPlace:
        HomeViewViewModel model = settings.arguments as HomeViewViewModel;
        return MaterialPageRoute(
            builder: (_) => AddNewPlace(
                  model: model,
                ));

      case RoutePaths.PlaceDetail:
        Place place = settings.arguments as Place;
        return MaterialPageRoute(
            builder: (_) => PlaceDetailView(
                  place: place,
                ));

      case RoutePaths.MapInput:
        List args = settings.arguments as List;
        LocationData locationData = args[0];
        bool shouldShowIcon = args[1];
        Function(LatLng latlng) onSelectLocation = args[2];

        return MaterialPageRoute(
            builder: (_) => MapInput(
                  locationData: locationData,
                  shouldShowIcon: shouldShowIcon,
                  onSelectLocation: onSelectLocation,
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
