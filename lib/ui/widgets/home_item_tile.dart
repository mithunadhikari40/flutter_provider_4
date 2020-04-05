import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/models/places.dart';

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
      leading: CircleAvatar(
        backgroundImage: FileImage(File(place.imagePath))
      ),
    );
  }
}