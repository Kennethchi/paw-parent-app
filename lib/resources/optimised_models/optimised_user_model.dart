import 'package:meta/meta.dart';



class OptimisedUserModel{


  String username;
  String profileName; // user profile name
  String thumb;
  int numDogs;
  int numFollowings;
  int numInsights;
  String fcm_token;
  dynamic online;

  bool hasNewMessages;

  OptimisedUserModel({
    @required this.username,
    @required this.profileName,
    this.thumb,
    this.fcm_token
  }){
     numDogs = 0;
     numFollowings = 0;
     numInsights = 0;

     hasNewMessages = false;
  }


  OptimisedUserModel.fromJson({@required Map<dynamic, dynamic> json}){

    this.username = json[OptimisedUserChiledFieldNames.username];
    this.profileName = json[OptimisedUserChiledFieldNames.profile_name];
    this.thumb = json[OptimisedUserChiledFieldNames.thumb];
    this.numDogs = json[OptimisedUserChiledFieldNames.num_dogs];
    this.numFollowings = json[OptimisedUserChiledFieldNames.num_followings];
    this.numInsights = json[OptimisedUserChiledFieldNames.num_insights];
    this.fcm_token = json[OptimisedUserChiledFieldNames.fcm_token];
    this.online = json[OptimisedUserChiledFieldNames.online];
    this.hasNewMessages = json[OptimisedUserChiledFieldNames.has_new_messages];
  }




  Map<dynamic, dynamic> toJson(){

    Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data[OptimisedUserChiledFieldNames.username] = this.username;
    data[OptimisedUserChiledFieldNames.profile_name] = this.profileName;
    data[OptimisedUserChiledFieldNames.thumb] = this.thumb;
    data[OptimisedUserChiledFieldNames.num_dogs] = this.numDogs;
    data[OptimisedUserChiledFieldNames.num_followings] = this.numFollowings;
    data[OptimisedUserChiledFieldNames.num_insights] = this.numInsights;
    data[OptimisedUserChiledFieldNames.fcm_token] = this.fcm_token;
    data[OptimisedUserChiledFieldNames.online] = this.online;
    data[OptimisedUserChiledFieldNames.has_new_messages] = this.hasNewMessages;

    return data;
  }


}



class OptimisedUserChiledFieldNames{
  
  static const String profile_name = "profile_name";
  static const String username = "username";
  static const String thumb = "thumb";
  static const String num_dogs = "num_dogs";
  static const String num_followings = "num_followings";
  static const String num_insights = "num_insights";
  static const String fcm_token = "fcb_token";
  static const String online = "online";
  static const String has_new_messages = "has_new_messages";
}










