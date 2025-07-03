import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListTileWidget extends StatelessWidget {
  String txt;
  Icon icon;
  ListTileWidget({required this.txt, required this.icon});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");
    return ListTile(
      leading: icon,
      title: Text(
        txt,
        style:
            TextStyle(fontSize: w > 600 ? (h + w) * 0.02 : (h + w) * 0.015),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: w > 600 ? (h + w) * 0.023 : (h + w) * 0.025,
      ),
    );
  }
}
