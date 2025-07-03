import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/locations/location.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AddLocationsWidget extends StatelessWidget {
  const AddLocationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("H$h");
    print("W$w");
    return Padding(
      padding: EdgeInsets.fromLTRB(
          languageProvider.selectedLanguage == 'en'
              ? w * 0.05
              : w > 600 || (w < 380 && h < 670) || (h - w < 390)
                  ? w * 0.2
                  : w * 0.13,
          w >= 1000.0 ? 0.0 : h * 0.01,
          languageProvider.selectedLanguage == 'en'
              ? w > 600 || (w < 380 && h < 670) || (h - w < 390)
                  ? w * 0.15
                  : w * 0.13
              : 0.0,
          w >= 1000.0 ? h * 0.01 : h * 0.01),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: globalColor,
          side: BorderSide(color: Colors.black, width: w >= 768 ? 2.0 : 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.015),
          ),
          fixedSize: Size(
              w > 600
                  ? w * 0.25
                  : h - w < 470
                      ? h * 0.145
                      : h * 0.14,
              w > 600 ? w * 0.25 : h * 0.25),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Location()),
          );
        },
        child: Row(
          children: [
            Image.asset(
              "assets/add_location.png",
              fit: BoxFit.fill,
              height: w * 0.02,
              width: w * 0.02,
            ),
            SizedBox(
              width: w * 0.013,
            ),
            Text(
              AppLocalizations.of(context)!.locations,
              style: TextStyle(
                  fontSize: w > 600
                      ? w * 0.030
                      : w - h < 290
                          ? h * 0.017
                          : h * 0.019,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
