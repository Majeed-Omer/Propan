import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/appbar_auth.dart';
import 'package:flutter_app/auth/forgot_password.dart';
import 'package:flutter_app/auth/signup.dart';
import 'package:flutter_app/driver/wrapper_driver.dart';
import 'package:flutter_app/home/home.dart';
import 'package:flutter_app/models/users.dart';
import 'package:flutter_app/services/Services_send_notification.dart';
import 'package:flutter_app/services/auth_services.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/services/services_crud_users.dart';
import 'package:flutter_app/wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDReciev = "";
  String phoneController = '';
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
        appBar:
            AppbarAuth.appBarAuth(context, AppLocalizations.of(context)!.login),
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
              Container(
                child: Image.asset(
                  'assets/propan.png',
                  fit: BoxFit.fill,
                  width: w > 600 ? w * 0.5 : w * 0.60,
                  height: w > 600 ? h * 0.25 : h * 0.3,
                ),
              ),
              SizedBox(
                height: w > 600 ? h * 0.035 : h * 0.03,
              ),
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
                    keyboardType: TextInputType.phone,
                    controller: phoneControllerC,
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
                      print(phone.completeNumber);
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
              // Directionality(
              //   textDirection: TextDirection.ltr,
              //   child: Container(
              //       padding: EdgeInsets.symmetric(
              //           vertical: w >= 600 ? h * 0.03 : h * 0.008,
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
              //                 color: Colors.black, fontSize: w * 0.04),
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
              SizedBox(
                height: h * 0.02,
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
                height: h * 0.015,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ForgotPassword(),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.12),
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    style: TextStyle(
                        color: globalColor,
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
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
                    onPressed: () => loginPressed(),
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: w >= 300 ? w * 0.05 : w * 0.07),
                    )),
              ),
              SizedBox(height: h * 0.03),
              GestureDetector(
                onTap: () {
                  print(phoneController);
                  print(passwordController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Signup(), // Replace with your sign-up page
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.havenotAccount,
                    style: TextStyle(color: Colors.black, fontSize: w * 0.04),
                    children: <TextSpan>[
                      TextSpan(
                        text: AppLocalizations.of(context)!.signUp,
                        style: TextStyle(
                            color: globalColor,
                            fontSize: w * 0.06,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ));
  }

  loginPressed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (phoneController.isNotEmpty && passwordController.text.isNotEmpty) {
      http.Response? response = await AuthServices.login(
          context, phoneController, passwordController.text);
      Map responseMap = jsonDecode(response!.body);
      if (response.statusCode == 200) {
        print("Number saved successully");
        preferences.setBool("isLoggedIn", true);
        preferences.setString("phone_number", phoneController);
        preferences.setString("password", passwordController.text);
        String authToken =
            responseMap["token"]; // Assuming your token key is "token"
        preferences.setString('token', authToken);
        Users? users = await ServicesGetUsers.getUsers(
            authToken); // Pass the token to getUsers()
        preferences.setString("isDriver", users!.roles);
        String device_id = preferences.getString('device_id') ?? '';
        ServicesSendNotification.storeDeviceId(device_id);
        if (users.roles == 'driver')
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return WrapperDriver();
              },
            ),
          );
        else
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Wrapper(
                  child: Home(),
                  nav: 'home',
                  index: 0,
                );
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
}
