import 'package:flutter/material.dart';
import 'package:flutter_app/auth/login.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/services/services_crud_users.dart';

class ResetPassword extends StatefulWidget {
  final String id;
  ResetPassword({required this.id});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;
  TextEditingController passwordNewController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.resetPassword,
              style: TextStyle(
                color: Colors.black,
                fontSize: (w + h) * 0.017,
              )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: h * 0.07,
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            vertical: w > 600 ? h * 0.02 : h * 0.04,
          ),
          decoration: BoxDecoration(
              color: Color.fromARGB(
                  255, 242, 242, 242), // Container background color
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.05),
                  topRight: Radius.circular(w * 0.05)),
              border:
                  Border.all(color: globalColor, width: w > 600 ? 2.0 : 1.0)),
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: h * 0.02,
              ),
              Image.asset(
                'assets/reset_password.png',
                fit: BoxFit.contain,
                width: w > 600 ? w * 0.55 : w * 0.60,
                height: w > 600 ? h * 0.4 : h * 0.3,
              ),
              SizedBox(
                height: w > 600 ? h * 0.035 : h * 0.05,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.12),
                  child: TextField(
                    controller: passwordNewController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: hideNewPassword,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: w > 600 ? h * 0.03 : h * 0.025,
                          horizontal: w * 0.015),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Padding(
                        padding: w > 600 && w < 1024
                            ? EdgeInsets.only(right: w * 0.03)
                            : w >= 1024
                                ? EdgeInsets.only(
                                    bottom: w * 0.01, right: w * 0.03)
                                : EdgeInsets.only(right: 0.0),
                        child: IconButton(
                          icon: hideNewPassword
                              ? Icon(
                                  Icons.visibility_off,
                                  color: globalColor,
                                  size: w * 0.05,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: globalColor,
                                  size: w * 0.05,
                                ),
                          onPressed: () {
                            setState(() {
                              hideNewPassword = !hideNewPassword;
                            });
                          },
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: globalColor, width: w > 600 ? 2.0 : 1.0),
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: globalColor, width: w > 600 ? 2.0 : 1.0),
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      hintText: AppLocalizations.of(context)!.newPassword,
                      hintStyle: TextStyle(
                          color: Colors.grey[400], fontSize: w * 0.04),
                    ),
                    onChanged: (value) {},
                  )),
              SizedBox(
                height: h * 0.02,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.12),
                  child: TextField(
                    controller: passwordConfirmController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: hideConfirmPassword,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: w > 600 ? h * 0.03 : h * 0.025,
                          horizontal: w * 0.015),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Padding(
                        padding: w > 600 && w < 1024
                            ? EdgeInsets.only(right: w * 0.03)
                            : w >= 1024
                                ? EdgeInsets.only(
                                    bottom: w * 0.01, right: w * 0.03)
                                : EdgeInsets.only(right: 0.0),
                        child: IconButton(
                          icon: hideConfirmPassword
                              ? Icon(
                                  Icons.visibility_off,
                                  color: globalColor,
                                  size: w * 0.05,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: globalColor,
                                  size: w * 0.05,
                                ),
                          onPressed: () {
                            setState(() {
                              hideConfirmPassword = !hideConfirmPassword;
                            });
                          },
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: globalColor, width: w > 600 ? 2.0 : 1.0),
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: globalColor, width: w > 600 ? 2.0 : 1.0),
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      hintText: AppLocalizations.of(context)!.confirmPassword,
                      hintStyle: TextStyle(
                          color: Colors.grey[400], fontSize: w * 0.04),
                    ),
                    onChanged: (value) {},
                  )),
              SizedBox(
                height: h * 0.04,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: w * 0.01,
                        offset: Offset(0, 3),
                      )
                    ]),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: globalColor,
                      side: BorderSide(
                          color: Colors.black, width: w > 600 ? 2.0 : 1.0),
                      fixedSize: Size(
                          w * 0.5,
                          (h - w) >= 640
                              ? h * 0.05
                              : w >= 1300
                                  ? h * 0.13
                                  : h * 0.09),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                    ),
                    onPressed: () {
                      if (passwordConfirmController.text.isEmpty ||
                          passwordNewController.text.isEmpty)
                        errorSnackBar(
                            context, AppLocalizations.of(context)!.emptyFields);
                      else if (passwordConfirmController.text !=
                          passwordNewController.text)
                        errorSnackBar(context,
                            AppLocalizations.of(context)!.passwordsNotMatches);
                      else
                        _resetPassword(
                            widget.id, passwordConfirmController.text);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.reset,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: w >= 300 ? w * 0.05 : w * 0.07),
                    )),
              ),
            ],
          )),
        ));
  }

  _resetPassword(String id, String password) {
    ServicesGetUsers.resetPassword(id, password).then((result) {
      if (result) {
        print(result);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Login();
            },
          ),
        );
      }
    });
  }
}
