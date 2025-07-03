import 'package:flutter/material.dart';
import 'package:flutter_app/home/home.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppbarOrder {
  static AppBar appBarMethod(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return AppBar(
      leading: Padding(
        padding: languageProvider.selectedLanguage == 'en'
            ? EdgeInsets.only(
                left: 600 < w && 1300 > w ? h * 0.008 : h * 0.02,
                bottom: w < 400 && h < 700 ? h * 0.02 : 0.0)
            : EdgeInsets.only(
                right: 600 < w && 1300 > w ? h * 0.008 : h * 0.02,
                bottom: w < 400 && h < 700 ? h * 0.02 : 0.0),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Wrapper(
                child: Home(),
                    nav: 'home',
                    index: 0,
              )),
            );
          },
          child: Transform.scale(
            scale: 600 < w && 1300 > w
                ? h * 0.0008
                : h * 0.002, // Adjust the scale factor to make the icon bigger
            child: languageProvider.selectedLanguage == 'en'
                ? Image.asset(
                    "assets/arrow_back.png",
                  )
                : Image.asset(
                    "assets/arrow_back_ar.png",
                  ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder(
                side: BorderSide(
                    width: 2.0,
                    color: Colors
                        .black))), // <-- Adjust the width and color of the border
            backgroundColor: MaterialStateProperty.all(
                globalColor), // <-- Button color
          ),
        ),
      ),
      title: Text(AppLocalizations.of(context)!.order,
          style: TextStyle(
            color: Colors.black,
            fontSize: (w + h) * 0.02,
          )),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      toolbarHeight: h * 0.07,
    );
  }
}
