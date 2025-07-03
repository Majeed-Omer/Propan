import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home/appbar_home.dart';
import 'package:flutter_app/home/listview_home.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = CarouselController();
  int activateIndex = 0;
  final sliderImages = ['assets/gas-factory.jpg', 'assets/gas-factory2.jpg'];
  void animateToSlide(int index) => controller.animateToPage(index);
  Widget buildIndicator() {
    final w = MediaQuery.of(context).size.width;
    return AnimatedSmoothIndicator(
      activeIndex: activateIndex,
      count: sliderImages.length,
      effect: SwapEffect(
          dotHeight: w * 0.03, dotWidth: w * 0.03, activeDotColor: globalColor),
      onDotClicked: animateToSlide,
    );
  }

  Widget builImage(String sliderImage, int index) => Container(
        color: Colors.grey,
        child: Image.asset(
          sliderImage,
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    // print("Width ${w}");
    // print("Height ${h}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarHome.AppBarHome(context),
      body: Container(
          padding: EdgeInsets.symmetric(
            vertical: h * 0.02,
          ),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.05),
                  topRight: Radius.circular(w * 0.05)),
              border:
                  Border.all(color: globalColor, width: w > 600 ? 2.0 : 1.0)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: h * 0.02,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(w * 0.05),
                  child: Stack(children: [
                    CarouselSlider.builder(
                        carouselController: controller,
                        itemCount: sliderImages.length,
                        itemBuilder: (context, index, realIndex) {
                          final sliderImage = sliderImages[index];
                          return builImage(sliderImage, index);
                        },
                        options: CarouselOptions(
                            height: h * 0.15,
                            viewportFraction: 1,
                            autoPlay: true,
                            onPageChanged: ((index, reason) =>
                                setState(() => activateIndex = index)),
                            autoPlayInterval: Duration(seconds: 2))),
                    Positioned(
                      top: w > 600 ? h * 0.1 : h * 0.12,
                      left: w * 0.4,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 242, 242, 242),
                          borderRadius: BorderRadius.circular(w * 0.015),
                        ),
                        height: w > 600 ? h * 0.03 : h * 0.02,
                        width: w * 0.1,
                        child: buildIndicator(),
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Container(
                  height: w > 600
                      ? w > 1024
                          ? h * 0.7
                          : h * 0.68
                      : h * 0.635,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: ListviewHome()),
            ],
          )),
    );
  }
}
