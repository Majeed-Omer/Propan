import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HistoryWidget extends StatelessWidget {
  String name;
  String rate;
  String price;
  String created_at;
  HistoryWidget(
      {required this.name,
      required this.rate,
      required this.price,
      required this.created_at});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);

    return Card(
        elevation: 5.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              name == 'Bottle'
                  ? "assets/Bottle.jpg"
                  : name == 'Liter'
                      ? "assets/liter_gas.jpg"
                      : "assets/ton_gas.png",
              height: w * 0.32,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name == "Bottle"
                            ? AppLocalizations.of(context)!.bottle
                            : name == "Liter"
                                ? AppLocalizations.of(context)!.liter
                                : AppLocalizations.of(context)!.ton,
                        style: TextStyle(
                          fontSize: w < 400
                              ? w * 0.035
                              : h - w < 400
                                  ? w * 0.03
                                  : w > 600
                                      ? w * 0.03
                                      : w * 0.035,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        rate,
                        style: TextStyle(
                          fontSize: w < 400
                              ? w * 0.035
                              : h - w < 400
                                  ? w * 0.03
                                  : w > 600
                                      ? w * 0.03
                                      : w * 0.035,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: languageProvider.selectedLanguage == 'en'
                        ? (h - w >= 1000
                            ? h * 0.005
                            : w > 600
                                ? h * 0.02
                                : h * 0.01)
                        : (h - w >= 1000
                            ? h * 0.001
                            : w > 600
                                ? h * 0.009
                                : h * 0.005),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${price}\$',
                        style: TextStyle(
                          fontSize: w < 400
                              ? w * 0.035
                              : h - w < 400
                                  ? w * 0.03
                                  : w > 600
                                      ? w * 0.03
                                      : w * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        languageProvider.selectedLanguage == 'en'
                            ? DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(created_at))
                            : languageProvider.selectedLanguage == 'ar'
                                ? DateFormat('yyyy-MM-dd', 'ar_SA')
                                    .format(DateTime.parse(created_at))
                                : DateFormat('yyyy-MM-dd', 'ku')
                                    .format(DateTime.parse(created_at)),
                        style: TextStyle(
                          fontSize: w < 400
                              ? w * 0.035
                              : h - w < 400
                                  ? w * 0.03
                                  : w > 600
                                      ? w * 0.03
                                      : w * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      
    );
  }
}
