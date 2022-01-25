import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loca;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String googleApikey = "AIzaSyD9NT_CiWDgItIN6pWWVzrDDiTFMgQCh_s";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(37.6602292, 37.308027);
  String location = "Location Name:";

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polyLineCoordinates = [];
  PolylinePoints? polylinePoints;
  loca.Location? den;
  loca.LocationData? currentLocation;
  LatLng? destination;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polylinePoints = PolylinePoints();
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    currentLocation = await den!.getLocation();
    mapController = _cntlr;
    den!.onLocationChanged.listen((l) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Longitude Latitude Picker in Google Map"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Stack(children: [
          GoogleMap(
            myLocationEnabled: true,
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true,
            polylines: _polylines, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation, //initial position
              zoom: 14.0, //initial zoom level
            ),
            mapType: MapType.normal, //map type
            onMapCreated: _onMapCreated,
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona; //when map is dragging
            },
            onCameraIdle: () async {
              //when map drag stops
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition!.target.latitude,
                  cameraPosition!.target.longitude);
              setState(() {
                destination=cameraPosition!.target;
                //get place name from lat and lang
                location = placemarks.first.street.toString() +
                    ", " +
                    placemarks.first.name.toString() +
                    ", " +
                    placemarks.first.postalCode.toString();
              });
            },
          ),
          Center(
            //picker image on google map
            child: Image.asset(
              "assets/images/pick.png",
              width: 55,
            ),
          ),
          Positioned(
              //widget to display location name
              bottom: 100,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        onTap: () {
                          //destination!.latitude!=cameraPosition!.target.latitude;
                 // destination!.longitude!=cameraPosition!.target.longitude;
                          setState(() {
                           
                            Navigator.pop(context,destination);
                            //SetPolylines();
                            //print(polyLineCoordinates);
                          });
                          
                        },
                        leading: Image.asset(
                          "assets/images/pick.png",
                          width: 25,
                        ),
                        title: Text(
                          location,
                          style: TextStyle(fontSize: 18),
                        ),
                        dense: true,
                      )),
                ),
              ))
        ]));
  }

  void SetPolylines() async {
    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
        "AIzaSyD9NT_CiWDgItIN6pWWVzrDDiTFMgQCh_s",
        PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        PointLatLng(destination!.latitude, destination!.longitude));
    if (result.status == "OK") {
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      _polylines.add(Polyline(
        width: 2,
        color: Colors.blue,
      polylineId: PolylineId('polyLine'),
      points: polyLineCoordinates,
      ));
    });
  }
}
