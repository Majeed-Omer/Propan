import 'package:flutter/material.dart';
import 'package:flutter_app/order/appbar_order.dart';
import 'package:flutter_app/order/column_widget.dart';
import 'package:flutter_app/globals/globals.dart';

class Order extends StatefulWidget {
  final String orderType;
  Order({required this.orderType});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width: ${w}");
    print("Height: ${h}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppbarOrder.appBarMethod(context),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: w * 0.1),
            decoration: BoxDecoration(
                color: Color.fromARGB(
                    255, 242, 242, 242), // Container background color
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                border:
                    Border.all(color: globalColor, width: w > 600 ? 2.0 : 1.0)),
            child: ColumnWidget(orderType: widget.orderType)));
  }
}
