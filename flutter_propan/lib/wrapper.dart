// ignore_for_file: must_be_immutable
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/history/history.dart';
import 'package:flutter_app/home/home.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/settings/setting.dart';

class Wrapper extends StatefulWidget {
  Widget child = Home();
  String nav = 'home';
  int index = 0;

  Wrapper({required this.child, required this.nav, required this.index});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print(w);
    print(h);

    // Adjust the icon sizes and container sizes based on screen width
    double iconSize = w > 600 ? 30 : 24;
    double containerSize = w > 600 ? 45 : 35;

    return Scaffold(
      body: widget.child,
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey,
        buttonBackgroundColor: Colors.black,
        color: globalColor,
        height: w > 600 ? 75 : 60,
        index: widget.index,
        items: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.home,
              size: iconSize,
              color: widget.nav == 'home' ? Colors.white : Colors.grey,
            ),
          ),
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.history,
              size: iconSize,
              color: widget.nav == 'history' ? Colors.white : Colors.grey,
            ),
          ),
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.settings,
              size: iconSize,
              color: widget.nav == 'setting' ? Colors.white : Colors.grey,
            ),
          ),
        ],
        onTap: (index) => _handleNavigationChange(index),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          widget.child = Home();
          widget.nav = 'home';
          break;
        case 1:
          widget.child = History();
          widget.nav = 'history';
          break;
        case 2:
          widget.child = Setting();
          widget.nav = 'setting';
          break;
      }
    });
  }
}
