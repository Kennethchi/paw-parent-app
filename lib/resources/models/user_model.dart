
import 'package:cloud_firestore/cloud_firestore.dart';




class UserModel{

  String profileName;
  String username;
  String userId;
  String email;
  String password;
  String profileImage;
  String profileImageThumb;
  String userType;
  Timestamp signupTimestamp;
  List<dynamic> dogsList;

  List<dynamic> followedDogsList;
  List<dynamic> dogPostsBookmarkList;
  List<dynamic> insightsBookmarkList;

  UserModel({
    this.profileName,
    this.username,
    this.userId,
    this.email,
    this.password,
    this.profileImage = "",
    this.profileImageThumb = "",
    this.userType,
    this.signupTimestamp,
    this.dogsList,
    this.followedDogsList,
  }){
    this.dogPostsBookmarkList =  List<dynamic>();
    this.insightsBookmarkList = List<dynamic>();
  }


  UserModel.fromJson(Map<String, dynamic> json){
    this.profileName = json[UsersDocumentFieldNames.profile_name];
    this.username = json[UsersDocumentFieldNames.username];
    this.userId = json[UsersDocumentFieldNames.user_id];
    this.email = json[UsersDocumentFieldNames.email];
    this.password = json[UsersDocumentFieldNames.password];
    this.profileImage = json[UsersDocumentFieldNames.profile_image];
    this.profileImageThumb = json[UsersDocumentFieldNames.profile_image_thumb];
    this.userType = json[UsersDocumentFieldNames.user_type];
    this.signupTimestamp = json[UsersDocumentFieldNames.signup_timestamp];
    this.dogsList = json[UsersDocumentFieldNames.dogs_list];
    this.followedDogsList = json[UsersDocumentFieldNames.followed_dogs_list];
    this.dogPostsBookmarkList = json[UsersDocumentFieldNames.dog_posts_bookmark_list];
    this.insightsBookmarkList = json[UsersDocumentFieldNames.insights_bookmark_list];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = Map<String, dynamic>();
    data[UsersDocumentFieldNames.profile_name] = this.profileName;
    data[UsersDocumentFieldNames.username] = this.username;
    data[UsersDocumentFieldNames.user_id] = this.userId;
    data[UsersDocumentFieldNames.email] = this.email;
    data[UsersDocumentFieldNames.password] = this.password;
    data[UsersDocumentFieldNames.profile_image] = this.profileImage;
    data[UsersDocumentFieldNames.profile_image_thumb] = this.profileImageThumb;
    data[UsersDocumentFieldNames.user_type] = this.userType;
    data[UsersDocumentFieldNames.signup_timestamp] = this.signupTimestamp;
    data[UsersDocumentFieldNames.dogs_list] = this.dogsList;
    data[UsersDocumentFieldNames.followed_dogs_list] = this.followedDogsList;
    data[UsersDocumentFieldNames.dog_posts_bookmark_list] = this.dogPostsBookmarkList;
    data[UsersDocumentFieldNames.insights_bookmark_list] = this.insightsBookmarkList;

    return data;
  }

}



class UsersDocumentFieldNames{
  static String profile_name = "profile_name";
  static String username = "username";
  static String user_id = "user_id";
  static String email = "email";
  static String password = "password";
  static String profile_image = "profile_image";
  static String profile_image_thumb = "profile_image_thumb";
  static String user_type = "user_type";
  static String signup_timestamp = "signup_timestamp";
  static String dogs_list = "dogs_list";

  static String followed_dogs_list = "followed_dogs_list";

  static String dog_posts_bookmark_list = "dog_posts_bookmark_list";
  static String insights_bookmark_list = "insights_bookmark_list";
}



