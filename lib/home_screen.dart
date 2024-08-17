import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(30.252311, 78.194216),
    zoom: 14.0,
  );

  List<Marker> _marker = [];
  final List<Marker> _list = const [
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(30.252311, 78.194216),
        infoWindow: InfoWindow(
            title: "My Current Position"
        )
    ),
    Marker(
        markerId: MarkerId("2"),
        position: LatLng(30.1800, 78.1200),
        infoWindow: InfoWindow(
            title: "My Current Position"
        )
    ),
    Marker(
        markerId: MarkerId("3"),
        position: LatLng(30.1034, 78.2948),
        infoWindow: InfoWindow(
            title: "My Current Position"
        )
    ),

  ];

  void initState(){
    super.initState();
    _marker.addAll(_list);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: kGooglePlex,
          markers: Set<Marker>.of(_marker),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_disabled_outlined),
        onPressed: ()async{
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(35.6762, 139.6503),
                  zoom: 14
              )
          ));
          setState(() {

          });
        },
      ),
    );
  }
}
