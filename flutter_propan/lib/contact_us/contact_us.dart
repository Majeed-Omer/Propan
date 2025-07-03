import 'package:flutter/material.dart';
import 'package:flutter_app/contact_us/appbar_widget_contact_us.dart';
import 'package:flutter_app/contact_us/column_widget_contact_us.dart';
import 'package:flutter_app/globals/globals.dart';

// ignore: camel_case_types
class Contact_Us extends StatelessWidget {
  const Contact_Us({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");
    return Scaffold(
        appBar: AppbarWidgetContactUs.appBarWidgetContectUs(context),
        body: Container(
            padding:
                EdgeInsets.symmetric(vertical: h * 0.04, horizontal: w * 0.05),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromARGB(
                    255, 242, 242, 242), // Container background color
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(w * 0.05),
                    topRight: Radius.circular(w * 0.05)),
                border:
                    Border.all(color: globalColor, width: w > 600 ? 2.0 : 1.0)),
            child: SingleChildScrollView(child: ColumnWidgetContactUs())));
  }
}
