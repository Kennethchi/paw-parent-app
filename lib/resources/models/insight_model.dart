

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';



class InsightModel{

  UserModel userModel;


  String insightId;
  String insightType;
  Map<dynamic, dynamic> insightData;
  Timestamp timestamp;

  String insightTitle;
  String insightContent;
  List<dynamic> tags;
  String userId;


  int numLikes;
  int numComments;
  int numShares;
  int numSeens;

  InsightModel({
    this.insightId,
    @required this.insightType,
    @required this.insightData,
    @required this.insightTitle,
    @required this.insightContent,
    @required this.tags,
    @required this.timestamp,
    @required this.userId,
  }){
    numLikes = 0;
    numComments = 0;
    numShares = 0;
    numSeens = 0;

    if (this.insightTitle == null){
      this.insightTitle = "";
    }
    if(this.insightContent == null){
      this.insightContent = "";
    }
  }


  InsightModel.fromJson(Map<String, dynamic> json){

    this.insightId = json[InsightDocumentFieldName.insight_id];
    this.insightType = json[InsightDocumentFieldName.insight_type];
    this.insightData = json[InsightDocumentFieldName.insight_data];
    this.insightTitle = json[InsightDocumentFieldName.insight_title];
    this.insightContent = json[InsightDocumentFieldName.insight_content];
    this.tags = json[InsightDocumentFieldName.tags];
    this.timestamp = json[InsightDocumentFieldName.timestamp];
    this.userId = json[InsightDocumentFieldName.user_id];

    this.numLikes = json[InsightDocumentFieldName.num_likes];
    this.numComments = json[InsightDocumentFieldName.num_comments];
    this.numShares = json[InsightDocumentFieldName.num_shares];
    this.numSeens = json[InsightDocumentFieldName.num_seens];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[InsightDocumentFieldName.insight_id] = this.insightId;
    data[InsightDocumentFieldName.insight_type] = this.insightType;
    data[InsightDocumentFieldName.insight_data] = this.insightData;
    data[InsightDocumentFieldName.insight_title] = this.insightTitle;
    data[InsightDocumentFieldName.insight_content] = this.insightContent;
    data[InsightDocumentFieldName.tags] = this.tags;
    data[InsightDocumentFieldName.timestamp] = this.timestamp;
    data[InsightDocumentFieldName.user_id] = this.userId;

    data[InsightDocumentFieldName.num_likes] = this.numLikes;
    data[InsightDocumentFieldName.num_comments] = this.numComments;
    data[InsightDocumentFieldName.num_shares] = this.numShares;
    data[InsightDocumentFieldName.num_seens] = this.numSeens;

    return data;
  }

}



class InsightDocumentFieldName {
  static const String insight_id = "insight_id";
  static const String insight_type = "insight_type";
  static const String insight_data = "insight_data";
  static const String insight_title = "insight_title";
  static const String insight_content = "insight_content";
  static const String tags = "tags";
  static const String timestamp = "timestamp";
  static const String user_id = "user_id";

  static const String num_likes = "num_likes";
  static const String num_comments = "num_comments";
  static const String num_shares = "num_shares";
  static const String num_seens = "num_seens";

}



