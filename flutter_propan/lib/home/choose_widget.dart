import 'package:flutter/material.dart';
import 'package:flutter_app/order/order.dart';

// ignore: must_be_immutable
class ChooseWidget extends StatelessWidget {
  String image;
  String name;
  String price;

  ChooseWidget({required this.image, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Order(
              orderType: name,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(w * 0.05),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.symmetric(
            horizontal: w * 0.05, vertical: h * 0.01), // Responsive margin here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              image,
              height: w > 600 ? h * 0.17 : h * 0.15, // Responsive height here
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  15, 5, 15, w >= 600 ? h * 0.015 : h * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: w * 0.04, // Responsive font size here
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: w * 0.04, // Responsive font size here
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
