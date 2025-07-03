import 'package:flutter/material.dart';
import 'package:flutter_app/google_map/google_map_come.dart';

class LocationProvider extends ChangeNotifier {
  LocationData _locationData = LocationData(lat: 0.0, long: 0.0);

  LocationData get locationData => _locationData;

  void updateLocation(double lat, double long) {
    _locationData = LocationData(lat: lat, long: long);
    notifyListeners();
  }
}
