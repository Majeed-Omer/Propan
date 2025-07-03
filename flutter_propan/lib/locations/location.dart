import 'package:flutter/material.dart';
import 'package:flutter_app/google_map/google_map_update.dart';
import 'package:flutter_app/locations/appbar_location.dart';
import 'package:flutter_app/locations/float_location_widget.dart';
import 'package:flutter_app/locations/location_widget.dart';
import 'package:flutter_app/models/places.dart';
import 'package:flutter_app/globals/globals.dart';
import 'package:flutter_app/services/services_places_crud.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late List<Places> _places;
  // late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _places = [];
    // _scaffoldKey = GlobalKey();
    _getPlaces();
  }

  _deletePlaces(Places places) {
    ServicesPlacesCrud.deletePlaces(places.id).then((result) {
      if (result) {
        print("Place is deleted");

        _getPlaces();
      }
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

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print(w);
    print(h);
    return Scaffold(
        backgroundColor: Colors.white,
        // key: _scaffoldKey,
        appBar: AppbarLocation.appBarMethod(context),
        body: Container(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.02),
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
            itemCount: _places.length,
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: h * 0.04),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => GooglMapUpdate(
                              page: Location(),
                              id: _places[index].id,
                              name: _places[index].name,
                              lat: double.parse(_places[index].latitude),
                              long: double.parse(_places[index].longitude)))));
                },
                child: Dismissible(
                  key: UniqueKey(),
                  child: LocationWidget(
                    name: _places[index].name,
                  ),
                  onDismissed: (direction) {
                    _deletePlaces(_places[index]);
                    setState(() {
                      _places.removeAt(index);
                    });
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete_forever,
                        color: Colors.white, size: w * 0.05),
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatLocationWidget());
  }
}
