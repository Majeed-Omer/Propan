import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/auth/login.dart';
import 'package:flutter_app/driver/wrapper_driver.dart';
import 'package:flutter_app/globals/circular_progress.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/users.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/services/services_crud_users.dart';
import 'package:flutter_app/settings/listTile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListviewDriversWidget extends StatefulWidget {
  const ListviewDriversWidget({super.key});

  @override
  State<ListviewDriversWidget> createState() => _ListviewDriversWidgetState();
}

class _ListviewDriversWidgetState extends State<ListviewDriversWidget> {
  late SharedPreferences preferences;
  late String selectedLanguage;
  // String? imageFile;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      preferences = prefs;
      setState(() {
        selectedLanguage = preferences.getString("lan") ?? "en";
      });
    });
  }

  Future<Users?> getNameFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Users? users =
        await ServicesGetUsers.getUsers(preferences.getString('token') ?? '');
    return users;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return ListView(children: [
      FutureBuilder<Users?>(
          future: getNameFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              String name = snapshot.data!.name;
              String imageFile = snapshot.data!.image;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showPickImage();
                      },
                      child: Stack(children: [
                        imageFile == '' || imageFile == 'null'
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: globalColor, // Set the border color
                                    width: w > 600
                                        ? 2.0
                                        : 1.0, // Set the border width
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/camera.png',
                                    height: w * 0.2,
                                    width: w * 0.2,
                                    fit: BoxFit.fill,
                                  ),
                                ))
                            : ClipOval(
                                child: Image.network(
                                'https://gasapi.hezhin.dev/images/$imageFile',
                                height: w * 0.2,
                                width: w * 0.2,
                                fit: BoxFit.fill,
                              )),
                      ]),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: w >= 1620.0
                              ? h * 0.05
                              : w > 600
                                  ? (h + w) * 0.023
                                  : w * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        InkWell(
                            onTap: () {
                              showBottomSheet();
                            },
                            child: ListTileWidget(
                              txt: AppLocalizations.of(context)!.language,
                              icon: Icon(Icons.language,
                                  size: w > 600
                                      ? (h + w) * 0.023
                                      : (h + w) * 0.025),
                            )),
                        SizedBox(
                          height: w >= 768 ? (h + w) * 0.025 : (h + w) * 0.015,
                        ),
                        InkWell(
                            onTap: () {
                              preferences.setBool("isLoggedIn", false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: ListTileWidget(
                              txt: AppLocalizations.of(context)!.logout,
                              icon: Icon(Icons.logout,
                                  size: w >= 768
                                      ? (h + w) * 0.023
                                      : (h + w) * 0.025),
                            )),
                      ],
                    ),
                  ],
                ),
              );
            }
            return CircularProgress();
          })
    ]);
  }

  showBottomSheet() {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: globalColor, width: w > 600 ? 2.0 : 1.0),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(w > 600 ? 35.0 : 25.0),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: h * 0.31,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: h * 0.015),
                Container(
                  width: w * 0.08,
                  height: h * 0.015,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  AppLocalizations.of(context)!.language,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                SizedBox(height: h * 0.025),
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    Navigator.pop(context);
                    setState(() {
                      LanguageProvider languageProvider =
                          Provider.of<LanguageProvider>(context, listen: false);
                      selectedLanguage = "en"; // Set the selected language
                      languageProvider.setLanguage(selectedLanguage);
                      preferences.setString('lan', selectedLanguage);
                    });
                  },
                  child: Container(
                    height: h * 0.055,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: selectedLanguage == "en"
                                ? Colors.black
                                : Colors.transparent,
                            width: w >= 768 ? 2.0 : 1.0),
                        top: BorderSide(
                            color: selectedLanguage == "en"
                                ? Colors.black
                                : Colors.transparent,
                            width: w >= 768 ? 2.0 : 1.0),
                      ),
                      color: selectedLanguage == "en"
                          ? globalColor
                          : Colors.transparent,
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "English",
                      style: TextStyle(fontSize: w * 0.05),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    Navigator.pop(context);
                    setState(() {
                      LanguageProvider languageProvider =
                          Provider.of<LanguageProvider>(context, listen: false);
                      selectedLanguage = "ku"; // Set the selected language
                      languageProvider.setLanguage(selectedLanguage);
                      preferences.setString('lan', selectedLanguage);
                    });
                  },
                  child: Container(
                    height: h * 0.055,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: selectedLanguage == "ku"
                                ? Colors.black
                                : Colors.transparent,
                            width: w >= 768 ? 2.0 : 1.0),
                        top: BorderSide(
                            color: selectedLanguage == "ku"
                                ? Colors.black
                                : Colors.transparent,
                            width: w >= 768 ? 2.0 : 1.0),
                      ),
                      color: selectedLanguage == "ku"
                          ? globalColor
                          : Colors.transparent,
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "کوردی",
                      style: TextStyle(fontSize: w * 0.05),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    Navigator.pop(context);
                    setState(() {
                      LanguageProvider languageProvider =
                          Provider.of<LanguageProvider>(context, listen: false);
                      selectedLanguage = "ar"; // Set the selected language
                      languageProvider.setLanguage(selectedLanguage);
                      preferences.setString('lan', selectedLanguage);
                    });
                  },
                  child: Container(
                    height: h * 0.055,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: selectedLanguage == "ar"
                                ? Colors.black
                                : Colors.transparent,
                            width: w >= 768 ? 2.0 : 1.0),
                        top: BorderSide(
                            color: selectedLanguage == "ar"
                                ? Colors.black
                                : Colors.transparent,
                            width: w >= 768 ? 2.0 : 1.0),
                      ),
                      color: selectedLanguage == "ar"
                          ? globalColor
                          : Colors.transparent,
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "العربیة",
                      style: TextStyle(fontSize: w * 0.05),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showPickImage() {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: globalColor, width: w > 600 ? 2.0 : 1.0),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(w > 600 ? 35.0 : 25.0),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: h * 0.25,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: h * 0.015),
                Container(
                  width: w * 0.08,
                  height: h * 0.015,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  AppLocalizations.of(context)!.pickImage,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                SizedBox(height: h * 0.025),
                InkWell(
                  onTap: () => pickIamge(ImageSource.camera),
                  child: ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      size: w >= 768 ? (h + w) * 0.023 : (h + w) * 0.025,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.camera,
                      style: TextStyle(fontSize: w * 0.05),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: w > 600 ? (h + w) * 0.023 : (h + w) * 0.025,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => pickIamge(ImageSource.gallery),
                  child: ListTile(
                    leading: Icon(
                      Icons.image,
                      size: w >= 768 ? (h + w) * 0.023 : (h + w) * 0.025,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.gallery,
                      style: TextStyle(fontSize: w * 0.05),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: w > 600 ? (h + w) * 0.023 : (h + w) * 0.025,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future pickIamge(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        final imageTemporary = File(image.path);
        print("Image path: ${imageTemporary}");
        ServicesGetUsers.uploadImage(imageTemporary);
      });
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WrapperDriver(),
        ),
      );
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }
}
