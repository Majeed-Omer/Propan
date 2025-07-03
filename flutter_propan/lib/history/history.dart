import 'package:flutter/material.dart';
import 'package:flutter_app/history/appbar_history.dart';
import 'package:flutter_app/history/gridview_history.dart';
import 'package:flutter_app/globals/globals.dart';

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    // _scaffoldKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // key: _scaffoldKey,
      appBar: AppbarHistory.AppBarHistory(context),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w*0.02),
          decoration: BoxDecoration(
              color: Color.fromARGB(
                  255, 242, 242, 242), // Container background color
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.05),
                  topRight: Radius.circular(w * 0.05)),
              border: Border.all(
                  color: globalColor,
                  width: w > 600 ? 2.0 : 1.0)),
          child: GrideviewHistory()
          ),
    );
  }

}
