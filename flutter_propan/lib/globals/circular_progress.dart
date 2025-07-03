import 'package:flutter/material.dart';
import 'package:flutter_app/globals/globals.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        body: Center(
            child: CircularProgressIndicator(
          color: globalColor,
        )));
  }
}
