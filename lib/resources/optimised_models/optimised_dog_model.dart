
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';



class OptimisedDogModel{

  String profileName;
  String username;
  String thumb;

  int numFollowers;
  int numLikes;
  int numPosts;


  OptimisedDogModel({
    @required this.profileName,
    @required this.username,
    @required this.thumb
  }){

    this.numFollowers = 0;
    this.numLikes = 0;
    this.numPosts = 0;
  }

  OptimisedDogModel.fromJson(Map<dynamic, dynamic> json){

    this.profileName = json[OptimisedDogsChildFieldNames.profile_name];
    this.username = json[OptimisedDogsChildFieldNames.username];
    this.thumb = json[OptimisedDogsChildFieldNames.thumb];
    this.numFollowers = json[OptimisedDogsChildFieldNames.num_followers];
    this.numLikes = json[OptimisedDogsChildFieldNames.num_likes];
    this.numPosts = json[OptimisedDogsChildFieldNames.num_posts];
  }

  Map<dynamic, dynamic> toJson(){

    Map<dynamic, dynamic> data = Map<dynamic, dynamic>();

    data[OptimisedDogsChildFieldNames.profile_name] = this.profileName;
    data[OptimisedDogsChildFieldNames.username] = this.username;
    data[OptimisedDogsChildFieldNames.thumb] = this.thumb;
    data[OptimisedDogsChildFieldNames.num_followers] = this.numFollowers;
    data[OptimisedDogsChildFieldNames.num_likes] = this.numLikes;
    data[OptimisedDogsChildFieldNames.num_posts] = this.numPosts;

    return data;
  }


}



class OptimisedDogsChildFieldNames{

  static String profile_name = "profile_name";
  static String username = "username";
  static String thumb = "thumb";
  static String num_followers = "num_followers";
  static String num_likes = "num_likes";
  static String num_posts = "num_posts";
}



