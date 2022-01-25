import 'package:location/location.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CurrentLocation{
static  GoogleMapController? _controller;

static Location location= Location();
static  LocationData? currentLocation;
static CurrentLocation _singleton =CurrentLocation._internal();

factory CurrentLocation(){
  return _singleton;
}

CurrentLocation._internal();

  static Future<LocationData?> getlocation() async{
  try {
      currentLocation = await location.getLocation();
location.onLocationChanged.listen((l) { 
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 19),
          ),
      );
    });
     return currentLocation;
    } on Exception {
      currentLocation = null;
    }
return currentLocation;
}}