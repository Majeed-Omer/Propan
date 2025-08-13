import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/home/home.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/order/order.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/services/Services_send_notification.dart';
import 'package:flutter_app/services/services_places_crud.dart';
import 'package:flutter_app/services/Services_crud_orders.dart';
import 'package:flutter_app/wrapper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_app/models/places.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// const LatLng cameraPosition = LatLng(36.17529680165231, 44.014038535188334);

// ignore: must_be_immutable
class GooglMapOrder extends StatefulWidget {
  final String orderType;
  TextEditingController controller;
  String sign;
  String price;

  GooglMapOrder(
      {required this.orderType,
      required this.controller,
      required this.sign,
      required this.price});
  @override
  State<GooglMapOrder> createState() => _GooglMapOrderState();
}

class _GooglMapOrderState extends State<GooglMapOrder> {
  Completer<GoogleMapController> _googleMapController = Completer();
  late GoogleMapController googleMapController;
  int id = 1;
  late List<Places> _places;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _nameController;
  LatLng? _draggedLatLng;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    _places = [];
    _scaffoldKey = GlobalKey();
    _getPlaces();
    _nameController = TextEditingController();
    getCurrentLocation();
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      Location location = Location();
      LocationData locationData = await location.getLocation();
      return locationData;
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }

  _addPlaces(double lat, double long) {
    if (_nameController.text.trim().isEmpty) {
      print("Empty fields");
      return;
    }
    ServicesPlacesCrud.addPlaces(_nameController.text, lat, long)
        .then((result) {
      if (result) {
        _getPlaces();
      }
      _clearValues();
    });
  }

  _addOrders(String latitude, String longitude, String place_name) {
    if (place_name.trim().isEmpty) {
      print("Empty field");
      return;
    }
    Services_Orders.addOrders(
            widget.orderType,
            widget.controller.text + widget.sign,
            widget.price,
            place_name,
            latitude,
            longitude)
        .then((result) {
      if (result) {
        print("Orders saved");
        ServicesSendNotification.sendNotification();
      }
      // _clearValues();
    });
  }

  _getPlaces() {
    ServicesPlacesCrud.getPlaces().then((places) {
      setState(() {
        _places = places;
      });
      print("Length: ${places.length}");
    });
  }

  _clearValues() {
    _nameController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: h * 0.07,
        leading: Padding(
          padding: languageProvider.selectedLanguage == 'en'
              ? EdgeInsets.only(
                  left: 600 < w && 1300 > w ? h * 0.008 : h * 0.02,
                  bottom: w < 400 && h < 700 ? h * 0.02 : 0.0)
              : EdgeInsets.only(
                  right: 600 < w && 1300 > w ? h * 0.008 : h * 0.02,
                  bottom: w < 400 && h < 700 ? h * 0.02 : 0.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Order(orderType: widget.orderType)),
              );
            },
            child: Transform.scale(
                scale: 600 < w && 1300 > w
                    ? h * 0.0008
                    : h *
                        0.002, // Adjust the scale factor to make the icon bigger
                child: languageProvider.selectedLanguage == 'en'
                    ? Image.asset(
                        "assets/arrow_back.png",
                      )
                    : Image.asset(
                        "assets/arrow_back_ar.png",
                      )),
            style: ButtonStyle(
              shape: WidgetStateProperty.all(CircleBorder(
                  side: BorderSide(
                      width: 2.0,
                      color: Colors
                          .black))), // <-- Adjust the width and color of the border
              backgroundColor:
                  WidgetStateProperty.all(globalColor), // <-- Button color
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.selectPlace,
          style: TextStyle(
              fontSize: (w + h) * 0.019,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 242, 242, 242),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            border: Border.all(color: globalColor, width: w > 600 ? 2.0 : 1.0)),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            child: !_places.isEmpty
                ? _buildBody()
                : Center(
                    child: CircularProgressIndicator(
                    color: globalColor,
                  ))),
      ),
    );
  }

  Widget _buildBody() {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              _getMap(),
              _getCustomPin(),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.05,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: globalColor,
              side: BorderSide(color: Colors.black, width: w > 600 ? 2.0 : 1.0),
            ),
            onPressed: () {
              if (_draggedLatLng!.latitude.toString() ==
                      _places.last.latitude.toString() &&
                  _draggedLatLng!.longitude.toString() ==
                      _places.last.longitude.toString()) {
                _addOrders(_places.last.latitude, _places.last.longitude,
                    _places.last.name);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Wrapper(
                              child: Home(),
                              nav: 'home',
                              index: 0,
                            )));
              } else
                showModalBottomSheet(
                  isScrollControlled: true,
                  // enableDrag: false,
                  // isDismissible: false,
                  context: context,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: globalColor, width: w > 600 ? 2.0 : 1.0),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(w > 600 ? 35.0 : 25.0),
                    ),
                  ),
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: h * 0.015),
                            Container(
                              width: w * 0.08,
                              height: h * 0.015,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            SizedBox(height: h * 0.015),
                            Text(
                              AppLocalizations.of(context)!.address,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.05),
                            ),
                            SizedBox(height: h * 0.025),
                            Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: w * 0.12),
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: h * 0.015,
                                        horizontal: w * 0.015),
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: globalColor,
                                          width: w > 600 ? 2.0 : 1.0),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.03),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: globalColor,
                                          width: w > 600 ? 2.0 : 1.0),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.03),
                                    ),
                                    hintText: AppLocalizations.of(context)!
                                        .yourAddressN,
                                    hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: w * 0.04),
                                  ),
                                  onChanged: (value) {},
                                )),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: globalColor,
                                  side: BorderSide(
                                      color: Colors.black,
                                      width: w > 600 ? 2.0 : 1.0),
                                  fixedSize: Size(
                                      w * 0.4,
                                      (h - w) >= 640
                                          ? h * 0.03
                                          : w >= 1300
                                              ? h * 0.11
                                              : h * 0.07),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                  ),
                                ),
                                onPressed: () {
                                  _addPlaces(_draggedLatLng!.latitude,
                                      _draggedLatLng!.longitude);
                                  _addOrders(
                                      _draggedLatLng!.latitude.toString(),
                                      _draggedLatLng!.longitude.toString(),
                                      _nameController.text);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Wrapper(
                                                child: Home(),
                                                nav: 'home',
                                                index: 0,
                                              )));
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.save,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: w * 0.04),
                                )),
                            SizedBox(height: h * 0.021),
                          ],
                        ),
                      ),
                    );
                  },
                );
            },
            child: Text(
              AppLocalizations.of(context)!.save,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(_places.last.latitude),
            double.parse(_places.last.longitude)),
        zoom: 18,
      ),
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      onCameraMove: (cameraPosition) {
        // every time time user drag this will get value of latlng
        _draggedLatLng = cameraPosition.target;
        print(
            "lat and long is ${_draggedLatLng!.longitude} and ${_draggedLatLng!.latitude}");
      },
      onMapCreated: (GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
      },
    );
  }

  Widget _getCustomPin() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.09,
        child: Lottie.asset("assets/pin.json"),
      ),
    );
  }
}
