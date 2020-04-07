import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageHelper{
  static Future<File> compressImage(String targetLocation, File file) async{
     var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetLocation,
        quality: 88,
      );
      return result;
  }
  static bool imageExists(String imagePath){
    return FileSystemEntity.typeSync(imagePath) != FileSystemEntityType.notFound;


  }
}