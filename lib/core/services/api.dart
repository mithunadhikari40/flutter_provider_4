import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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
      if (data["id"] == null) {
        return null;
      }
      // Convert and return
      return User.fromJson(data);
    } catch (e) {
      print("Login exception $e");
      return null;
    }
  }

  Future<List<Place>> getAllPlace() async {
    try {
      var response = await http.get(root);
      if (response == null || response.body == null) {
        return null;
      }
      Map<String, dynamic> data = jsonDecode(response.body);
      var values = data.values.toList();
      var keys= data.keys.toList();
      for(int i =0;i<values.length;i++){
        values[i]["id"]= keys[i];
      }

      print("the decoded data $values");

      return Place.allPlaces(values);
    } catch (e) {
      print("Firebase error $e");
      return null;
    }
  }

  Future postData(Place place) async {
    var uploadedImage = await uploadImage(place.imagePath);
    if(uploadedImage == null){
      return;
    }
    place.imagePath = uploadedImage;

    try {
      var response = await http.post(root, body: jsonEncode(place.toJson()));
      print("${response.body} and status code ${response.statusCode}");

      return jsonDecode(response.body);
    } catch (e) {

      return null;
    }
  }

  Future<String> uploadImage(String imagePath) async {
    final dio = Dio();
    try {
      FormData formData = FormData.fromMap({
        "key": "67e231173a8282ffb9093898968ce731",
        "image": await MultipartFile.fromFile(imagePath),
      });
      var response =
          await dio.post("https://api.imgbb.com/1/upload", data: formData);
      var body = response.data;
      return body["data"]["image"]["url"];
    } catch (e) {
      print("Image upload exception $e");
      return null;
    }
  }

 Future<bool> deleteItem(String id) async {
   print("the delete id is $id");
   final deleteUrl ="https://recommend-places-fd237.firebaseisdkljdfo.com/places/$id.json";
   try{
     final response = await http.delete(deleteUrl);
     print("The delete response ${response.body}");
     if(response.statusCode == 200){
       return true;
     }
     return false;
   }catch(e){
     return false;
   }

 }
}
