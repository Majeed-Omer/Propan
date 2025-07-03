import 'dart:convert';
import 'package:flutter_app/models/places.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
 
class ServicesPlacesCrud {
  static const ROOT = baseURL + 'places';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';

  static Future<List<Places>> getPlaces() async {
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
      print('getPlaces Response: ${response.body}');
      print(response.statusCode);
      print(200 == response.statusCode);
      if (200 == response.statusCode) {
        List<Places> list = parseResponse(response.body);
        print(list.length);
        return list;
      } else {
        return <Places>[];
      }
    } catch (e) {
      return <Places>[];
    }
  }

  static List<Places> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    print(parsed);
    return parsed.map<Places>((json) => Places.fromJson(json)).toList();
  }

  static Future<bool> addPlaces(String name, double lat, double lon) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['name'] = name;
      map['latitude'] = lat.toString();
      map['longitude'] = lon.toString();
      final response = await http.post(Uri.parse(ROOT),
          headers: {
            "Authorization": "Bearer $token",
          },
          body: map);
      print('addPlace Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updatePlaces(
      String plId, String name, double lat, double long) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['id'] = plId;
      map['name'] = name;
      map['latitude'] = lat.toString();
      map['longitude'] = long.toString();
      final response = await http.put(Uri.parse(ROOT + '/$plId'),
          headers: {
            "Authorization": "Bearer $token",
          },
          body: map);
      print('updatePlaces Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deletePlaces(String plId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      final response = await http.delete(
        Uri.parse(ROOT + '/$plId'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      print('deletePlace Response: ${response.body}');
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
