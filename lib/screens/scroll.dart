import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';


class ScrollPage extends StatefulWidget {
  const ScrollPage({ Key? key }) : super(key: key);

  @override
  _ScrollPageState createState() => _ScrollPageState();
}

class _ScrollPageState extends State<ScrollPage> {
  String googleApikey = "AIzaSyD9NT_CiWDgItIN6pWWVzrDDiTFMgQCh_s";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(37.1602292, 37.708027);
  String location = "Location Name:";
    LocationData? currentLocation;
    Location? local;
    void _onMapCreated(GoogleMapController _cntlr)async{
      currentLocation=await local!.getLocation();
      mapController = _cntlr;
      local!.onLocationChanged.listen((l) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(


body: Center(child: GoogleMap(initialCameraPosition: CameraPosition(target: startLocation,zoom: 10)),),
bottomSheet: SolidBottomSheet(
  minHeight: 100,
        headerBar: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)
            )
          ),
          
          height: 50,
          child: Center(
            child: Container(
              width: 65,
              child: Divider(
                color: Colors.white,
                height: 55,
                thickness: 3,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          height: 30,
          child: Center(
            child: Text(
              "Hello! I'm a bottom sheet :D",
              
            ),),),


      ),
      
    ));
  }
}