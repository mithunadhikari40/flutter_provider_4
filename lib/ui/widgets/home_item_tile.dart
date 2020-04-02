import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/models/places.dart';

class HomeItemTile extends StatelessWidget {
  final Place place;

  const HomeItemTile(this.place);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(place.title),
      subtitle: Text(place.address),
      leading: CircleAvatar(
        backgroundImage: FileImage(File(place.imagePath))
      ),
    );
  }
}