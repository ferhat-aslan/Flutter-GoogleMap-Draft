import 'dart:async';
import 'package:location/location.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_google/services/current_location.dart';
class CurrentLocationBloc{
  final currentLocationController =StreamController.broadcast();
  Stream get getLocation =>currentLocationController.stream;

Future<LocationData?> getLocationData(){
  return CurrentLocation.getlocation();
}
}
final currentLocation =CurrentLocationBloc();