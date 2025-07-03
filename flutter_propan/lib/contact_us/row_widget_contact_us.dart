// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class RowWidgetContactUs extends StatelessWidget {
  String image;
  String text;
  RowWidgetContactUs({required this.image,required this.text});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          Image.asset(
            image,
            fit: BoxFit.contain,
            height: w > 600 ? h * 0.12 : h * 0.05,
            width: w * 0.1,
          ),
          SizedBox(
            width: w * 0.15,
          ),
          Text(
            text,
            style: TextStyle(fontSize: w > 600 ? w * 0.045 : w * 0.04),
          )
        ],
      ),
    );
  }
}
