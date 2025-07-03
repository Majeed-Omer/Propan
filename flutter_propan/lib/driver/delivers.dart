import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/services/Services_crud_orders_delivery.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/services/services_crud_users.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/orders_Delivery.dart';
import 'google_map_driver.dart';

class Delivers extends StatefulWidget {
  const Delivers({super.key});

  @override
  State<Delivers> createState() => _DeliversState();
}

class _DeliversState extends State<Delivers> {
  late List<OrdersDelivery> _ordersDelivery;
  // late GlobalKey<ScaffoldState> _scaffoldKey;
  List<bool> itemOpenStates = [];
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    _ordersDelivery = [];
    // _scaffoldKey = GlobalKey();
    _getOrders();
  }

  _updateOrders(String orid, bool pay) {
    ServicesOrdersDelivery.updateOrders(orid, pay.toString()).then((result) {
      if (result) {
        print(result);
        _updateBusy(!pay);
        _getOrders();
      }
    });
  }

  _updateBusy(bool busy) {
    ServicesGetUsers.updateBusy(busy.toString()).then((result) {
      if (result) {
        print(result);
      }
    });
  }

  _getOrders() {
    ServicesOrdersDelivery.getOrdersDelivery().then((ordersDelivery) {
      setState(() {
        _ordersDelivery = ordersDelivery;
        itemOpenStates =
            List.generate(_ordersDelivery.length, (index) => false);
      });
      print("Length: ${ordersDelivery.length}");
      print(itemOpenStates);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);

    print(w);
    print(h);
    return Scaffold(
      backgroundColor: Colors.white,
      // key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.deliveries,
            style: TextStyle(
              color: Colors.black,
              fontSize: (w + h) * 0.02,
            )),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: h * 0.07,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.03),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 242, 242, 242),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(w * 0.05),
                topRight: Radius.circular(w * 0.05)),
            border:
                Border.all(color: globalColor, width: w >= 768 ? 2.0 : 1.0)),
        child: ListView.separated(
          itemCount: _ordersDelivery.length,
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(height: h * 0.04), // Space between items
          itemBuilder: (BuildContext context, int index) {
            bool isOpen = itemOpenStates[index];
            return InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return GooglMapDriver(
                          place_name: _ordersDelivery[index].place_name,
                          latitude:
                              double.parse(_ordersDelivery[index].latitude),
                          longitude:
                              double.parse(_ordersDelivery[index].longitude),
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  height: isOpen
                      ? languageProvider.selectedLanguage == 'en'
                          ? h * 0.5
                          : w >= 768
                              ? h * 0.63
                              : h * 0.55
                      : w >= 768
                          ? h * 0.155
                          : h * 0.1,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: globalColor, width: w >= 768 ? 2.0 : 1.0),
                    borderRadius: BorderRadius.circular(w * 0.05),
                    color: Colors.white,
                  ),
                  child: isOpen
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                  ),
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/person.png"),
                                    backgroundColor: Colors.white,
                                    radius: w >= 1620.0 ? h * 0.04 : w * 0.04,
                                  ),
                                  SizedBox(
                                    width: w * 0.28,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        itemOpenStates[index] =
                                            !itemOpenStates[index];
                                        print(itemOpenStates[index]);
                                      });
                                    },
                                    child: SizedBox(
                                      width: w > 768 ? w * 0.16 : w * 0.14,
                                      height: h * 0.1,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            _ordersDelivery[index].pay == 'true'
                                                ? 'assets/right.png'
                                                : 'assets/false.png',
                                            fit: BoxFit.fill,
                                            width:
                                                w >= 768 ? w * 0.09 : w * 0.08,
                                            height:
                                                w >= 768 ? h * 0.07 : h * 0.06,
                                          ),
                                          Icon(
                                            Icons.arrow_drop_up,
                                            size: w >= 768 ? 50 : 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.name,
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _ordersDelivery[index].user.name,
                                          style: TextStyle(fontSize: w * 0.045),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.015,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .phoneNumber,
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _ordersDelivery[index]
                                              .user
                                              .phone_number,
                                          style: TextStyle(fontSize: w * 0.045),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.015,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.type,
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _ordersDelivery[index].name ==
                                                  "Bottle"
                                              ? AppLocalizations.of(context)!
                                                  .bottle
                                              : _ordersDelivery[index].name ==
                                                      "Liter"
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .liter
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .ton,
                                          style: TextStyle(fontSize: w * 0.045),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.015,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.rate,
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _ordersDelivery[index].rate,
                                          style: TextStyle(fontSize: w * 0.045),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.015,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.price,
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${_ordersDelivery[index].price}\$',
                                          style: TextStyle(fontSize: w * 0.045),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.015,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.place,
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _ordersDelivery[index].place_name,
                                          style: TextStyle(fontSize: w * 0.045),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.015,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.date,
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          languageProvider.selectedLanguage ==
                                                  'en'
                                              ? DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(DateTime.parse(
                                                      _ordersDelivery[index]
                                                          .created_at))
                                              : languageProvider
                                                          .selectedLanguage ==
                                                      'ku'
                                                  ? DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss',
                                                          'ku')
                                                      .format(DateTime.parse(
                                                          _ordersDelivery[index]
                                                              .created_at))
                                                  : DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss',
                                                          'ar_SA')
                                                      .format(
                                                      DateTime.parse(
                                                          _ordersDelivery[index]
                                                              .created_at),
                                                    ),
                                          style: TextStyle(fontSize: w * 0.045),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.045),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.pay,
                                          style: TextStyle(
                                              fontSize: w * 0.05,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Transform.scale(
                                          scale: w >= 768
                                              ? 1.5
                                              : 1, // Adjust this value to change the size
                                          child: Switch(
                                            value: _ordersDelivery[index].pay ==
                                                "true",
                                            onChanged: (value) {
                                              setState(() {
                                                isSwitched = value;
                                                _updateOrders(
                                                    _ordersDelivery[index].id,
                                                    isSwitched);
                                              });
                                            },
                                            activeTrackColor: Color.fromARGB(
                                                255, 180, 247, 252),
                                            activeColor: globalColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/person.png"),
                                backgroundColor: Colors.white,
                                radius: w * 0.03,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    _ordersDelivery[index].user.name,
                                    style: TextStyle(
                                        fontSize:
                                            w >= 768 ? w * 0.05 : w * 0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _ordersDelivery[index].user.phone_number,
                                    style: TextStyle(
                                        fontSize:
                                            w >= 768 ? w * 0.04 : w * 0.03),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    _ordersDelivery[index].rate,
                                    style: TextStyle(
                                        fontSize:
                                            w >= 768 ? w * 0.05 : w * 0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _ordersDelivery[index].place_name,
                                    style: TextStyle(
                                        fontSize:
                                            w >= 768 ? w * 0.04 : w * 0.03),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: w > 768 ? w * 0.06 : w * 0.14,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    itemOpenStates[index] =
                                        !itemOpenStates[index];
                                  });
                                },
                                child: SizedBox(
                                  width: w * 0.14,
                                  height: h * 0.1,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        _ordersDelivery[index].pay == 'true'
                                            ? 'assets/right.png'
                                            : 'assets/false.png',
                                        fit: BoxFit.fill,
                                        width: w >= 768 ? w * 0.07 : w * 0.08,
                                        height: w >= 768 ? h * 0.06 : h * 0.06,
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: w >= 768 ? 50 : 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                ));
          },
        ),
      ),
    );
  }
}
