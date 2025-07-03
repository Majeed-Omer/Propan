import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/appbar_auth.dart';
import 'package:flutter_app/google_map/google_map_first.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class Verify extends StatefulWidget {
  final String verificationIDReciev;
  final String name;
  final String phone_number;
  final String password;
  Verify(
      {required this.verificationIDReciev,
      required this.name,
      required this.phone_number,
      required this.password});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

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
                        child: TextFormField(
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
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty) {
                            } else {
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

  Future<void> verifyCode() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String smsCode =
        otpControllers.map((controller) => controller.text).join('');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationIDReciev, smsCode: smsCode);

    try {
      await auth.signInWithCredential(credential).then((value) {
        print("You are logged in successfully");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GoogleMapFirst(
                name: widget.name,
                phone_number: widget.phone_number,
                password: widget.password,
              ),
            ));
      });
    } catch (e) {
      print("Wrong code entered: $e");
      // errorSnackBar(context, AppLocalizations.of(context)!.wrongCode);
      errorSnackBar(context, "Error: $e");
    }
  }
}
