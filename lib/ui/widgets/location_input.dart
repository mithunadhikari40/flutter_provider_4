
import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/utils/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function(LocationData locationData) onLocationSelected;

  const LocationInput({this.onLocationSelected});
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String staticImagePath;
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    Location location = Location();
    location.onLocationChanged().listen((LocationData locationData) {
      updateLocation(locationData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          _buildAddressContainer(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _buildCurrentLocationWidget(),
              ),
              Expanded(
                flex: 1,
                child: _buildMapLocationWidget(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressContainer() {
    return Container(
      height: 200,
      decoration: BoxDecoration(border: Border.all(width: 2)),
      child: staticImagePath == null
          ? Center(child: Text("No Location choosen"))
          : Image.network(
              staticImagePath,
              loadingBuilder: _loadingBuilder,
            ),
    );
  }

  Widget _loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
    return child;
  }

  Widget _buildCurrentLocationWidget() {
    return FlatButton.icon(
      onPressed: () {
        _getUserLocation();
      },
      icon: Icon(Icons.my_location),
      label: Text("Current Location"),
    );
  }

  Widget _buildMapLocationWidget(BuildContext context) {
    return FlatButton.icon(
      onPressed: () {
        _gotoMapScreen(context);
      },
      icon: Icon(Icons.map),
      label: Text("Select on Map"),
    );
  }

  void _getUserLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();
    //todo gererate an static image from mapbox
    print("Current location $_locationData");

    setState(() {
      staticImagePath = LocationHelper.generateStaticImage(
          _locationData.latitude, _locationData.longitude);
    });
    widget.onLocationSelected(_locationData);
  }

  void _gotoMapScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RoutePaths.MapInput,
        arguments: [_locationData, true, _onSelectLocationFromMap]);
  }

  void updateLocation(LocationData location) {
    _locationData = location;
  }

  void _onSelectLocationFromMap(LatLng latLng) {
    setState(() {
      staticImagePath =
          LocationHelper.generateStaticImage(latLng.latitude, latLng.longitude);
    });
    _locationData = LocationData.fromMap(
        {"latitude": latLng.latitude, "longitude": latLng.longitude});

    widget.onLocationSelected(_locationData);
  }
}
