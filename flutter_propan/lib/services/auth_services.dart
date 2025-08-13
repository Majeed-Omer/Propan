import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static Future<http.Response?> validator(BuildContext context, String name,
      String phone_number, String password) async {
    Map data = {
      "name": name,
      "phone_number": phone_number,
      "password": password
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'validator');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 400)
      errorSnackBar(context, AppLocalizations.of(context)!.existPhone);
    else {
      // If the response is not successful, handle the error appropriately
      print("signup failed with status code ${response.statusCode}");
      return null;
    }
    return null;
  }

  static Future<http.Response?> signup(BuildContext context, String name,
      String phone_number, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = {
      "name": name,
      "phone_number": phone_number,
      "password": password
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/signup');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // Decode the response body to get the data as a Map
      Map<String, dynamic> responseData = json.decode(response.body);

      // Assuming your token field in the response is named "token", you can access it like this:
      String token = responseData['token'];
      preferences.setString("token", token);

      // Print the token
      print("Token: $token");
      print(response.body);

      return response;
    } else if (response.statusCode == 400)
      errorSnackBar(context, AppLocalizations.of(context)!.existPhone);
    else {
      // If the response is not successful, handle the error appropriately
      print("signup failed with status code ${response.statusCode}");
      return null;
    }
    return null;
  }

  static Future<http.Response?> login(
      BuildContext context, String phone_number, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = {"identifier": phone_number, "password": password};
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // Decode the response body to get the data as a Map
      Map<String, dynamic> responseData = json.decode(response.body);

      // Assuming your token field in the response is named "token", you can access it like this:
      String token = responseData['token'];
      preferences.setString("token", token);

      // Print the token
      print("Token: $token");
      print(response.body);

      return response;
    } else if (response.statusCode == 400) {
      errorSnackBar(context, AppLocalizations.of(context)!.incorrectPhonePass);
    } else {
      // If the response is not successful, handle the error appropriately
      print("login failed with status code ${response.statusCode}");
      return null;
    }
    return null;
  }

  static Future<http.Response?> forgotPassword(String phone_number) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = {"identifier": phone_number};
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/forgot-password');

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Decode the response body to get the data as a Map
        Map<String, dynamic> responseData = json.decode(response.body);

        // Assuming your token field in the response is named "token", you can access it like this:
        String? token = responseData['token'];
        if (token != null) {
          preferences.setString("token", token);

          // Print the token
          print("Token: $token");
          print(response.body);
        } else {
          print("Token not found in the response.");
        }

        return response;
      } else {
        // Handle non-200 status codes (e.g., show an error message to the user)
        print("Request failed with status code ${response.statusCode}");
        print(response.body);
        return response;
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error during request: $e");
      return null;
    }
  }
}
