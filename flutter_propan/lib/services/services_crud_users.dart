import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/models/users.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServicesGetUsers {
  static const ROOT = baseURL + 'user';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _SOCKET = 'ADD_EMP';

  static Future<Users?> getUsers(String authToken) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.get(
        Uri.parse(ROOT),
        headers: {
          "Authorization":
              "Bearer $authToken", // Add the token to the request headers
        },
      );
      print('getUsers Response: ${response.body}');
      print(response.statusCode);
      print(200 == response.statusCode);
      if (200 == response.statusCode) {
        Users user = parseResponse(response.body);
        print('The user is ${user.name}');
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Users?> getUsersWithId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.get(
        Uri.parse(baseURL + "userWithId/${id}"),
        headers: {
          "Authorization":
              "Bearer $token", // Add the token to the request headers
        },
      );
      print('getUsers Response: ${response.body}');
      print(response.statusCode);
      print(200 == response.statusCode);
      if (200 == response.statusCode) {
        Users user = parseResponse(response.body);
        print('The driver is ${user.name}');
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Users parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    print(parsed);
    return Users.fromJson(parsed);
  }

  static Future<void> uploadImage(File imageFile) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.propan.krd/api/upload-image'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        // Image uploaded successfully
        print('Image uploaded successfully');
        getUsers(token);
      } else {
        // Handle error
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  static Future<bool> resetPassword(String id, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['id'] = id;
      map['password'] = password;
      final response = await http.put(Uri.parse(baseURL + 'reset-password/$id'),
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

  static Future<bool> updateLatLong(double lat, double long) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['latitude'] = lat.toString();
      map['longitude'] = long.toString();
      final response = await http.put(Uri.parse(baseURL + "update-latlong"),
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

  static Future<bool> updateBusy(String busy) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';

    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['busy'] = busy.toString();
      final response = await http.put(Uri.parse(baseURL + "update-busy"),
          headers: {
            "Authorization": "Bearer $token",
          },
          body: map);
      print('updateBusy Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  
  static Future<bool> socket(
      String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      var map = Map<String, dynamic>();
      map['action'] = _SOCKET;

      final response = await http.post(Uri.parse(baseURL + "send-message/${id}"),
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

  static Future<bool> deleteUsers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token") ?? '';
    try {
      final response = await http.delete(
        Uri.parse(ROOT),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      print('deleteUser Response: ${response.body}');
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
