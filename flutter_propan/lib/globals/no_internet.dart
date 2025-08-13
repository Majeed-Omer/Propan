import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 242, 242, 242),
        // key: UniqueKey(),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.noInternet,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.05,
                  color: Colors.black),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Image.asset(
              "assets/no_internet.png",
              fit: BoxFit.fill,
              height: h * 0.6,
              width: w * 0.8,
            ),
          ],
        )),
      ),
    );
  }
}
