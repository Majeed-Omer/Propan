import 'package:flutter/material.dart';

class RowSocialWidget extends StatefulWidget {
  const RowSocialWidget({super.key});

  @override
  State<RowSocialWidget> createState() => _RowSocialWidgetState();
}

class _RowSocialWidgetState extends State<RowSocialWidget> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          "assets/facebook.png",
          height: w > 600 ? h * 0.115 : h * 0.045,
          width: w * 0.095,
          fit: BoxFit.contain,
        ),
        Image.asset(
          "assets/instagram.png",
          height: w > 600 ? h * 0.12 : h * 0.05,
          width: w * 0.1,
          fit: BoxFit.contain,
        ),
        Image.asset(
          "assets/twitter.png",
          height: w > 600 ? h * 0.12 : h * 0.05,
          width: w * 0.1,
          fit: BoxFit.contain,
        )
      ],
    );
  }
}
