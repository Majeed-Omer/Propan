import 'package:flutter/material.dart';
import 'package:flutter_app/google_map/google_map_order.dart';
import 'package:flutter_app/order/order_class.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ColumnWidget extends StatefulWidget {
  final String orderType;
  ColumnWidget({required this.orderType});

  @override
  State<ColumnWidget> createState() => _ColumnWidgetState();
}

class _ColumnWidgetState extends State<ColumnWidget> {
  TextEditingController controller = TextEditingController();
  int price = 0;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: w * 0.045),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: globalColor),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: globalColor, width: w > 600 ? 2.0 : 1.0),
                borderRadius: BorderRadius.circular((h + w) * 0.01),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: w > 600 ? h * 0.03 : h * 0.025,
                  horizontal: w * 0.015), // Adjust this value as needed
              hintText: AppLocalizations.of(context)!.ex,
              suffixText: OrderClass.getSuffixText(
                  context, widget.orderType, controller.text),
              suffixStyle: TextStyle(color: Colors.black, fontSize: w * 0.045),
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: w * 0.045),
            ),
          ),
        ),
        SizedBox(
          height: h * 0.05,
        ),
        Text(
          "$price\$",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.05),
        ),
        SizedBox(
          height: h * 0.05,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(w * 0.03),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius:w*0.01,
                  offset: Offset(0, 3),
                )
              ]),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: globalColor,
                side:
                    BorderSide(color: Colors.black, width: w > 600 ? 2.0 : 1.0),
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
                if (controller.text.isEmpty) {
                  errorSnackBar(
                      context, AppLocalizations.of(context)!.noNumber);
                } else if (controller.text == '0') {
                  errorSnackBar(
                      context, AppLocalizations.of(context)!.moreThanZero);
                } else {
                  setState(() {
                    price = OrderClass.getPrice(
                        context, widget.orderType, controller.text);
                  });
                  showBottomSheet();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: w >= 300 ? w * 0.05 : w * 0.07),
              )),
        ),
      ],
    );
  }

  showBottomSheet() {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: globalColor, width: w > 600 ? 2.0 : 1.0),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(w >= 768 ? 35.0 : 25.0),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: h * 0.31,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: h * 0.015),
                Container(
                  width: w * 0.08,
                  height: h * 0.015,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  AppLocalizations.of(context)!.payment,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: w * 0.05),
                ),
                SizedBox(height: h * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GooglMapOrder(
                                    orderType: widget.orderType,
                                    controller: controller,
                                    sign: OrderClass.getSign(
                                        context, widget.orderType),
                                    price: price.toString())),
                          );
                        },
                        child: ListTile(
                          leading: Image.asset(
                            "assets/cash.png",
                            height: h * 0.5,
                            width: w * 0.1,
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.cash,
                            style: TextStyle(fontSize: w * 0.05),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: w > 600 ? (h + w) * 0.023 : (h + w) * 0.025,
                          ),
                        ),
                      ),
                      // SizedBox(height: 20),
                      // InkWell(
                      //   onTap: () async {
                      //     _addOrders();
                      //     FastpayResult _fastpayResult =
                      //         await FastPayRequest(
                      //       storeID: "0000000",
                      //       storePassword: "000000",
                      //       amount: "$price\$",
                      //       orderID: DateTime.now()
                      //           .microsecondsSinceEpoch
                      //           .toString(),
                      //       isProduction: false,
                      //     );
                      //     if (_fastpayResult.isSuccess ??
                      //         false) {
                      //       // transaction success
                      //       print('transaction success');
                      //     } else {
                      //       // transaction failed
                      //       print('transaction failed');
                      //     }
                      //     setState(() {});
                      //   },
                      //   child: ListTile(
                      //     leading:
                      //         Image.asset("assets/FastPay.png"),
                      //     title: Text(
                      //         AppLocalizations.of(context)!
                      //             .fastpay),
                      //     trailing:
                      //         Icon(Icons.arrow_forward_ios),
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      // InkWell(
                      //   onTap: () {
                      //     _addOrders();
                      //     initiatePayment();
                      //   },
                      //   child: ListTile(
                      //     leading:
                      //         Image.asset("assets/FIB.jpg"),
                      //     title: Text(
                      //         AppLocalizations.of(context)!
                      //             .fib),
                      //     trailing:
                      //         Icon(Icons.arrow_forward_ios),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
