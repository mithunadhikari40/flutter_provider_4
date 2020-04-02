import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/core/services/home_view_service.dart';
import 'package:flutter_provider_arch/utils/location_helper.dart';
import 'package:flutter_provider_arch/viewmodels/base_view_model.dart';
import 'package:location/location.dart';

class HomeViewViewModel extends BaseViewModel {
  final HomeViewService homeViewService;

  HomeViewViewModel({this.homeViewService}) {
    checkConnection();
  }
  bool _isConnected = false;
  bool get isConnected =>_isConnected;

  getAllPlaces() async {
    setBusy(true);
    homeViewService.getAllPlacesFromLocal();
    //  homeViewService.getAllPlacesFromServer();
    setBusy(false);
  }

  insertPlace(String title, String imagePath, LocationData location) async {
    setBusy(true);

    String address = await LocationHelper.getAddressFromCoordinates(
        location.latitude, location.longitude);

    String id = DateTime.now().toIso8601String();
    Place place = Place(
        id: id,
        address: address,
        imagePath: imagePath,
        title: title,
        latitude: location.latitude,
        longitude: location.longitude);
    homeViewService.insertPlace(place);
    setBusy(false);
  }

  List<Place> get places => homeViewService.places;

  void checkConnection() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      _isConnected = result != ConnectivityResult.none;
      notifyListeners();
     });
  }

  Future<void> postData(List<Place> places) async {
    await homeViewService.postData(places);
  }
}
