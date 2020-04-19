import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/utils/image_helper.dart';
import 'package:flutter_provider_arch/viewmodels/home_view_model.dart';

class HomeItemTile extends StatelessWidget {
  final Place place;
  final HomeViewViewModel model;
  final Function(Place, BuildContext) onPlaceTap;
  final Function(Place, HomeViewViewModel) onDelete;
  final Function(Place,HomeViewViewModel) onUpdate;
  final Key _key =  GlobalKey();
  HomeItemTile(this.place, this.onPlaceTap,this.onDelete,this.onUpdate,this.model);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: _key,
      background:  Container(
        color:  Colors.red,
      ),
      secondaryBackground: Container(
        color: Colors.green,
      ),
      onDismissed: _onDismissed,
      // confirmDismiss: _confirmDismiss,
      child: ListTile(
        onTap: () {
          onPlaceTap(place, context);
        },
        title:  Text(place.title),
        subtitle: Text(place.address),
        leading: Hero(
          tag: place.id,
          child: CircleAvatar(
            backgroundImage: ImageHelper.imageExists(place.imagePath)
                ? FileImage(File(place.imagePath))
                : CachedNetworkImageProvider(
                    place.imagePath,
                  ),
          ),
        ),
      ),
    );
  }

  void _onDismissed(DismissDirection direction) {
          print("Delete item $direction");

    if(direction== DismissDirection.startToEnd){
      print("Delete item");
      // onDelete(place,model);
      model.deleteItem(place.id);

      //todo delete that item
    }
    if(direction== DismissDirection.endToStart){
      //update item
            onUpdate(place,model);

    }

  }

  // Future<bool> _confirmDismiss(DismissDirection direction) async {
  //   return true;
  // }
}
