class Place {
  String id;
  String title;
  String address;
  String imagePath;
  double latitude;
  double longitude;
  int synced = 0;

  Place(
      {this.id,
      this.title,
      this.address,
      this.imagePath,
      this.latitude,
      this.longitude,this.synced});

  Place.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    address = map["address"];
    imagePath = map["imagePath"];
    latitude = map["latitude"];
    longitude = map["longitude"];
    synced= map["synced"];
  }

Map<String,dynamic>  toJson() {
    return {
      "id": id,
      "title": title,
      "address": address,
      "imagePath": imagePath,
      "latitude": latitude,
      "longitude": longitude,
      "synced": synced,
    };
  }

  static List<Place> allPlaces (data){
    return data
       .cast<Map<String, dynamic>>()
       .map((obj) => Place.fromJson(obj))
       .toList()
       .cast<Place>();
  }
}
