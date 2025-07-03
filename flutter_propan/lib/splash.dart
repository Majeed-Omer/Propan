import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/signup.dart';
import 'package:flutter_app/globals/connection_checker.dart';
import 'package:flutter_app/driver/wrapper_driver.dart';
import 'package:flutter_app/globals/circular_progress.dart';
import 'package:flutter_app/globals/no_internet.dart';
import 'package:flutter_app/home/home.dart';
import 'package:flutter_app/on_boarding.dart';
import 'package:flutter_app/wrapper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var isDriver;
  var result;
  late Timer _timer;
  var firstTime;

  void _startTimer() {
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FutureBuilder<bool>(
            future: _checkLoggedInStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return CircularProgress();
              } else {
                bool isLoggedIn = snapshot.data ?? false;
                return firstTime
                    ? OnBoarding()
                    : isLoggedIn
                        ? isDriver == 'driver'
                            ? WrapperDriver()
                            : Wrapper(
                                child: Home(),
                                nav: 'home',
                                index: 0,
                              )
                        : Signup();
              }
            },
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    CheckMyConnection.hasConnection(hasConnection: () {
      if (mounted) {
        print("CONNECTED");

        _startTimer();
      }
    }, noConnection: () {
      if (mounted) {
        print("DISCONNED");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => NoInternet()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        key: navigatorKey,
        body: Center(
            child: Image.asset(
          "assets/propan.png",
          fit: BoxFit.contain,
          width: w > 600 ? w * 0.65 : w * 0.75,
          height: w > 600 ? h * 0.55 : h * 0.45,
        )));
  }

  Future<bool> _checkLoggedInStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    result = await InternetConnectionChecker().hasConnection;
    isDriver = preferences.getString('isDriver');
    firstTime = preferences.getBool("firstTime") ?? true;    
    return preferences.getBool("isLoggedIn") ?? false;
  }
}
