import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInput extends StatefulWidget {
  final LocationData locationData;

  const MapInput({this.locationData});
  @override
  _MapInputState createState() => _MapInputState();
}

class _MapInputState extends State<MapInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your map"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.locationData.latitude, widget.locationData.longitude),
              zoom: 12,
        ),
      ),
    );
  }
}
