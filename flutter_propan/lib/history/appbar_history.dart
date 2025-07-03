import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppbarHistory {
  static AppBar AppBarHistory(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return AppBar(
      toolbarHeight: h * 0.07,
      title: Text(AppLocalizations.of(context)!.history,
          style: TextStyle(
            color: Colors.black,
            fontSize: (w + h) * 0.02,
          )),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}
