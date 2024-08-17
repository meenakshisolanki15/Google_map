import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserCurrentLocation extends StatefulWidget {
  const UserCurrentLocation({super.key});

  @override
  State<UserCurrentLocation> createState() => _UserCurrentLocationState();
}

class _UserCurrentLocationState extends State<UserCurrentLocation> {

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.6762, 139.6503),
    zoom: 14,
  );

  final List<Marker> _markers =  <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(35.6762, 139.6503),
        infoWindow: InfoWindow(
            title: "My position"
        )
    )
  ];

  Future<Position> getUserCurrentLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace){
      print("error"+error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_markers),
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getUserCurrentLocation().then((value)async{
            print('my current location');
            print(value.latitude.toString() + " "+value.longitude.toString());

            _markers.add(
                Marker(
                    markerId: MarkerId('2'),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: InfoWindow(
                        title: 'My Current Location'
                    )
                )
            );

            CameraPosition cameraPosition = CameraPosition(
                zoom: 14,
                target: LatLng(value.latitude, value.longitude));

            final GoogleMapController controller = await _controller.future;

            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {

            });


          });
        },
        child: Icon(Icons.local_activity),
      ),
    );
  }
}
