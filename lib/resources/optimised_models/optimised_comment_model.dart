import 'package:meta/meta.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';



class OptimisedCommentModel implements Comparable<OptimisedCommentModel>{

  UserModel userModel;


  String id;
  String name;
  String username;
  String user_id;
  String thumb;
  String comment;
  int t;


  OptimisedCommentModel({
    this.id,
    this.name,
    this.username,
    @required this.user_id,
    this.thumb,
    @required this.comment,
    @required this.t,
});


  OptimisedCommentModel.fromJson(Map<dynamic, dynamic> json){

    this.id = json[CommentFieldNamesOptimised.id];
    this.name = json[CommentFieldNamesOptimised.name];
    this.username = json[CommentFieldNamesOptimised.username];
    this.user_id = json[CommentFieldNamesOptimised.user_id];
    this.thumb = json[CommentFieldNamesOptimised.thumb];
    this.comment = json[CommentFieldNamesOptimised.comment];
    this.t = json[CommentFieldNamesOptimised.t];
  }


  Map<dynamic, dynamic> toJson(){

    Map<dynamic, dynamic> data = Map<dynamic, dynamic>();

    data[CommentFieldNamesOptimised.id] = this.id;
    data[CommentFieldNamesOptimised.name] = this.name;
    data[CommentFieldNamesOptimised.username] = this.username;
    data[CommentFieldNamesOptimised.user_id] = this.user_id;
    data[CommentFieldNamesOptimised.thumb] = this.thumb;
    data[CommentFieldNamesOptimised.comment] = this.comment;
    data[CommentFieldNamesOptimised.t] = this.t;

    return data;
  }



  @override
  int compareTo(OptimisedCommentModel other) {
    // TODO: implement compareTo


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

  }




}


class CommentFieldNamesOptimised{

  static const String id = "id";
  static const String name = "name";
  static const String username = "username";
  static const String user_id = "user_id";
  static const String thumb = "thumb";
  static const String comment = "comment";
  static const String t = "t";
}

