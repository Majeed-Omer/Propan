import 'package:flutter/material.dart';

const String baseURL = "https://api.propan.krd/api/";
const Color globalColor = Color.fromARGB(255, 112, 242, 252);
const Map<String, String> headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.02),
    content: Text(
      text,
      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
    ),
    duration: const Duration(seconds: 2),
  ));
}
