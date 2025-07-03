import 'dart:convert';
import 'package:flutter_app/models/datas.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServicesReadDatas {
  static const ROOT = baseURL + 'datas';
  static const _GET_ALL_ACTION = 'GET_ALL';

  static Future<Datas?> getDatas(String lang) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.get(
        Uri.parse(ROOT + '/$lang'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      print('getDatas Response: ${response.body}');
      print(response.statusCode);
      print(200 == response.statusCode);
      if (200 == response.statusCode) {
        Datas?
         datas = parseResponse(response.body);
        return datas;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

 static Datas? parseResponse(String responseBody) {
  try {
    final List<dynamic> parsed = json.decode(responseBody);
    if (parsed.isNotEmpty) {
      final Map<String, dynamic> data = parsed[0];
      return Datas.fromJson(data);
    } else {
      // Handle the case where the array is empty
      return null;
    }
  } catch (e) {
    // Handle JSON decoding error
    print('Error decoding JSON: $e');
    return null;
  }
}


  static Future<List<Datas>> getContacts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.get(
        Uri.parse(ROOT),
        headers: {
          "Authorization":
              "Bearer $token", // Add the token to the request headers
        },
      );
      print('getDatas Response: ${response.body}');
      print(response.statusCode);
      print(200 == response.statusCode);
      if (200 == response.statusCode) {
        List<Datas> list = parseResponseContacts(response.body);
        print(list.length);
        return list;
      } else {
        return <Datas>[];
      }
    } catch (e) {
      return <Datas>[];
    }
  }

  static List<Datas> parseResponseContacts(String responseBody) {
    final parsed = json.decode(responseBody);
    print(parsed);
    return parsed.map<Datas>((json) => Datas.fromJson(json)).toList();
  }


}
