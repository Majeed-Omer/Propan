import 'package:flutter/material.dart';

class AppbarAuth {
  static AppBar appBarAuth(BuildContext context, String text) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return AppBar(
      title: Text(text,
          style: TextStyle(
            color: Colors.black,
            fontSize: (w + h) * 0.02,
          )),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      toolbarHeight: h * 0.07,
    );
  }
}
