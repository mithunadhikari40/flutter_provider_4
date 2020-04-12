import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/core/services/api.dart';
import 'package:flutter_provider_arch/core/services/db_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeViewService {
  final Api api;
  final DbService dbService;

  HomeViewService({this.api, this.dbService});

  List<Place> _places = [];

  List<Place> get places => List.from(_places);

  getAllPlacesFromLocal() async {
    final data = await dbService.fetchAllPlaces();
    _places.addAll(data);
  }

  getAllPlacesFromServer() async {
    final data = await api.getAllPlace();

    if (data != null) {
      for (var da in data) {
        _places.removeWhere((Place place) {
          return place.id == da.id;
        });
      }

      _places.addAll(data);
      _places = _places.toSet().toList();

      for (var place in data) {
        place.synced = 1;
        dbService.insertPlace(place);
      }
    }
    //todo insert the data into our local db
    //todo make the synced parameter as 1
  }

  void insertPlace(Place place) {
    _places.add(place);
    dbService.insertPlace(place);
  }

  Future postData() async {
    List<Place> allPlace = await dbService.fetchAllUnsyncedPlaces();
    if (allPlace == null) {
      Fluttertoast.showToast(msg: "Nothing to sync");
      return;
    }
    for (var pl in allPlace) {
      var response = await api.postData(pl);
      String newId = response["name"];
      dbService.updateData(pl, newId);
    }
  }

  Future deleteItem(String id) async {
    Place place = _places.firstWhere((el)=>el.id==id);
    int index = _places.indexOf(place);
    
    _places.removeAt(index);

    final isDeleted = await api.deleteItem(id);
    if(isDeleted){
      _places.removeAt(index);
    }else{
      _places.insert(index, place);
    }



  }
}
