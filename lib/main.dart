import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:map_google/screens/LoginPage.dart';
import 'package:map_google/screens/home_page.dart';

import 'blocs/current_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: LoginPage(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? _controller;
  

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
      ////////////////////////////////////
      LocationData? currentLocation;
        _getLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
loc.onLocationChanged.listen((l) { 
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 19),
          ),
      );
    });
      print("locationLatitude: ${currentLocation!.latitude}");
      print("locationLongitude: ${currentLocation!.longitude}");
      setState(
          () {}); //rebuild the widget after getting the current location of the user
    } on Exception {
      currentLocation = null;
    }
  }
   Location loc = Location();
void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    loc.onLocationChanged.listen((l) { 
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
          ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
       // myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated
        ,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        label: Text('Get my Location!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}