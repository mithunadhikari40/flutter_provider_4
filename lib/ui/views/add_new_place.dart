import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/ui/widgets/image_input.dart';
import 'package:flutter_provider_arch/ui/widgets/location_input.dart';
import 'package:location/location.dart';

class AddNewPlace extends StatefulWidget {
  @override
  _AddNewPlaceState createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlace> {
  final _titleController = TextEditingController();
  String imagePath;
  LocationData location;

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
            _buildSaveButton()
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

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Colors.blue[500],
        child: FlatButton.icon(
          onPressed: () {
            
          },
          icon: Icon(Icons.save),
          label: Text("Save"),
        ),
      ),
    );
  }
}
