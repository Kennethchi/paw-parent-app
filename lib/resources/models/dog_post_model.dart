import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';



class DogPostModel{

  DogModel dogModel;
  UserModel ownerUserModel;


  String postId;
  String postType;
  Map<dynamic, dynamic> postData;
  Timestamp timestamp;

  String postCaption;

  String dogUserId;
  String ownerUserId;

  int numLikes;
  int numComments;
  int numShares;

  DogPostModel({
    this.postId,
    @required this.postType,
    @required this.postData,
    @required this.postCaption,
    @required this.timestamp,
    @required this.dogUserId,
    @required this.ownerUserId
  }){
    numLikes = 0;
    numComments = 0;
    numShares = 0;

    if (this.postCaption == null){
      this.postCaption = "";
    }
  }


  DogPostModel.fromJson(Map<String, dynamic> json){

    this.postId = json[DogPostDocumentFieldName.post_id];
    this.postType = json[DogPostDocumentFieldName.post_type];
    this.postData = json[DogPostDocumentFieldName.post_data];
    this.postCaption = json[DogPostDocumentFieldName.post_caption];
    this.timestamp = json[DogPostDocumentFieldName.timestamp];
    this.dogUserId = json[DogPostDocumentFieldName.dog_user_id];
    this.ownerUserId = json[DogPostDocumentFieldName.owner_user_id];

    this.numLikes = json[DogPostDocumentFieldName.num_likes];
    this.numComments = json[DogPostDocumentFieldName.num_comments];
    this.numShares = json[DogPostDocumentFieldName.num_shares];

  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[DogPostDocumentFieldName.post_id] = this.postId;
    data[DogPostDocumentFieldName.post_type] = this.postType;
    data[DogPostDocumentFieldName.post_data] = this.postData;
    data[DogPostDocumentFieldName.post_caption] = this.postCaption;
    data[DogPostDocumentFieldName.timestamp] = this.timestamp;
    data[DogPostDocumentFieldName.dog_user_id] = this.dogUserId;
    data[DogPostDocumentFieldName.owner_user_id] = this.ownerUserId;

    data[DogPostDocumentFieldName.num_likes] = this.numLikes;
    data[DogPostDocumentFieldName.num_comments] = this.numComments;
    data[DogPostDocumentFieldName.num_shares] = this.numShares;

    return data;
  }


}

class DogPostDocumentFieldName {
  static const String post_id = "post_id";
  static const String post_type = "post_type";
  static const String post_data = "post_data";
  static const String post_caption = "post_caption";
  static const String timestamp = "timestamp";
  static const String dog_user_id = "dog_user_id";
  static const String owner_user_id = "owner_user_id";

  static const String num_likes = "num_likes";
  static const String num_comments = "num_comments";
  static const String num_shares = "num_shares";

}



