import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class MessageModel{

  String message_id;

  String message_text;
  String message_type;
  String sender_id;
  String receiver_id;
  Timestamp timestamp;
  bool seen;
  Map<dynamic, dynamic> message_data;
  bool downloadable;

  Map<dynamic, dynamic> referred_message;

  String deleteUniqueId;

  MessageModel({
    @required this.message_text,
    @required this.message_type,
    @required this.sender_id,
    @required this.receiver_id,
    @required this.timestamp,
    @required this.seen = false,
    @required this.message_data,
    @required this.downloadable,
    this.referred_message = null,
    @required this.deleteUniqueId
  });


  MessageModel.fromJson(Map<dynamic, dynamic> json){

    this.message_id = json[MessageDocumentFieldName.message_id];
    this.message_text = json[MessageDocumentFieldName.message_text];
    this.message_type = json[MessageDocumentFieldName.message_type];
    this.sender_id = json[MessageDocumentFieldName.sender_id];
    this.receiver_id = json[MessageDocumentFieldName.receiver_id];
    this.timestamp = json[MessageDocumentFieldName.timestamp];
    this.seen = json[MessageDocumentFieldName.seen];
    this.message_data = json[MessageDocumentFieldName.message_data];
    this.downloadable = json[MessageDocumentFieldName.downloadable];
    this.referred_message = json[MessageDocumentFieldName.referred_message];
    this.deleteUniqueId = json[MessageDocumentFieldName.delete_unique_id];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[MessageDocumentFieldName.message_id] = this.message_id;
    data[MessageDocumentFieldName.message_text] = this.message_text;
    data[MessageDocumentFieldName.message_type] = this.message_type;
    data[MessageDocumentFieldName.sender_id] = this.sender_id;
    data[MessageDocumentFieldName.receiver_id] = this.receiver_id;
    data[MessageDocumentFieldName.timestamp] = this.timestamp;
    data[MessageDocumentFieldName.seen] = this.seen;
    data[MessageDocumentFieldName.message_data] = this.message_data;
    data[MessageDocumentFieldName.downloadable] = this.downloadable;
    data[MessageDocumentFieldName.referred_message] = this.referred_message;
    data[MessageDocumentFieldName.delete_unique_id] = this.deleteUniqueId;

    return data;
  }


}


class MessageDocumentFieldName{

  static const String message_id = "message_id";
  static const String message_text = "message_text";
  static const String message_type = "message_type";
  static const String message_data = "message_data";
  static const String sender_id = "sender_id";
  static const String receiver_id = "receiver_id";
  static const String timestamp = "timestamp";
  static const String seen = "seen";
  static const String downloadable = "downloadable";
  static const String referred_message = "referred_message";
  static const String delete_unique_id = "delete_unique_id";
}


