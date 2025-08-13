import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/driver/wrapper_driver.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../main.dart';

// ignore: must_be_immutable
class GooglMapDriver extends StatefulWidget {
  final String place_name;
  final double latitude;
  final double longitude;

  GooglMapDriver(
      {required this.place_name,
      required this.latitude,
      required this.longitude});

  @override
  State<GooglMapDriver> createState() => _GooglMapDriverState();
}

class _GooglMapDriverState extends State<GooglMapDriver> {
  Completer<GoogleMapController> _controller = Completer();

  // GlobalKey<ScaffoldState>? _scaffoldKey;
  LocationData? currentLocation;

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

  @override
  void initState() {
    super.initState();
    // _scaffoldKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        leading: Transform.scale(
          scale: 0.6,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WrapperDriver()));
            },
            child: Transform.scale(
              scale: 1.5, // Adjust the scale factor to make the icon bigger
              child: languageProvider.selectedLanguage == 'en'
                  ? Image.asset(
                      "assets/arrow_back.png",
                    )
                  : Image.asset(
                      "assets/arrow_back_ar.png",
                    ),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder(
                  side: BorderSide(
                      width: 2.0,
                      color: Colors
                          .black))), // <-- Adjust the width and color of the border
              backgroundColor:
                  MaterialStateProperty.all(globalColor), // <-- Button color
            ),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.selectPlace,
            style: TextStyle(color: Colors.black, fontSize: (w + h) * 0.02)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: h * 0.07,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.circular(25.0),
              border:
                  Border.all(color: globalColor, width: w >= 768 ? 2.0 : 1.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            child: FutureBuilder<LocationData?>(
              future: getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: globalColor,
                  ));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching location'),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  currentLocation = snapshot.data;
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(widget.latitude, widget.longitude),
                        zoom: 14),
                    markers: {
                      Marker(
                          markerId: MarkerId('currentLocation'),
                          position: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          infoWindow:
                              InfoWindow(title: "Place", snippet: "5 star")),
                      Marker(
                          markerId: MarkerId('destinationLocation'),
                          position: LatLng(widget.latitude, widget.longitude),
                          infoWindow:
                              InfoWindow(title: "Place2", snippet: "5 star")),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    polylines: {
                      Polyline(
                          polylineId: PolylineId('1'),
                          points: [
                            LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                            LatLng(widget.latitude, widget.longitude),
                          ],
                          color: Colors.black,
                          width: (w * 0.02).toInt())
                    },
                  );
                } else {
                  return Center(
                    child: Text('Location data unavailable'),
                  );
                }
              },
            ),
          )),
    );
  }
}
