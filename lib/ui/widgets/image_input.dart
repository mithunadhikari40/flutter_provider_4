import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/utils/image_helper.dart';
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
          ...getChildren(context),
        ],
      ),
    );
  }

  void _takePicture(BuildContext context) async {
    FocusScope.of(context).unfocus(focusPrevious: true);

    var file = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      //todo compress the file
      // file = await ImageHelper.compressImage(file.absolute.path, file);
      setState(() {
        image = file;
      });
      widget.onImageTaken(file.absolute.path);
    }
  }

  List<Widget> getChildren(BuildContext context) {
    var list = <Widget>[];
    list.add(Expanded(
      flex: 1,
      child: image == null ? Text("No Image taken") : Image.file(image),
    ));
    list.add(SizedBox(
      width: 16,
    ));
    list.add(Expanded(
      flex: 1,
      child: FlatButton.icon(
        onPressed: () {
          _takePicture(context);
        },
        color: Colors.blue[200],
        icon: Icon(Icons.camera),
        label: Text("Take picture"),
      ),
    ));
    return list;
  }
}
