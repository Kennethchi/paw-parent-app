import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';


class ImageModel{


  List<dynamic> imagesUrl;
  List<dynamic> imagesThumbsUrl;


  ImageModel({
    @required this.imagesUrl,
    @required this.imagesThumbsUrl,
  });


  ImageModel.fromJson(Map<dynamic, dynamic> json){

    this.imagesUrl = json[ImageDocumentFieldNames.images_url];
    this.imagesThumbsUrl = json[ImageDocumentFieldNames.images_thumbs_url];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[ImageDocumentFieldNames.images_thumbs_url] = this.imagesThumbsUrl;
    data[ImageDocumentFieldNames.images_url] = this.imagesUrl;

    return data;
  }
}

class ImageDocumentFieldNames {

  static const String images_url = "images_url";
  static const String images_thumbs_url = "images_thumbs_url";
}


