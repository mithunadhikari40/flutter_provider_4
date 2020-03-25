class Place {
  String id;
  String title;
  String address;
  String imagePath;
  double latitude;
  double longitude;

  Place(
      {this.id,
      this.title,
      this.address,
      this.imagePath,
      this.latitude,
      this.longitude});

  Place.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    address = map["address"];
    imagePath = map["imagePath"];
    latitude = map["latitude"];
    longitude = map["longitude"];
  }

Map<String,dynamic>  toJson() {
    return {
      "id": id,
      "title": title,
      "address": address,
      "imagePath": imagePath,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}
