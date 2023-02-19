
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';



class DogModel{


  UserModel ownerUserModel;

  String profileName;
  String username;
  String userId;
  String profileImage;
  String profileImageThumb;
  Timestamp creationTimestamp;
  String dogBreed;
  String genderType;
  bool isVaccinated;
  bool isMixedBreed;
  Timestamp dateOfBirth;
  String about;
  String ownerUserId;


  int numFollowers;
  int numLikes;
  int numPosts;

  bool adoptible;
  List<dynamic> dogBehaviorsList;

  DogModel({
    @required this.profileName,
    @required this.username,
    @required this.userId,
    @required this.profileImage = "",
    @required this.profileImageThumb = "",
    @required this.creationTimestamp,
    @required this.dogBreed,
    @required this.genderType,
    @required this.isVaccinated,
    @required this.isMixedBreed,
    @required this.dateOfBirth,
    @required this.about,
    @required this.ownerUserId,
    @required this.adoptible = false,
    this.dogBehaviorsList
  }){

    this.numFollowers = 0;
    this.numLikes = 0;
    this.numPosts = 0;
  }

  DogModel.fromJson(Map<String, dynamic> json){

    this.profileName = json[DogsDocumentFieldNames.profile_name];
    this.username = json[DogsDocumentFieldNames.username];
    this.userId = json[DogsDocumentFieldNames.user_id];
    this.profileImage = json[DogsDocumentFieldNames.profile_image];
    this.profileImageThumb = json[DogsDocumentFieldNames.profile_image_thumb];
    this.creationTimestamp = json[DogsDocumentFieldNames.creation_timestamp];
    this.dogBreed = json[DogsDocumentFieldNames.dog_breed];
    this.genderType = json[DogsDocumentFieldNames.gender_type];
    this.isVaccinated = json[DogsDocumentFieldNames.is_vaccinated];
    this.isMixedBreed = json[DogsDocumentFieldNames.is_mixed_breed];
    this.dateOfBirth = json[DogsDocumentFieldNames.date_of_birth];
    this.about = json[DogsDocumentFieldNames.about];
    this.ownerUserId = json[DogsDocumentFieldNames.owner_user_id];

    this.numFollowers = json[DogsDocumentFieldNames.num_followers];
    this.numLikes = json[DogsDocumentFieldNames.num_likes];
    this.numPosts = json[DogsDocumentFieldNames.num_posts];

    this.adoptible = json[DogsDocumentFieldNames.adoptible];
    this.dogBehaviorsList = json[DogsDocumentFieldNames.dog_hehaviors_list];
  }

  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = Map<String, dynamic>();

    data[DogsDocumentFieldNames.profile_name] = this.profileName;
    data[DogsDocumentFieldNames.username] = this.username;
    data[DogsDocumentFieldNames.user_id] = this.userId;
    data[DogsDocumentFieldNames.profile_image] = this.profileImage;
    data[DogsDocumentFieldNames.profile_image_thumb] = this.profileImageThumb;
    data[DogsDocumentFieldNames.creation_timestamp] = this.creationTimestamp;
    data[DogsDocumentFieldNames.dog_breed] = this.dogBreed;
    data[DogsDocumentFieldNames.gender_type] = this.genderType;
    data[DogsDocumentFieldNames.is_vaccinated] = this.isVaccinated;
    data[DogsDocumentFieldNames.is_mixed_breed] = this.isMixedBreed;
    data[DogsDocumentFieldNames.date_of_birth] = this.dateOfBirth;
    data[DogsDocumentFieldNames.about] = this.about;
    data[DogsDocumentFieldNames.owner_user_id] = this.ownerUserId;

    data[DogsDocumentFieldNames.num_followers] = this.numFollowers;
    data[DogsDocumentFieldNames.num_likes] = this.numLikes;
    data[DogsDocumentFieldNames.num_posts] = this.numPosts;

    data[DogsDocumentFieldNames.adoptible] = this.adoptible;
    data[DogsDocumentFieldNames.dog_hehaviors_list] = this.dogBehaviorsList;
    return data;
  }


}



class DogsDocumentFieldNames{
  
  static String profile_name = "profile_name";
  static String username = "username";
  static String user_id = "user_id";
  static String profile_image = "profile_image";
  static String profile_image_thumb = "profile_image_thumb";
  static String creation_timestamp = "creation_timestamp";
  static String dog_breed = "dog_breed";
  static String gender_type = "gender_type";
  static String is_vaccinated = "is_vaccinated";
  static String is_mixed_breed = "is_mixed_breed";
  static String date_of_birth = "date_of_birth";
  static String about = "about";
  static String owner_user_id = "owner_user_id";

  static String num_followers = "num_followers";
  static String num_likes = "num_likes";
  static String num_posts = "num_posts";

  static String adoptible = "adoptible";
  static String dog_hehaviors_list = "dog_behaviors_list";
}



