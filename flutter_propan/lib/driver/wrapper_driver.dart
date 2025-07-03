import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/driver/delivers.dart';
import 'package:flutter_app/driver/settings_drivers/setting_drivers.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/services/services_crud_users.dart';
import 'package:location/location.dart';

class WrapperDriver extends StatefulWidget {
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<WrapperDriver> {
  Widget? _child;
  String nav = 'delivers';
  LocationData? currentLocation;

  @override
  void initState() {
    _child = Delivers();
    super.initState();
    getCurrentLocation();
    Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      print("Majeed");
      LocationData? locationData = await getCurrentLocation();
      print(locationData!.latitude);
      ServicesGetUsers.updateLatLong(
              locationData.latitude!, locationData.longitude!)
          .then((result) {
        if (result) {
          print("Location updated");
        } else {
          print("Location not updated");
        }
      });
    });
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      Location location = Location();
      LocationData locationData = await location.getLocation();
      return locationData;
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print(w);
    print(h);

    // Adjust the icon sizes and container sizes based on screen width
    double iconSize = w < 600 ? 24 : 30;
    double containerSize = w < 600 ? 35 : 45;

    return Scaffold(
      body: _child,
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey,
        buttonBackgroundColor: Colors.black,
        color: globalColor,
        height: w > 600 ? 75 : 60,
        items: [
          Container(
            width: nav == 'delivers' ? containerSize : containerSize,
            height: nav == 'delivers' ? containerSize : containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.local_shipping_sharp,
              size: iconSize,
              color: nav == 'delivers' ? Colors.white : Colors.grey,
            ),
          ),
          Container(
            width: nav == 'setting' ? containerSize : containerSize,
            height: nav == 'setting' ? containerSize : containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.settings,
              size: iconSize,
              color: nav == 'setting' ? Colors.white : Colors.grey,
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
          _child = Delivers();
          nav = 'delivers';
          break;
        case 1:
          _child = SettingDrivers();
          nav = 'setting';
          break;
      }
    });
  }
}
