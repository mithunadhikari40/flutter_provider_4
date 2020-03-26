import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/core/services/home_view_service.dart';
import 'package:flutter_provider_arch/viewmodels/base_view_model.dart';

class HomeViewViewModel extends BaseViewModel{
  final HomeViewService homeViewService;

  HomeViewViewModel({this.homeViewService});

   getAllPlaces(){
     homeViewService.getAllPlacesFromLocal();
     homeViewService.getAllPlacesFromServer();
   }

   List<Place> get places => homeViewService.places; 
}