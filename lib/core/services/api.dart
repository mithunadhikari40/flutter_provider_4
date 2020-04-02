import 'dart:convert';

import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/core/models/user.dart';
import 'package:http/http.dart' as http;

/// The service responsible for networking requests
class Api {
  static const endpoint = 'https://jsonplaceholder.typicode.com';
      var root = "https://recommend-places-fd237.firebaseio.com/places.json";


  var client = new http.Client();

  Future<User> getUserProfile(int userId) async {
    try {
      // Get user profile for id
      var response = await client.get('$endpoint/users/$userId');
      print("Response ${response.body}");
      final data = jsonDecode(response.body);
      if(data["id"]== null){
        return null;
      }
      // Convert and return
      return User.fromJson(data);
    } catch (e) {
      print("Login exception $e");
      return null;
    }
  }

  Future<List<Place>> getAllPlace() async{
    try{
      var response = await http.get(root);
      if(response == null || response.body == null){
        return null;
      }
      var data = jsonDecode(response.body);
      return Place.allPlaces(data);
    
    }catch(e){
      print("Firebase error $e");
      return null;
    }
  }
    Future postData(Place place) async{
      try{
        var response = await http.post(root,body:jsonEncode(place.toJson()));
        print(response.body);


      }catch(e){

      }

    }
    
  

}
