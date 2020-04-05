import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInput extends StatefulWidget {
  final LocationData locationData;
  final bool shouldShowIcon;
  final Function(LatLng latLng) onSelectLocation;

  const MapInput({this.locationData, this.shouldShowIcon,this.onSelectLocation});
  @override
  _MapInputState createState() => _MapInputState();
}

class _MapInputState extends State<MapInput> {
  Set<Marker> markers = {};


  
  LatLng _tappedLocation;


  initState(){
    super.initState();
      Marker marker =
        Marker(markerId: MarkerId(widget.locationData.toString()), position: LatLng(widget.locationData.latitude,widget.locationData.longitude));
    setState(() {
      markers.clear();
      markers.add(marker);
    });
    
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
                    if(_tappedLocation != null){
                      widget.onSelectLocation(_tappedLocation);
                      Navigator.of(context).pop();
                    }
                  },
                )
              : Container()
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.locationData.latitude, widget.locationData.longitude),
          zoom: 12,
        ),
        onTap: _onMapTap,
        markers: markers,
      ),
    );
  }

  void _onMapTap(LatLng argument) {
    Marker marker =
        Marker(markerId: MarkerId(argument.toString()), position: argument);
    _tappedLocation = argument;
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
