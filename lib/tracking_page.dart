import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation =  LatLng(30.254199264151467, 78.19497015118559);
  static const LatLng destination =  LatLng(30.345134, 78.020225);

  List<LatLng> polylineCoordinates  = [];
  LocationData? currentLocation;

  void getCurrentLocation ()async {
    Location location = Location();


    location.getLocation().then((location){
      currentLocation = location;
    },
    );

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc){
      currentLocation = newLoc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 13.5,
            target: LatLng(
              newLoc.latitude!,
              newLoc.longitude!,
            )
        ),
      ),
      );
      setState((){

      });
    },
    );
  }
  void getPolyPoints() async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyAENUK9T0WxZvO3uA7EJO91tBUR1iDj6oY",
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude)
    );
    if(result.points.isNotEmpty){
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {

      });
    }

  }

  void initState(){
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track path",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),

      body: currentLocation == null ? Text("Loading") :
      GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(
                currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 13.0),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.orange,
            width: 6,
          ),
        },

        markers: {
          Marker(
              markerId: MarkerId("currentLocation"),
              position: LatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!)
          ),
          Marker(
            markerId: MarkerId("source"),
            position: sourceLocation,
          ),
          Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
        },
        mapType: MapType.normal,
        onMapCreated: (mapController){
          _controller.complete(mapController);
        },
      ),

    );
  }
}
