class Orders {
  String id;
  String name;
  String rate;
  String price;
  String created_at;
  String pay;
  String driver_id;
  String place_name;
  String latitude;
  String longitude;

  Orders(
      {required this.id,
      required this.name,
      required this.rate,
      required this.price,
      required this.created_at,
      required this.pay,
      required this.driver_id,
      required this.place_name,
      required this.latitude,
      required this.longitude});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
        id: json['id'].toString(),
        name: json['name'].toString(),
        rate: json['rate'].toString(),
        price: json['price'].toString(),
        created_at: json['created_at'].toString(),
        pay: json['pay'].toString(),
        driver_id: json['driver_id'].toString(),
        place_name: json['place_name'].toString(),
        latitude: json['latitude'].toString(),
        longitude: json['longitude'].toString());
  }
}
