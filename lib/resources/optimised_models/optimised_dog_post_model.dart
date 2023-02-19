import 'package:meta/meta.dart';
import 'dart:core';




class OptimisedDogPostModel implements Comparable<OptimisedDogPostModel>{

  String postId;
  int numLikes;
  int numComments;
  int numShares;

  OptimisedDogPostModel({
    this.postId
  }){

    this.numLikes = 0;
    this.numComments = 0;
    this.numShares = 0;
  }

  OptimisedDogPostModel.fromJson(Map<dynamic, dynamic> json){

    this.postId = json[OptimisedDogPostFieldNames.post_id];
    this.numLikes = json[OptimisedDogPostFieldNames.num_likes];
    this.numComments = json[OptimisedDogPostFieldNames.num_comments];
    this.numShares = json[OptimisedDogPostFieldNames.num_shares];
  }


  Map<dynamic, dynamic> toJson(){

    Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data[OptimisedDogPostFieldNames.post_id] = this.postId;
    data[OptimisedDogPostFieldNames.num_likes] = this.numLikes;
    data[OptimisedDogPostFieldNames.num_comments] = this.numComments;
    data[OptimisedDogPostFieldNames.num_shares] = this.numShares;

    return data;
  }

  @override
  int compareTo(OptimisedDogPostModel other) {


    /*
     // sorts in descending order
     if (this.t < other.t){
       return 1;
     }
     else if (this.t > other.t){
       return -1;
     }
     else{
       return 0;
     }
     */

    // enables sort in descending other
    if (this.postId.compareTo(other.postId) < 0){
      return 1;
    }
    else if(this.postId.compareTo(other.postId) > 0){
      return -1;
    }
    else{
      return 0;
    }


  }



}

class OptimisedDogPostFieldNames {

  static const String post_id = "post_id";
  static const String num_likes = "num_likes";
  static const String num_comments = "num_comments";
  static const String num_shares = "num_shares";
}


