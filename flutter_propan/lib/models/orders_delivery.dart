class OrdersDelivery {
  String id;
  String name;
  String rate;
  String price;
  String created_at;
  String place_name;
  String latitude;
  String longitude;
  String user_id;
  String pay;
  String driver_id;
  UserData user; // Use the UserData class for user data

  OrdersDelivery(
      {required this.id,
      required this.name,
      required this.rate,
      required this.price,
      required this.created_at,
      required this.place_name,
      required this.latitude,
      required this.longitude,
      required this.user_id,
      required this.pay,
      required this.user,
      required this.driver_id});

  factory OrdersDelivery.fromJson(Map<String, dynamic> json) {
    return OrdersDelivery(
      id: json['id'].toString(),
      name: json['name'].toString(),
      rate: json['rate'].toString(),
      price: json['price'].toString(),
      created_at: json['created_at'].toString(),
      place_name: json['place_name'].toString(),
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      user_id: json['user_id'].toString(),
      pay: json['pay'],
      driver_id: json['driver_id'].toString(),
      user: UserData.fromJson(json['user']), // Parse the nested user map
    );
  }
}

class UserData {
  String id;
  String name;
  String phone_number;
  String roles;

  UserData({
    required this.id,
    required this.name,
    required this.phone_number,
    required this.roles,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'].toString(),
      name: json['name'].toString(),
      phone_number: json['phone_number'].toString(),
      roles: json['roles'].toString(),
    );
  }
}
