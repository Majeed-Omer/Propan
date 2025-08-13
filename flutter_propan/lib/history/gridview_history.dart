import 'package:flutter/material.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/google_map/google_map_come.dart';
import 'package:flutter_app/history/history_widget.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/models/orders.dart';
import 'package:flutter_app/models/users.dart';
import 'package:flutter_app/services/Services_crud_orders.dart';
import 'package:flutter_app/services/services_crud_users.dart';

class GrideviewHistory extends StatefulWidget {
  const GrideviewHistory({super.key});

  @override
  State<GrideviewHistory> createState() => _GrideviewHistoryState();
}

class _GrideviewHistoryState extends State<GrideviewHistory> {
  late List<Orders> _orders;
  bool _isLoading = true;
  Users? users;

  @override
  void initState() {
    super.initState();

    _orders = [];
    _getOrders();
  }

  _getOrders() async {
    Services_Orders.getOrders().then((orders) async {
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
      print("Orders Length: ${orders.length}");
      print(_orders.last.driver_id);
      users = await ServicesGetUsers.getUsersWithId(_orders.last.driver_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: globalColor,
      ));
    }

    return _orders.isNotEmpty
        ? GridView.builder(
            itemCount: _orders.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: _calculateMaxCrossAxisExtent(context),
                childAspectRatio: w > 600.0 ? 1.0 : 0.90,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    _orders[index].pay == 'false'
                        ? Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return GooglMapCome(
                                  driver_id: _orders[index].driver_id,
                                  lat: users!.latitude,
                                  long: users!.longitude,
                                  latUser: _orders[index].latitude,
                                  longUser: _orders[index].longitude);
                            },
                          ))
                        : print("The delivery is arived");
                  },
                  child: HistoryWidget(
                    name: _orders[index].name,
                    rate: _orders[index].rate,
                    price: _orders[index].price,
                    created_at: _orders[index].created_at,
                  ));
            },
          )
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.noOrder,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.05,
                    color: Colors.black),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Image.asset(
                "assets/no_orders.png",
                fit: BoxFit.fill,
                height: h * 0.5,
                width: w * 0.8,
              ),
            ],
          ));
  }

  double _calculateMaxCrossAxisExtent(BuildContext context) {
    // Calculate the number of desired columns (in this case, 3 items in a row)
    int desiredColumns = 2;

    // Calculate the available width (screen width minus any padding or margins)
    double availableWidth = MediaQuery.of(context).size.width -
        30; // Assuming 15 padding on both sides

    // Calculate the space needed for spacing between columns
    double totalSpacing = (desiredColumns - 1) * 15;

    // Calculate the max cross-axis extent based on the number of desired columns
    double maxCrossAxisExtent =
        (availableWidth - totalSpacing) / desiredColumns;

    // Set a minimum limit for the maxCrossAxisExtent to ensure it doesn't become too small
    double minMaxCrossAxisExtent = 200;

    // Return the calculated maxCrossAxisExtent but not less than the minimum limit
    return maxCrossAxisExtent < minMaxCrossAxisExtent
        ? minMaxCrossAxisExtent
        : maxCrossAxisExtent;
  }
}
