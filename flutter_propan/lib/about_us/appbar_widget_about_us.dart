import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/settings/setting.dart';
import 'package:flutter_app/wrapper.dart';
import 'package:provider/provider.dart';

class AppbarWidgetAboutUS {
  static AppBar appBarWidgetAboutUs(BuildContext context) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Wrapper(
                        child: Setting(),
                        nav: 'setting',
                        index: 2,
                      )),
            );
          },
          child: Transform.scale(
              scale: 600 < w && 1300 > w
                  ? h * 0.001
                  : h * 0.003, // Adjust the scale factor to make the  bigger
              child: Image.asset(
                "assets/cancel.png",
              )),
          style: ButtonStyle(
            shape: WidgetStateProperty.all(CircleBorder(
                side: BorderSide(
                    width: 2.0,
                    color: Colors
                        .black))), // <-- Adjust the width and color of the border
            backgroundColor:
                WidgetStateProperty.all(globalColor), // <-- Button color
          ),
        ),
      ),
      title: Text(AppLocalizations.of(context)!.aboutUs,
          style: TextStyle(
            color: Colors.black,
            fontSize: (w + h) * 0.017,
          )),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      toolbarHeight: h * 0.07,
    );
  }
}
