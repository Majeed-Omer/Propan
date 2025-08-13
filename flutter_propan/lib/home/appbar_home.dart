import 'package:flutter/material.dart';
import 'package:flutter_app/home/add_locations_widget.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/main.dart';
import 'package:provider/provider.dart';

class AppbarHome {
  static AppBar AppBarHome(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("H$h");
    print("W$w");
    return AppBar(
      toolbarHeight: h * 0.07,
      actions: [
        Padding(
          padding: languageProvider.selectedLanguage == 'en'
              ? EdgeInsets.only(right: w * 0.35)
              : EdgeInsets.only(left: w * 0.4), // Adjust the padding here
          child: Row(
            children: [
              AddLocationsWidget(),
              Text(
                AppLocalizations.of(context)!.home,
                style: TextStyle(
                    fontSize: w*0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}
