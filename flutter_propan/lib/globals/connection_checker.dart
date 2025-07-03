import 'dart:async';
import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CheckMyConnection {
  static bool isConnect = false;
  static bool isInit = false;

  static hasConnection(
      {required void Function() hasConnection,
      required void Function() noConnection}) async {
    Timer.periodic(const Duration(seconds: 1), (_) async {
      isConnect = await InternetConnectionChecker().hasConnection;
      if (isInit == false && isConnect == true) {
        isInit = true;
        hasConnection.call();
      } else if (isInit == true && isConnect == false) {
        isInit = false;
        noConnection.call();
      }
    });
  }
}