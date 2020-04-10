class Place {
  String id;
  String title;
  String address;
  String imagePath;
  double latitude;
  double longitude;
  int synced = 0;
  num rating;

  Place(
      {this.id,
      this.title,
      this.address,
      this.imagePath,
      this.latitude,
      this.longitude,
      this.synced,
      this.rating});

  Place.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    address = map["address"];
    imagePath = map["imagePath"];
    latitude = map["latitude"];
    longitude = map["longitude"];
    synced = map["synced"];
    rating = map["rating"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "address": address,
      "imagePath": imagePath,
      "latitude": latitude,
      "longitude": longitude,
      "synced": synced,
      "rating": rating ?? 0,
    };
  }

  static List<Place> allPlaces(data) {
    return data
        .cast<Map<String, dynamic>>()
        .map((obj) => Place.fromJson(obj))
        .toList()
        .cast<Place>();
  }
}
