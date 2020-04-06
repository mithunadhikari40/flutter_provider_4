import 'dart:convert';

import 'package:dio/dio.dart' ;
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/core/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


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
      print("Response from server ${response.body}");
      if (response == null || response.body == null) {
        return null;
      }
      Map<String,dynamic> data = jsonDecode(response.body);
      var values = data.values.toList();
      print("the decoded data $values");

      return Place.allPlaces(values);
    } catch (e) {
      print("Firebase error $e");
      return null;
    }
  }


  Future postData(Place place) async {

// var uploadedImage = await uploadImage(place.imagePath);

    try {
      var response = await http.post(root, body: jsonEncode(place.toJson()));
      print("${response.body} and status code ${response.statusCode}" );

      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

 Future<String> uploadImage(String imagePath) async {
   final dio= Dio();
   FormData formData = FormData.fromMap({
     "key":"67e231173a8282ffb9093898968ce731",
     "iamge": MultipartFile.fromFile(imagePath,
          filename: "image.jpg", contentType: MediaType('image', 'jpeg')),
   });
   var response = await dio.post("https://api.imgbb.com/1/upload",data: formData);
   print("Dio response $response");
   return null;

 }
}
