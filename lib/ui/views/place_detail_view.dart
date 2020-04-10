import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/utils/image_helper.dart';
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
              background: Hero(
                tag: place.id,
                child: ImageHelper.imageExists(place.imagePath)
                    ? Image.file(
                        File(place.imagePath),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: place.imagePath,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _buildBox(),
                _buildAddressSection(),
                _buildRatingSection(),
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
   Widget _buildRatingSection() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "${place.rating} out of 5",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RoutePaths.MapInput, arguments: [
          LocationData.fromMap(
              {"latitude": place.latitude, "longitude": place.longitude}),
          false,
          null
        ]);
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
