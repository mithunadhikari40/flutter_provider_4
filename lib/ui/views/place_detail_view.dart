import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:location/location.dart';

class PlaceDetailView extends StatelessWidget {
  final Place place;
  PlaceDetailView({this.place});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // physics: AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(place.title),
              background: Image.file(File(place.imagePath),fit: BoxFit.cover,),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _buildBox(),
                _buildAddressSection(),
                _buildMapSection(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBox() {
    return Container(
      color: Colors.green[200],
      height: 800,
    );
  }

  Widget _buildAddressSection() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        place.address,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
    );
  }
   Widget _buildMapSection(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(RoutePaths.MapInput,
        arguments: [LocationData.fromMap({"latitude":place.latitude,"longitude":place.longitude}),
         false, null]);

      },
          child: Container(
            margin: EdgeInsets.all(16),
                  alignment: Alignment.center,

        child: Text(
          "View on map",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
