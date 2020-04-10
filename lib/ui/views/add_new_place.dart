import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/ui/widgets/image_input.dart';
import 'package:flutter_provider_arch/ui/widgets/location_input.dart';
import 'package:flutter_provider_arch/viewmodels/home_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class AddNewPlace extends StatefulWidget {
  final HomeViewViewModel model;

  const AddNewPlace({this.model});
  @override
  _AddNewPlaceState createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlace> {
  final _titleController = TextEditingController();
  String imagePath;
  LocationData location;

  double userRating=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new place'),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            _buildTextField(),
            ImageInput(
              onImageTaken: _onImageTaken,
            ),
            LocationInput(onLocationSelected: _onLocationSelected),
            _buildRatingBar(),
            _buildSaveButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(),
        ),
        prefixIcon: Icon(Icons.my_location),
        hintText: 'Kathmandu',
        labelText: 'Enter a place name',
      ),
    );
  }

  _onImageTaken(String image) {
    imagePath = image;
    //assign this value to a local variable
  }

  _onLocationSelected(LocationData locationData) {
    location = locationData;
  }

  Widget _buildSaveButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Colors.blue[500],
        child: FlatButton.icon(
          onPressed: () {
            savePlace(context);
          },
          icon: Icon(Icons.save),
          label: Text("Save"),
        ),
      ),
    );
  }

  void savePlace(BuildContext context) {
    if (_titleController.text.isEmpty ||
        imagePath == null ||
        location == null||
        userRating ==0
        ) {
      Fluttertoast.showToast(msg: "Please fill all the data");
      return;
    }
    widget.model.insertPlace(_titleController.text, imagePath, location,userRating);

    Navigator.of(context).pop();
  }

  Widget _buildRatingBar() {
  return  RatingBar(
   initialRating: 1,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemCount: 5,
   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: (rating) {
    userRating= rating;
     print(rating);
   },
);
  }
}
