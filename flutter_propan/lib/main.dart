import 'dart:async';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/l10n/l10n.dart';
import 'package:flutter_app/google_map/locationProvider.dart';
import 'package:flutter_app/services/fairbase_api.dart';
import 'package:flutter_app/splash.dart';
import 'package:flutter_kurdish_localization/kurdish_cupertino_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_material_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_widget_localization_delegate.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
      appleProvider: AppleProvider.deviceCheck,
      androidProvider: AndroidProvider.playIntegrity
      //  webRecaptchaSiteKey: '6LeU15EoAAAAAHEmn6NFL9vRuDmaegeXe49WNuOU',
      );
  await FirebaseApi().initNotifications();

  runApp(
    // DevicePreview(
    //   enabled: true,
    //   tools: [
    //     ...DevicePreview.defaultTools,
    //   ],
    //   builder: (context) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: MyApp(),
        ),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()),
    ),
    // ),
  );
}

class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = '';
  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _selectedLanguage = preferences.getString("lan") ?? "en";
    notifyListeners();
  }

  String get selectedLanguage => _selectedLanguage;

  void setLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isDriver;
  var result;
  late LocationData currentLocation;

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      supportedLocales: L10n.all,
      locale: Locale(languageProvider.selectedLanguage),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        KurdishMaterialLocalizations.delegate,
        KurdishWidgetLocalizations.delegate,
        KurdishCupertinoLocalizations.delegate,
      ],
    );
  }
}
