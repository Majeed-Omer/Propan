class Users {
  String id;
  String name;
  String phone_number;
  String password;
  String roles;
  String image;
  String device_id;
  String latitude; 
  String longitude;
  String busy;


  Users({
    required this.id,
    required this.name,
    required this.phone_number,
    required this.password,
    required this.roles,
    required this.image,
    required this.device_id,
    required this.latitude,
    required this.longitude,
    required this.busy
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'].toString(),
      name: json['name'].toString(),
      phone_number: json['phone_number'].toString(),
      password: json['password'].toString(),
      roles: json['roles'].toString(),
      image: json['image'].toString(),
      device_id: json['device_id'].toString(),
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      busy: json['busy'].toString()
    );
  }
}
