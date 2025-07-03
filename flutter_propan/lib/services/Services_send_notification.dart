import 'package:flutter_app/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServicesSendNotification{

  static Future<bool> storeDeviceId(
      String device_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['device_id'] = device_id;
      final response = await http.post(Uri.parse(baseURL + 'device-id'),
          headers: {
            "Authorization":
                "Bearer $token", // Add the token to the request headers
          },
          body: map);
      print('store device id: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> sendNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      final response = await http.post(Uri.parse(baseURL + 'send-notification'),
          headers: {
            "Authorization":
                "Bearer $token", // Add the token to the request headers
          },
          body: map);
      print('notification: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
