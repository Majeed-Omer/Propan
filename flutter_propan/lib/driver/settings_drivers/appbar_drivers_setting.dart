import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class AppbarDriversSetting {
  static AppBar AppBarSetting(BuildContext context) {
        final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return AppBar(
      title: Text(AppLocalizations.of(context)!.setting,
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
