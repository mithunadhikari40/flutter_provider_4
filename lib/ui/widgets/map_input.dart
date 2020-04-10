import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInput extends StatefulWidget {
  final LocationData locationData;
  final bool shouldShowIcon;
  final Function(LatLng latLng) onSelectLocation;

  const MapInput(
      {this.locationData, this.shouldShowIcon, this.onSelectLocation});
  @override
  _MapInputState createState() => _MapInputState();
}

class _MapInputState extends State<MapInput> {
  Set<Marker> markers = {};

  LatLng _tappedLocation;

  Set<Polyline> _polyLines = {};

  GoogleMapController _googleMapController;
  @override
  initState() {
    super.initState();
    Marker marker = Marker(
        markerId: MarkerId(widget.locationData.toString()),
        position: LatLng(
            widget.locationData.latitude, widget.locationData.longitude));
    setState(() {
      markers.clear();
      markers.add(marker);
    });
    drawPolyLines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your map"),
        actions: <Widget>[
          widget.shouldShowIcon
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // _googleMapController.moveCamera(CameraUpdate.newLatLng(
                    //   LatLng(27.32,85.32)
                    // ));
                    if (_tappedLocation != null) {
                      widget.onSelectLocation(_tappedLocation);
                      Navigator.of(context).pop();
                    }
                  },
                )
              : Container()
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      widget.locationData.latitude, widget.locationData.longitude),
                  zoom: 12,
                ),
                onTap: _onMapTap,
                markers: markers,
                polylines: _polyLines,
              ),
            );
          }
        
          void _onMapTap(LatLng argument) {
            if (!widget.shouldShowIcon) {
              return;
            }
        
            Marker marker =
                Marker(markerId: MarkerId(argument.toString()), position: argument);
            _tappedLocation = argument;
            setState(() {
              markers.clear();
              markers.add(marker);
            });
          }
        
          void drawPolyLines() async {
            List<LatLng> positions = await getRouteCoordinatesFromMapBox();
            setState(() {
              _polyLines.add(Polyline(
                polylineId: PolylineId(
                  positions.toString(),
                ),
                points: positions,
                width: 10,
                color: Colors.red,
                endCap: Cap.buttCap,
                startCap: Cap.roundCap
              ));
            });
          }
        
          Future<List<LatLng>> getRouteCoordinatesFromMapBox() async {
            LatLng l1 = LatLng(27.6716422, 85.313211);
            LatLng l2 = LatLng(27.6952267, 85.3261583);
            String url =
                "https://api.mapbox.com/directions/v5/mapbox/driving/${l1.longitude},${l1.latitude};${l2.longitude},${l2.latitude}?geometries=geojson&access_token=pk.eyJ1IjoiYWRoaWthcmktbWl0aHVuIiwiYSI6ImNqeWU5MzZ6bjB6YXozbnM1YWcxdW1nNmoifQ.HrgzxoSLBUjpdiMIS0Kusg";
            Response response = await get(url);
        
            Map values = jsonDecode(response.body);
        
            List<dynamic> other =
                values["routes"][0]["geometry"]["coordinates"] as List<dynamic>;
        
            List<LatLng> list = [];
        
            other?.forEach((val) {
              if (val != null) list.add((LatLng(val[1], val[0])));
            });
        
            return list;
          }
        
          void _onMapCreated(GoogleMapController controller) {
            this.setState((){
              _googleMapController= controller;
            });
  }
}

/*
 return FileSystemEntity.typeSync(imagePath) !=
        FileSystemEntityType.notFound;
        */
