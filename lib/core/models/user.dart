class User {
  int id;
  String name;
  String username;
  User({this.id, this.name, this.username});

  User.initial()
      : id = 0,
        name = '',
        username = '';

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    return {"id": this.id, "name": this.name, "username": this.username};
  }
}
