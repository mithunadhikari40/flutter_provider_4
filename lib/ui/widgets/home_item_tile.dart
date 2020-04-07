import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/utils/image_helper.dart';

class HomeItemTile extends StatelessWidget {
  final Place place;
  final Function(Place,BuildContext) onPlaceTap;

  const HomeItemTile(this.place,this.onPlaceTap);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onPlaceTap(place,context);
      },
      title: Text(place.title),
      subtitle: Text(place.address),
      leading: Hero(
        tag:place.id,
              child: CircleAvatar(

          backgroundImage: 
          ImageHelper.imageExists(place.imagePath) ? 
          FileImage(File(place.imagePath)):
          CachedNetworkImageProvider(place.imagePath,),
        ),
      ),
    );
  }
}