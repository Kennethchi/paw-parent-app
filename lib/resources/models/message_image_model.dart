
class MessageImageModel{

  List<dynamic> imagesUrl;
  List<dynamic> imagesThumbsUrl;

  MessageImageModel({
    this.imagesUrl,
    this.imagesThumbsUrl
  });



  MessageImageModel.fromJson(Map<dynamic, dynamic> json){

    this.imagesUrl = json[MessageImageDocumentFieldNames.images_url];
    this.imagesThumbsUrl = json[MessageImageDocumentFieldNames.images_thumbs_url];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[MessageImageDocumentFieldNames.images_thumbs_url] = this.imagesThumbsUrl;
    data[MessageImageDocumentFieldNames.images_url] = this.imagesUrl;

    return data;
  }

}

class MessageImageDocumentFieldNames {
  static const String images_url = "images_url";
  static const String images_thumbs_url = "images_thumbs_url";
}