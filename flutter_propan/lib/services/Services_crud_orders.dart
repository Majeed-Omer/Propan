import 'dart:convert';
import 'package:flutter_app/models/orders.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Services_Orders {
  static const ROOT = baseURL + 'orders';
  static const _ADD_EMP_ACTION = 'ADD_EMP';

  static Future<List<Orders>> getOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';

    try {
      final response = await http.get(
        Uri.parse(ROOT),
        headers: {
          "Authorization":
              "Bearer $token", // Add the token to the request headers
        },
      );

      print('getOrders Response: ${response.body}');
      print(response.statusCode);

      if (response.statusCode == 200) {
        List<Orders> list = parseResponse(response.body);
        print(list.length);
        return list;
      } else {
        return <Orders>[];
      }
    } catch (e) {
      return <Orders>[];
    }
  }

  static List<Orders> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    print(parsed);
    return parsed.map<Orders>((json) => Orders.fromJson(json)).toList();
  }

  static Future<bool> addOrders(
      String name, String rate, String price, String place_name, String latitude, String longitude) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['name'] = name;
      map['rate'] = rate;
      map['price'] = price;
      map['place_name'] = place_name;
      map['latitude'] = latitude;
      map['longitude'] = longitude;
      final response = await http.post(Uri.parse(ROOT),
          headers: {
            "Authorization":
                "Bearer $token", // Add the token to the request headers
          },
          body: map);
      print('addOrder Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // static Future<bool> updateOrders(
  //     String orId, String name, String rate, String price) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var token = preferences.getString("token") ?? '';
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['action'] = _UPDATE_EMP_ACTION;
  //     map['id'] = orId;
  //     map['name'] = name;
  //     map['rate'] = rate;
  //     map['price'] = price;
  //     final response = await http.put(Uri.parse(ROOT + orId),
  //         headers: {
  //           "Authorization":
  //               "Bearer $token", // Add the token to the request headers
  //         },
  //         body: map);
  //     print('updateOrder Response: ${response.body}');
  //     if (200 == response.statusCode) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // static Future<bool> deleteOrders(String orId) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var token = preferences.getString("token") ?? '';
  //   try {
  //     final response = await http.delete(
  //       Uri.parse(ROOT + orId),
  //       headers: {
  //         "Authorization":
  //             "Bearer $token", // Add the token to the request headers
  //       },
  //     );
  //     print('deleteOrder Response: ${response.body}');
  //     if (200 == response.statusCode) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
