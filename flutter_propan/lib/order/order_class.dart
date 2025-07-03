import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderClass{
  int price = 0;
  static String sign = '';
  static String getSuffixText(BuildContext context, String orderType, String controller) {
      if (orderType == AppLocalizations.of(context)!.liter) {
        return AppLocalizations.of(context)!.liter;
      } else if (orderType == AppLocalizations.of(context)!.bottle) {
        return AppLocalizations.of(context)!.bottle;
      } else if (orderType == AppLocalizations.of(context)!.ton) {
        return AppLocalizations.of(context)!.ton;
      } else {
        return '';
      }
    }

    static int getPrice(BuildContext context,String orderType, String controller) {
      if (orderType == AppLocalizations.of(context)!.bottle) {
        sign = 'N';
        return int.parse(controller) * 5;
      } else if (orderType == AppLocalizations.of(context)!.liter) {
        sign = 'L';
        return int.parse(controller) * 10;
      } else if (orderType == AppLocalizations.of(context)!.ton) {
        sign = 'T';
        return int.parse(controller) * 15;
      } else {
        return 0;
      }
    }
    static String getSign(BuildContext context,String orderType) {
      if (orderType == AppLocalizations.of(context)!.bottle) {
        return 'N';
      } else if (orderType == AppLocalizations.of(context)!.liter) {
        return 'L';
      } else if (orderType == AppLocalizations.of(context)!.ton) {
        return 'T';
      } else {
        return '';
      }
    }
}