import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/appbar_auth.dart';
import 'package:flutter_app/auth/login.dart';
import 'package:flutter_app/auth/verify.dart';
import 'package:flutter_app/services/auth_services.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDReciev = "";
  TextEditingController nameController = TextEditingController();
  String phoneController = "";
  TextEditingController phoneControllerC = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");

    return Scaffold(
        appBar: AppbarAuth.appBarAuth(
            context, AppLocalizations.of(context)!.signUp),
        // key: navigatorKey,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            vertical: w > 600 ? h * 0.006 : h * 0.03,
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
              Container(
                child: Image.asset(
                  'assets/propan.png',
                  fit: BoxFit.fill,
                  width: w > 600 ? w * 0.5 : w * 0.6,
                  height: w < 400 ? h * 0.25 : h * 0.3,
                ),
              ),
              SizedBox(
                height: w > 600 ? h * 0.026 : h * 0.05,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.12),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: w > 600 ? h * 0.03 : h * 0.025,
                          horizontal: w * 0.015),
                      filled: true,
                      fillColor: Colors.white,
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
                      hintText: AppLocalizations.of(context)!.name,
                      hintStyle: TextStyle(
                          color: Colors.grey[400], fontSize: w * 0.04),
                    ),
                    onChanged: (value) {},
                  )),
              SizedBox(
                height: h * 0.016,
              ),
              // Directionality(
              //   textDirection: TextDirection.ltr,
              //   child: Container(
              //       padding: EdgeInsets.symmetric(
              //           vertical: w >= 600 ? h * 0.027 : h * 0.0075,
              //           horizontal: w * 0.015),
              //       margin: EdgeInsets.symmetric(horizontal: w * 0.12),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(w * 0.03),
              //         color: Colors.white,
              //         border: Border.all(
              //             color: globalColor, width: w > 600 ? 2.0 : 1.0),
              //       ),
              //       child: Row(
              //         children: [
              //           Text(
              //             '+964',
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: w * 0.04,
              //             ),
              //           ),
              //           IntrinsicWidth(
              //             child: TextField(
              //               controller: phoneController,
              //               keyboardType: TextInputType.phone,
              //               decoration: InputDecoration(
              //                 hintText: '7@@@@@@@@@',
              //                 hintStyle: TextStyle(
              //                     color: Colors.grey[400], fontSize: w * 0.04),
              //                 border: InputBorder.none,
              //                 contentPadding: EdgeInsets.zero,
              //               ),
              //             ),
              //           ),
              //         ],
              //       )),
              // ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: w >= 600 ? h * 0.027 : h * 0.0075,
                    // horizontal: w * 0.015,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: w * 0.12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    color: Colors.white,
                    border: Border.all(
                      color: globalColor, // Use your desired color
                      width: w > 600 ? 2.0 : 1.0,
                    ),
                  ),
                  child: IntlPhoneField(
                    controller: phoneControllerC,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: w * 0.04,
                      ),
                      border: InputBorder.none,
                    ),
                    initialCountryCode: 'IQ',
                    onChanged: (phone) {
                      print(phone.completeNumber); // Full phone number
                      setState(() {
                        phoneController = phone.completeNumber;
                      });
                    },
                    onCountryChanged: (phone) {
                      // This callback is triggered when the country code changes
                      print("Country changed to: ${phone.fullCountryCode}");
                      setState(() {
                        phoneController = '+' +
                            phone.fullCountryCode +
                            '' +
                            phoneControllerC.text;
                        print("Phone number chnage: ${phoneController}");
                      });
                    },
                    disableLengthCheck: true,
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.016,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.12),
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: hidePassword,
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
                          icon: hidePassword
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
                              hidePassword = !hidePassword;
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
                      hintText: AppLocalizations.of(context)!.password,
                      hintStyle: TextStyle(
                          color: Colors.grey[400], fontSize: w * 0.04),
                    ),
                    onChanged: (value) {},
                  )),
              SizedBox(
                height: h * 0.035,
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
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          phoneController.isEmpty ||
                          passwordController.text.isEmpty) {
                        errorSnackBar(
                            context, AppLocalizations.of(context)!.emptyFields);
                      } else if (passwordController.text.length < 6) {
                        errorSnackBar(context,
                            AppLocalizations.of(context)!.passwordLess);
                      } else
                        _validator();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.signUp,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: w >= 300 ? w * 0.05 : w * 0.07),
                    )),
              ),
              SizedBox(height: w > 600 ? h * 0.02 : h * 0.025),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Login(), // Replace with your sign-up page
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.haveAccount,
                    style: TextStyle(color: Colors.black, fontSize: w * 0.04),
                    children: <TextSpan>[
                      TextSpan(
                        text: AppLocalizations.of(context)!.login,
                        style: TextStyle(
                          color: globalColor,
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ));
  }

  _validator() async {
    http.Response? response = await AuthServices.validator(
        context, nameController.text, phoneController, passwordController.text);
    Map responseMap = jsonDecode(response!.body);
    if (response.statusCode == 200) {
      verifyNumber();
    } else {
      errorSnackBar(context, responseMap.values.first[0]);
    }
  }

  Future<void> verifyNumber() async {
    try {
      auth.verifyPhoneNumber(
          phoneNumber: phoneController,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // await auth.signInWithCredential(credential).then((value) {
            //   print("Your are logged in successfully");
            // });
          },
          verificationFailed: (FirebaseAuthException exception) {
            print(exception.message);
          },
          timeout: Duration(seconds: 60),
          codeSent: (String verificationID, int? resendToken) {
            verificationIDReciev = verificationID;

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Verify(
                    verificationIDReciev: verificationIDReciev,
                    name: nameController.text,
                    phone_number: phoneController,
                    password: passwordController.text,
                  ),
                ));
            setState(() {});
          },
          codeAutoRetrievalTimeout: (String verificationID) {});
    } catch (e) {
      print("Error during phone number verification: $e");
      errorSnackBar(context, "Error during phone number verification: $e");
    }
  }
}
