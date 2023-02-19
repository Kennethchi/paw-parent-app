import 'dart:async' show Future;
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart' show BuildContext;
//import 'package:image/image.dart' as Im;
import 'dart:math' as Math;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:meta/meta.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:paw_parent_app/constants/constants.dart';




class ImageUtils{

  static Future<File> getCompressedImageFile({@required File imageFile, @required int minWidth, @required int quality}) async {

    final tempDir = await getTemporaryDirectory();
    final rand = DateTime.now().microsecondsSinceEpoch;
    
    return await FlutterImageCompress.compressAndGetFile(imageFile.path, tempDir.path + "/" + rand.toString() + FileExtensions.jpg, minWidth: minWidth, format: CompressFormat.jpeg,
        quality: quality != null? quality: 90);
  }


  /*
  static Future<File> getCompressedImageFile({@required File imageFile, @required int maxWidth, @required int quality}) async {

    final tempDir = await getTemporaryDirectory();
    final rand = DateTime.now().microsecondsSinceEpoch;
    _CompressObject compressObject =
    _CompressObject(imageFile, tempDir.path, rand, maxWidth, quality);
    String filePath = await _compressImage(compressObject);
    File file = File(filePath);

    return file;
  }

  static Future<String> _compressImage(_CompressObject object) async {
    return compute(_decodeImage, object);
  }

  static Future<String> _decodeImage(_CompressObject object) async{

    Im.Image image = Im.decodeImage(object.imageFile.readAsBytesSync());

    Im.Image smallerImage;

    if(image.width == image.height){
      smallerImage = Im.copyResize(image, width: object.maxWidth, height: object.maxWidth); // choose the size here, it will maintain aspect ratio
    }
    else if (image.width > image.height){
      smallerImage = Im.copyResize(image, width: object.maxWidth, height: null); // choose the size here, it will maintain aspect ratio
    }
    else{
      smallerImage = Im.copyResize(image, width: null, height: object.maxWidth); // choose the size here, it will maintain aspect ratio
    }


    var decodedImageFile = File(object.path + '/img_${object.rand}.jpg');
    decodedImageFile.writeAsBytesSync(Im.encodeJpg(smallerImage, quality: object.quality));
    return decodedImageFile.path;
  }


   */

}


/*
class _CompressObject {
  File imageFile;
  String path;
  int rand;
  int maxWidth;
  int quality;

  _CompressObject(this.imageFile, this.path, this.rand, this.maxWidth, this.quality);
}

 */