import 'package:flutter/material.dart';
import 'package:flutter_app/about_us/appbar_widget_about_us.dart';
import 'package:flutter_app/globals/circular_progress.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/models/datas.dart';
import 'package:flutter_app/services/services_read_datas.dart';
import 'package:provider/provider.dart';
import '../main.dart';

// ignore: camel_case_types
class About_Us extends StatefulWidget {
  @override
  State<About_Us> createState() => _About_UsState();
}

class _About_UsState extends State<About_Us> {
  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");

    return Scaffold(
        appBar: AppbarWidgetAboutUS.appBarWidgetAboutUs(context),
        body: Container(
            padding:
                EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.03),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 242, 242, 242),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(w * 0.05),
                    topRight: Radius.circular(w * 0.05)),
                border: Border.all(
                    color: globalColor, width: w >= 768 ? 2.0 : 1.0)),
            child: FutureBuilder<Datas?>(
              future:
                  ServicesReadDatas.getDatas(languageProvider.selectedLanguage),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While data is still loading
                  return CircularProgress();
                } else if (snapshot.hasError) {
                  // If an error occurred
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  // If data is null
                  return Text('Data is null');
                } else {
                  // Data has been successfully loaded
                  Datas? datas = snapshot.data;
                  String text = datas!.text;

                  return SingleChildScrollView(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: w >= 1300 ? w * 0.025 : w * 0.039,
                      ),
                    ),
                  );
                }
              },
            )));
  }
}
