import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';


class OptimisedChatModel implements Comparable<OptimisedChatModel>{

  UserModel chatUserModel;
  String username;
  String name;
  String thumb;


  String chat_user_id;
  String sender_id;
  int t;
  String text;
  bool seen;
  bool tp;
  String msg_type;


  OptimisedChatModel({
    @required this.chat_user_id,
    @required this.sender_id,
    this.text,
    @required this.msg_type,
    @required this.seen,
    this.tp = false,
    @required this.t,

    this.name,
    this.username,
    this.thumb
  }) :
        //assert(tp == true || tp == false),
        assert(chat_user_id != null),
        assert(sender_id != null),
        assert(t != null),
        assert(msg_type != null),
        assert(seen != null);



  OptimisedChatModel.fromJson(Map<dynamic, dynamic> json){
    this.chat_user_id = json[OptimisedChatsChildFieldNames.chat_user_id];
    this.username = json[OptimisedChatsChildFieldNames.username];
    this.name = json[OptimisedChatsChildFieldNames.name];
    this.thumb = json[OptimisedChatsChildFieldNames.thumb];

    this.sender_id = json[OptimisedChatsChildFieldNames.sender_id];
    this.text = json[OptimisedChatsChildFieldNames.text];
    this.msg_type = json[OptimisedChatsChildFieldNames.msg_type];
    this.seen = json[OptimisedChatsChildFieldNames.seen];
    this.tp = json[OptimisedChatsChildFieldNames.tp];
    this.t = json[OptimisedChatsChildFieldNames.t];
  }


  Map<dynamic, dynamic> toJson() {

    Map<dynamic, dynamic> data = new Map<String, dynamic>();

    data[OptimisedChatsChildFieldNames.chat_user_id] = this.chat_user_id;
    data[OptimisedChatsChildFieldNames.username] = this.username;
    data[OptimisedChatsChildFieldNames.name] = this.name;
    data[OptimisedChatsChildFieldNames.thumb] = this.thumb;
    data[OptimisedChatsChildFieldNames.sender_id] = this.sender_id;
    data[OptimisedChatsChildFieldNames.text] = this.text;
    data[OptimisedChatsChildFieldNames.msg_type] = this.msg_type;
    data[OptimisedChatsChildFieldNames.seen] = this.seen;
    data[OptimisedChatsChildFieldNames.tp] = this.tp;
    data[OptimisedChatsChildFieldNames.t] = this.t;
    
    return data;
  }

  @override
  int compareTo(OptimisedChatModel other) {
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


class OptimisedChatsChildFieldNames{
  static const String chat_user_id = "chat_user_id";
  static const String username = "username";
  static const String name = "name";
  static const String thumb = "thumb";
  static const String sender_id = "sender_id";
  static const String text = "text";
  static const String msg_type = "msg_type";
  static const String seen = "seen";
  static const String tp = "tp";
  static const String t = "t";
}




