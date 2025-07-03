import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/globals/circular_progress.dart';
import 'package:flutter_app/home/home.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/services/Services_send_notification.dart';
import 'package:flutter_app/services/auth_services.dart';
import 'package:flutter_app/services/services_crud_users.dart';
import 'package:flutter_app/services/services_places_crud.dart';
import 'package:flutter_app/wrapper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

const LatLng cameraPosition = LatLng(36.17529680165231, 44.014038535188334);

// ignore: must_be_immutable
class GoogleMapFirst extends StatefulWidget {
  final String name;
  final String phone_number;
  final String password;
  GoogleMapFirst(
      {required this.name, required this.phone_number, required this.password});
  @override
  State<GoogleMapFirst> createState() => _GoogleMapFirstState();
}

class _GoogleMapFirstState extends State<GoogleMapFirst> {
  Completer<GoogleMapController> _googleMapController = Completer();
  late GoogleMapController googleMapController;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _nameController;
  LatLng? _draggedLatLng;
  late LocationData currentLocation;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    _nameController = TextEditingController();
    getCurrentLocation();
  }

  Future<int> createAccountPressed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    http.Response? response = await AuthServices.signup(
        context, widget.name, widget.phone_number, widget.password);
    Map responseMap = jsonDecode(response!.body);
    if (response.statusCode == 200) {
      print("Number saved successully");
      String authToken =
          responseMap["token"]; // Assuming your token key is "token"
      preferences.setString('token', authToken);
      preferences.setBool("isLoggedIn", true);
      return 200;
    } else {
      errorSnackBar(context, responseMap.values.first[0]);
      return 400;
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      Location location = Location();
      LocationData locationData = await location.getLocation();
      currentLocation = locationData;
      ServicesGetUsers.updateLatLong(currentLocation.latitude!, currentLocation.longitude!)
          .then((result) {
        if (result) {
          print("Location updated");
        }else{
          print("Location not updated");
        }
      });
      return currentLocation;
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
        print("You location is save");
      }
      _clearValues();
    });
  }

  _clearValues() {
    _nameController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: h * 0.07,
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
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            border: Border.all(color: globalColor, width: w > 600 ? 2.0 : 1.0)),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
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
              side: BorderSide(
                  color: Colors.black,
                  width: w > 600 ? 2.0 : 1.0), // Add this line
            ),
            onPressed: () {
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
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                ),
                              ),
                              onPressed: () async {
                                int code = await createAccountPressed();
                                print("My code $code");
                                if (code == 200) {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  Navigator.pop(context);
                                  _draggedLatLng == null
                                      ? _addPlaces(cameraPosition.latitude,
                                          cameraPosition.longitude)
                                      : _addPlaces(_draggedLatLng!.latitude,
                                          _draggedLatLng!.longitude);
                                  String device_id =
                                      preferences.getString('device_id') ?? '';
                                  ServicesSendNotification.storeDeviceId(
                                      device_id);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Wrapper(
                                                child: Home(),
                                                nav: 'home',
                                                index: 0,
                                              )));
                                } else {
                                  print("Failed");
                                }
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
    return FutureBuilder<LocationData?>(
      future: getCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the location data.
          return CircularProgress();
        } else if (snapshot.hasError) {
          // Handle error
          return Text('Error: ${snapshot.error}');
        } else {
          // Location data is available, you can use it here.
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.latitude!,
                snapshot.data!.longitude!,
              ),
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
