import 'package:flutter/material.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/settings/appbar_setting.dart';
import 'package:flutter_app/settings/listview_widget.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print(w);
    print(h);
    return Scaffold(
        appBar:AppbarSetting.AppBarSetting(context),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          decoration: BoxDecoration(
              color: Color.fromARGB(
                  255, 242, 242, 242), // Container background color
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.05),
                  topRight: Radius.circular(w * 0.05)),
              border: Border.all(
                  color: globalColor,
                  width: w > 600 ? 2.0 : 1.0)),
          child: ListviewWidget()
        ));
  }
}
