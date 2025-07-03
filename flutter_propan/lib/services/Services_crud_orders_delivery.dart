import 'dart:convert';
import 'package:flutter_app/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/orders_Delivery.dart';

class ServicesOrdersDelivery {
  static const ROOT = baseURL+'ordersDelivery';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';

  static Future<List<OrdersDelivery>> getOrdersDelivery() async {
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
        List<OrdersDelivery> list = parseResponse(response.body);
        print(list.length);
        return list;
      } else {
        return <OrdersDelivery>[];
      }
    } catch (e) {
      return <OrdersDelivery>[];
    }
  }

  static List<OrdersDelivery> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    print(parsed);
    return parsed.map<OrdersDelivery>((json) => OrdersDelivery.fromJson(json)).toList();
  }

  static Future<bool> updateOrders(
      String orId, String pay) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['id'] = orId;
      map['pay'] = pay;
            final response = await http.put(Uri.parse(ROOT + '/$orId'),
          headers: {
            "Authorization":
                "Bearer $token", // Add the token to the request headers
          },
          body: map);
      print('updateOrder Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

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
