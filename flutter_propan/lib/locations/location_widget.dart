import 'package:flutter/material.dart';
import 'package:flutter_app/globals/globals.dart';

// ignore: must_be_immutable
class LocationWidget extends StatelessWidget {
  String name;
  LocationWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: w > 600 ? h * 0.12 : h * 0.09,
        decoration: BoxDecoration(
          border: Border.all(
              color: globalColor,
              width: w > 600 ? 2.0 : 1.0),
          borderRadius: BorderRadius.circular(w * 0.045),
          color: Colors.white,
        ),
        child: Center(
          child: ListTile(
            trailing: Icon(
              Icons.location_on,
              color: Colors.black,
              size: w * 0.06,
            ),
            title: Text(
              name,
              // style: TextStyle(fontSize: w > h ? h * 0.05 : w * 0.06),
              style: TextStyle(fontSize: w * 0.06, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
