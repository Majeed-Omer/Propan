import 'package:flutter/material.dart';
import 'package:flutter_app/contact_us/row_social_widget.dart';
import 'package:flutter_app/contact_us/row_widget_contact_us.dart';
import 'package:flutter_app/globals/circular_progress.dart';
import 'package:flutter_app/models/datas.dart';
import 'package:flutter_app/services/services_read_datas.dart';

class ColumnWidgetContactUs extends StatefulWidget {
  const ColumnWidgetContactUs({super.key});

  @override
  State<ColumnWidgetContactUs> createState() => _ColumnWidgetContactUsState();
}

class _ColumnWidgetContactUsState extends State<ColumnWidgetContactUs> {
  late List<Datas> _datas;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _datas = [];
    _getDats();
  }

  _getDats() {
    ServicesReadDatas.getContacts().then((datas) {
      setState(() {
        _datas = datas;
        _isLoading = false;
      });
      print("Datas Length: ${datas.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return CircularProgress();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // RowWidgetContactUs(
          //     image: 'assets/call.png',
          //     text: AppLocalizations.of(context)!.phone),
          // Divider(
          //   color: Colors.black,
          //   thickness: w > 600 ? 2 : 1,
          // ),
          // SizedBox(
          //   height: h * 0.02,
          // ),
          RowWidgetContactUs(
              image: 'assets/call.png', text: _datas.first.phone_number),
          Divider(
            color: Colors.black,
            thickness: w > 600 ? 2 : 1,
          ),
          SizedBox(
            height: h * 0.02,
          ),
          RowWidgetContactUs(
              image: 'assets/email.png', text: _datas.first.email),
          Divider(
            color: Colors.black,
            thickness: w > 600 ? 2 : 1,
          ),
          SizedBox(
            height: h * 0.06,
          ),
          RowSocialWidget(),
          SizedBox(
            height: h * 0.06,
          ),
          Center(
              child: Text(
            "WWW.propan.com",
            style: TextStyle(fontSize: w > 600 ? w * 0.045 : w * 0.04),
          )),
          SizedBox(
            height: w > 600 ? h * 0.04 : h * 0.03,
          ),
          Center(
              child: Text(
            "Score Company @ Copyright 2023",
            style: TextStyle(fontSize: w > 600 ? w * 0.04 : w * 0.035),
          )),
        ],
      ),
    );
  }
}
