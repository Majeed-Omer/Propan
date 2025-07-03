import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/login.dart';
import 'package:flutter_app/auth/verify_forgot_password.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDReciev = "";
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    print("Width ${w}");
    print("Height ${h}");

    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: languageProvider.selectedLanguage == 'en'
                ? EdgeInsets.only(
                    left: 600 < w && 1300 > w ? h * 0.008 : h * 0.02,
                    bottom: w < 400 && h < 700 ? h * 0.02 : 0.0)
                : EdgeInsets.only(
                    right: 600 < w && 1300 > w ? h * 0.008 : h * 0.02,
                    bottom: w < 400 && h < 700 ? h * 0.02 : 0.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Transform.scale(
                scale: 600 < w && 1300 > w
                    ? h * 0.0008
                    : h *
                        0.002, // Adjust the scale factor to make the icon bigger
                child: languageProvider.selectedLanguage == 'en'
                    ? Image.asset(
                        "assets/arrow_back.png",
                      )
                    : Image.asset(
                        "assets/arrow_back_ar.png",
                      ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(CircleBorder(
                    side: BorderSide(width: 2.0, color: Colors.black))),
                backgroundColor:
                    MaterialStateProperty.all(globalColor), // <-- Button color
              ),
            ),
          ),
          title: Text(AppLocalizations.of(context)!.forgotPasswordTitle,
              style: TextStyle(
                color: Colors.black,
                fontSize: (w + h) * 0.016,
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
              Image.asset(
                'assets/propan.png',
                fit: BoxFit.cover,
                width: w > 600 ? w * 0.55 : w * 0.60,
                height: w > 600 ? h * 0.4 : h * 0.3,
              ),
              SizedBox(
                height: w > 600 ? h * 0.04 : h * 0.055,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: w >= 600 ? h * 0.03 : h * 0.008,
                        horizontal: w * 0.015),
                    margin: EdgeInsets.symmetric(horizontal: w * 0.12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      color: Colors.white,
                      border: Border.all(
                          color: globalColor, width: w > 600 ? 2.0 : 1.0),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '+964',
                          style: TextStyle(
                              color: Colors.black, fontSize: w * 0.04),
                        ),
                        IntrinsicWidth(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: '7@@@@@@@@@',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: w * 0.04),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: h * 0.1,
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
                      if (phoneController.text.isEmpty)
                        errorSnackBar(
                            context, AppLocalizations.of(context)!.noNumber);
                      else
                        verifyNumber();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.resetPassword,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: w >= 300 ? w * 0.05 : w * 0.07),
                    )),
              ),
            ],
          )),
        ));
  }

  Future<void> verifyNumber() async {
    // await auth.setSettings(appVerificationDisabledForTesting: true);
    auth.verifyPhoneNumber(
        phoneNumber: "+964" + phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {
            print("Your are logged in successfully");
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          verificationIDReciev = verificationID;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VerifyForgotPassword(
                  verificationIDReciev: verificationIDReciev,
                  phone_number: "+964" + phoneController.text,
                ),
              ));
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }
}
