import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
final Function(String) onImageTaken;

ImageInput({this.onImageTaken});

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: image == null ? Text("No Image taken") : Image.file(image),
          ),
          Expanded(
              flex: 1,
              child: FlatButton.icon(
                color: Colors.blue[500],
                onPressed: _takePicture,
                icon: Icon(Icons.camera),
                label: Text("Take picture"),
              )),
        ],
      ),
    );
  }

  void _takePicture() async {
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(file!= null){
      setState(() {
        image= file;
      });

      widget.onImageTaken(file.absolute.path);
    }
  }
}
