import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_google/services/polyline_service.dart';
import 'package:marquee/marquee.dart';
import 'package:location/location.dart';
import 'package:map_google/screens/mapPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Location loc = Location();
  GoogleMapController? _controller;
  LocationData? currentLocation;
  LocationData? origin;
  String originText = "";
  LatLng? destination;
  String destinationText = "";
  LatLng? target;
  String targetText = "";
  void _onMapCreated(GoogleMapController _cntlr) async {
    currentLocation = await loc.getLocation();
    _controller = _cntlr;
    loc.onLocationChanged.listen((l) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }
  Set<Marker> _markers = {};
  BitmapDescriptor? _locationIcon;
late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  @override
  Widget build(BuildContext context) {
    var genislik = MediaQuery.of(context).size.width;
    var yukseklik = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1), shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person,
                    size: 29,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: yukseklik * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: yukseklik * 0.08,
                      width: genislik * 0.95,
                      child: Center(
                        child: Text((destination==null)?"Target":destination.toString(),
                        style: TextStyle(color: Colors.white),)
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(19),
                          topLeft: Radius.circular(19),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: yukseklik * 0.08,
                      width: genislik * 0.95,
                      child: Center(
                        child: TextButton(
                          child: Text(
                            "Set",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              getDestination();
                            });
                            
                          },
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(19),
                          topRight: Radius.circular(19),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.shade500,
                            Colors.deepPurple.shade500
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: yukseklik * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: yukseklik * 0.08,
                      width: genislik * 0.95,
                      child: Center(
                        child: Text((target==null)?"Target":target.toString(),style: TextStyle(color: Colors.white),)
                           
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(19),
                          topLeft: Radius.circular(19),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: yukseklik * 0.08,
                      width: genislik * 0.95,
                      child: Center(
                        child: TextButton(
                          child: Text(
                            "Set",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                           getTarget();
                          },
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(19),
                          topRight: Radius.circular(19),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.shade500,
                            Colors.deepPurple.shade500
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: yukseklik * 0.04,
            ),
            TextButton(
              onPressed: ()async {  await _createPolylines(destination!.latitude, destination!.longitude, target!.latitude, target!.longitude);     },
              child: Text(
                "Hedef Konum",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.grey),
            ),
            SizedBox(
              height: yukseklik * 0.04,
            ),
            Container(
              height: yukseklik * 0.29,
              width: genislik * 0.95,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: GoogleMap(
                  polylines: Set<Polyline>.of(polylines.values),
                  markers: _markers,
                    onMapCreated: _onMapCreated,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: _kGooglePlex),
              ),
            ),
            SizedBox(
              height: yukseklik * 0.04,
            ),
            
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: genislik * 0.95,
                      height: yukseklik * 0.14,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.star_rounded,
                              size: 29,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: genislik * 0.05,
                          ),
                          Text(
                            "Kaydedilen Yerler",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: genislik * 0.3,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 24,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   getDestination() async {
    final LatLng destin = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapPage()));
  
      
      print(destin);
   
    setState(() {
      destination=destin;
    });
  }
  getTarget() async {
    final LatLng destin = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapPage()));
  
      
      print(destin);
   
    setState(() {
      target=destin;
    });
  }
  Future<void> _drawPolyline(LatLng from, LatLng to) async {
    Polyline polyline = await PolylineService().drawPolyline(from, to);

   await _polylines.add(polyline);

    _setMarker(from);
    _setMarker(to);

    setState(() {});
  }

  void _setMarker(LatLng _location) {
    Marker newMarker = Marker(
      markerId: MarkerId(_location.toString()),
      icon: BitmapDescriptor.defaultMarker,
      // icon: _locationIcon,
      position: _location,
      infoWindow: InfoWindow(
          title: "Title",
          snippet: "${currentLocation!.latitude}, ${currentLocation!.longitude}"),
    );
    _markers.add(newMarker);
    setState(() {});
  }
   _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyD9NT_CiWDgItIN6pWWVzrDDiTFMgQCh_s", // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

}
