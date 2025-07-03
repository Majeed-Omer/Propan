import 'package:flutter/material.dart';
import 'package:flutter_app/google_map/google_map_page.dart';
import 'package:flutter_app/locations/location.dart';
import 'package:flutter_app/globals/globals.dart';

class FloatLocationWidget extends StatelessWidget {
  const FloatLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: w > 1300 ? h * 0.15 : h * 0.09,
      height: w > 1300 ? h * 0.15 : h * 0.09,
      child: FloatingActionButton(
        backgroundColor: globalColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GooglMapPage(
                      page: Location(),
                    )),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: w > 1300 ? h * 0.09 : h * 0.04,
        ),
        shape: CircleBorder(
          side: BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    );
  }
}
