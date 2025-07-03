import 'package:flutter/material.dart';
import 'package:flutter_app/auth/signup.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        body: Center(
          child: Container(
            height: h * 0.5,
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() => isLastPage = index == 2);
              },
              children: [
                Image.asset(
                  'assets/gas.png',
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  'assets/gas-propan.png',
                  fit: BoxFit.fill,
                ),
                Image.asset('assets/gas-3.png',
                fit: BoxFit.fill,),
              ],
            ),
          ),
        ),
        bottomSheet: isLastPage
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black, width: w > 600 ? 2.0 : 1.0),
                ),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: globalColor,
                        minimumSize: Size.fromHeight(80)),
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setBool("firstTime", false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Signup(),
                        ),
                      );
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(color: Colors.black, fontSize: w * 0.06),
                    )))
            : Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: globalColor,
                      width: w > 600 ? 2.0 : 1.0,
                    ),
                  ),
                ),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => controller.jumpToPage(2),
                        child: Text(
                          "SKIP",
                          style: TextStyle(
                              color: Colors.black, fontSize: w * 0.04),
                        ),
                      ),
                      Center(
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: 3,
                          effect: WormEffect(
                              spacing: 16,
                              dotColor: Colors.grey,
                              activeDotColor: globalColor),
                          onDotClicked: ((index) => controller.animateToPage(
                              index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut)),
                        ),
                      ),
                      TextButton(
                        onPressed: () => controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut),
                        child: Text(
                          "NEXT",
                          style: TextStyle(
                              color: Colors.black, fontSize: w * 0.04),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
