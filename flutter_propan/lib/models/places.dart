class Places {
  String id;
  String name;
  String latitude;
  String longitude;

  Places(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude});

  factory Places.fromJson(Map<String, dynamic> json) {
    return Places(
      id: json['id'].toString(),
      name: json['name'].toString(),
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
    );
  }
}
