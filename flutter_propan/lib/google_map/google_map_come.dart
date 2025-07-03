import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/history/history.dart';
import 'package:flutter_app/google_map/locationProvider.dart';
import 'package:flutter_app/services/services_crud_users.dart';
import 'package:flutter_app/wrapper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

// ignore: must_be_immutable
// const LatLng cameraPosition = LatLng(36.17529680165231, 36.17529680165231);

class LocationData {
  double lat;
  double long;

  LocationData({required this.lat, required this.long});
}

class GooglMapCome extends StatefulWidget {
  final String driver_id;
  final String lat;
  final String long;
  final String latUser;
  final String longUser;

  GooglMapCome(
      {required this.driver_id,
      required this.lat,
      required this.long,
      required this.latUser,
      required this.longUser});

  @override
  State<GooglMapCome> createState() => _GooglMapDriverState();
}

class _GooglMapDriverState extends State<GooglMapCome> {
  Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;

  final PusherOptions options = PusherOptions(
    host: 'api.pusherapp.com',
    cluster: 'ap2',
    encrypted: true,
  );

  PusherClient? pusher;

  call() {
    ServicesGetUsers.socket(widget.driver_id).then((result) {
      if (result) {
        print("Socket called");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pusher = PusherClient('5fc2200586b14c9c15fe', options, enableLogging: true);

    pusher!.connect();

    pusher!.onConnectionStateChange((state) {
      print('Connection state changed: $state');
    });

    Channel channel = pusher!.subscribe('users');
    channel.bind('test', (event) async {
      Map<String, dynamic> latLong = json.decode(event!.data.toString());
      print('Received event: ${latLong.values.first['latitude']}');
      GoogleMapController googleMapController = await _controller.future;

      context.read<LocationProvider>().updateLocation(
            double.parse(latLong.values.first['latitude']),
            double.parse(latLong.values.first['longitude']),
          );
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 20.0,
              target: LatLng(double.parse(latLong.values.first['latitude']),
                  double.parse(latLong.values.first['longitude'])))));
    });
    Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      await call();
    });
  }

  @override
  void dispose() {
    pusher!.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print("Width ${w}");
    print("Height ${h}");
    return Scaffold(
      appBar: AppBar(
        leading: Transform.scale(
          scale: 0.6,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Wrapper(
                            nav: 'history',
                            index: 1,
                            child: History(),
                          )));
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
                  side: BorderSide(width: 2.0, color: Colors.black))),
              backgroundColor:
                  MaterialStateProperty.all(globalColor), // <-- Button color
            ),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.yourDriver,
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
            child: Consumer<LocationProvider>(
                builder: (context, locationProvider, _) {
              return GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(locationProvider.locationData.lat,
                        locationProvider.locationData.long),
                    zoom: 20),
                markers: {
                  Marker(
                      markerId: MarkerId('clientLocation'),
                      position: LatLng(double.parse(widget.latUser),
                          double.parse(widget.longUser)),
                      infoWindow: InfoWindow(
                          title: "Client", snippet: "client waiting")),
                  Marker(
                      markerId: MarkerId('driverLocation'),
                      position: LatLng(locationProvider.locationData.lat,
                          locationProvider.locationData.long),
                      infoWindow:
                          InfoWindow(title: "Driver", snippet: "driver going")),
                },
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
                mapType: MapType.normal,
                polylines: {
                  Polyline(
                      polylineId: PolylineId('1'),
                      points: [
                        LatLng(locationProvider.locationData.lat,
                            locationProvider.locationData.long),
                        LatLng(double.parse(widget.latUser),
                            double.parse(widget.longUser)),
                      ],
                      color: globalColor,
                      width: (w * 0.02).toInt())
                },
              );
            }),
          )),
    );
  }
}
