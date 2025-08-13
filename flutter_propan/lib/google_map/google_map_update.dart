import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/services/services_places_crud.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// const LatLng cameraPosition = LatLng(36.17529680165231, 44.014038535188334);

// ignore: must_be_immutable
class GooglMapUpdate extends StatefulWidget {
  Widget page;
  String id;
  String name;
  double lat;
  double long;

  GooglMapUpdate(
      {required this.page,
      required this.id,
      required this.name,
      required this.lat,
      required this.long});

  @override
  State<GooglMapUpdate> createState() => _GooglMapUpdateState();
}

class _GooglMapUpdateState extends State<GooglMapUpdate> {
  Completer<GoogleMapController> _googleMapController = Completer();
  late GoogleMapController googleMapController;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _nameController;
  LatLng? _draggedLatLng;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    _nameController = TextEditingController();
    getCurrentLocation();
    printPlaces();
  }

  printPlaces() {
    print(widget.name);
    print(widget.id);
    print(widget.lat);
    print(widget.long);
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

  _updatePlaces(String id, String name, double lat, double long) {
    ServicesPlacesCrud.updatePlaces(id, name, lat, long).then((result) {
      if (result) {
        print(result);
      }
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => widget.page));
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
        title: Text(AppLocalizations.of(context)!.selectPlace,
            style: TextStyle(
              color: Colors.black,
              fontSize: (w + h) * 0.019,
            )),
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
            child: _buildBody()),
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
              side: BorderSide(
                  color: Colors.black,
                  width: w > 600 ? 2.0 : 1.0), // Add this line
            ),
            onPressed: () {
              if (_draggedLatLng!.latitude == widget.lat &&
                  _draggedLatLng!.longitude == widget.long)
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => widget.page));
              else
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
                                  _updatePlaces(
                                      widget.id,
                                      _nameController.text,
                                      _draggedLatLng!.latitude,
                                      _draggedLatLng!.longitude);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => widget.page));
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
        target: LatLng(widget.lat, widget.long),
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
