import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/appbar_auth.dart';
import 'package:flutter_app/auth/reset_password.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/models/users.dart';
import 'package:flutter_app/services/auth_services.dart';
import 'package:flutter_app/services/services_crud_users.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class VerifyForgotPassword extends StatefulWidget {
  final String verificationIDReciev;
  final String phone_number;
  VerifyForgotPassword({
    required this.verificationIDReciev,
    required this.phone_number,
  });

  @override
  State<VerifyForgotPassword> createState() => _VerifyForgotPasswordState();
}

class _VerifyForgotPasswordState extends State<VerifyForgotPassword> {
// Add this line
  List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  // List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");
    return Scaffold(
        appBar: AppbarAuth.appBarAuth(
            context, AppLocalizations.of(context)!.verify),
        body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(
                vertical: w > 600 ? h * 0.02 : h * 0.04, horizontal: w * 0.08),
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
                Image.asset(
                  'assets/verify.png',
                  fit: BoxFit.cover,
                  width: w > 600 ? w * 0.55 : w * 0.60,
                  height: w > 600 ? h * 0.4 : h * 0.3,
                ),
                SizedBox(
                  height: w > 600 ? h * 0.035 : h * 0.05,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: w >= 1300 ? w * 0.06 : w * 0.1,
                        height: w >= 1300 ? w * 0.06 : w * 0.1,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: globalColor, width: w * 0.005),
                          borderRadius: BorderRadius.circular(
                              w >= 1300 ? w * 0.02 : w * 0.03),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: otpControllers[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: TextStyle(
                              fontSize: w > 600 ? w * 0.05 : w * 0.045,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintText: ' ',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty &&
                                index < otpControllers.length - 1) {
                              // Move focus to the next field
                              // otpFocusNodes[index + 1].requestFocus();
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty) {
                              // Stay in the current field
                            } else {
                              // Last field, remove focus to hide the keyboard
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: (h + w) * 0.04,
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
                        if (otpControllers[0].text.isEmpty ||
                            otpControllers[1].text.isEmpty ||
                            otpControllers[2].text.isEmpty ||
                            otpControllers[3].text.isEmpty ||
                            otpControllers[4].text.isEmpty ||
                            otpControllers[5].text.isEmpty)
                          errorSnackBar(context,
                              AppLocalizations.of(context)!.emptyCodes);
                        else
                          verifyCode();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.verify,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: w >= 300 ? w * 0.055 : w * 0.07),
                      )),
                )
              ],
            ))));
  }

  loginPressed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (widget.phone_number.isNotEmpty) {
      http.Response? response =
          await AuthServices.forgotPassword(widget.phone_number);
      Map responseMap = jsonDecode(response!.body);
      if (response.statusCode == 200) {
        print("Number saved successully");
        String authToken =
            responseMap["token"]; // Assuming your token key is "token"
        preferences.setString('token', authToken);
        Users? users = await ServicesGetUsers.getUsers(authToken);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ResetPassword(id: users!.id);
            },
          ),
        );
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, AppLocalizations.of(context)!.emptyFields);
    }
  }

  Future<void> verifyCode() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String smsCode =
        otpControllers.map((controller) => controller.text).join('');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationIDReciev, smsCode: smsCode);
    try {
      await auth.signInWithCredential(credential).then((value) {
        loginPressed();
      });
    } catch (e) {
      print("Wrong code entered: $e");
      errorSnackBar(context, AppLocalizations.of(context)!.wrongCode);
    }
  }
}
