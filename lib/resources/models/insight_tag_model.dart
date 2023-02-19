



import 'package:flutter/foundation.dart';

class InsightTagModel{


  String uniqueName;
  String tagId;
  int count;


  InsightTagModel({
    @required this.uniqueName,
  }){
    count = 0;
  }


  InsightTagModel.fromJson(Map<dynamic, dynamic> json){

    this.uniqueName = json[InsightTagModelDocumentFieldNames.unique_name];
    this.count = json[InsightTagModelDocumentFieldNames.count];
    this.tagId = json[InsightTagModelDocumentFieldNames.tag_id];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[InsightTagModelDocumentFieldNames.unique_name] = this.uniqueName;
    data[InsightTagModelDocumentFieldNames.count] = this.count;
    data[InsightTagModelDocumentFieldNames.tag_id] = this.tagId;

    return data;
  }
}

class InsightTagModelDocumentFieldNames {

  static const String unique_name = "unique_name";
  static const String count = "count";
  static const String tag_id = "tag_id";
}


