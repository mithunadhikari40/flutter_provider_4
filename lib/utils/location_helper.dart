import 'dart:convert';

import 'package:http/http.dart';

class LocationHelper{
 static const MAP_BOX_KEY
  ="pk.eyJ1IjoiYWRoaWthcmktbWl0aHVuIiwiYSI6ImNrNGNlazEwOTBqN3YzZXBicWw3ZzdjaDcifQ.PTPsY8Dv4iXObiS4aJWlLg";
static String generateStaticImage(double latitude,double longitude){
 return "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/$longitude,$latitude,14,0,60/600x300?access_token=$MAP_BOX_KEY";
}

static Future<String> getAddressFromCoordinates(double lat, double lon) async{
  var response = await get("https://api.mapbox.com/geocoding/v5/mapbox.places/$lon,$lat.json?access_token=$MAP_BOX_KEY");
var data = jsonDecode(response.body);
var placeName = data["features"][0]["place_name"] as String;
return placeName;
}


}