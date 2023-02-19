


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/message_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_chat_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_message_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';
import 'chat_room_validators.dart';

class ChatRoomBloc{




  static final DURATION_BEFORE_SET_MESSAGE_AS_SEEN = Duration(seconds: 1);


  // percent ratio progress stream
  BehaviorSubject<double> _percentRatioProgressBehaviorSubject = BehaviorSubject<double>();
  Stream<double> get getPercentRatioProgressStream => _percentRatioProgressBehaviorSubject.stream;
  Sink<double> get _getPercentRatioProgressSink => _percentRatioProgressBehaviorSubject.sink;

  void addPercentRatioProgress(double percentRatioProgress){
    _getPercentRatioProgressSink.add(percentRatioProgress);
  }

  // Stream subscription for observing latest combination of ongoing progress transfer and total transfer
  StreamSubscription<double> _observeCombineLatestProgressAndTotalTransfer;




  // current User model
  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }

  UserModel _chatUserModel;
  UserModel get getChatUserModel => _chatUserModel;
  set setChatUserModel(UserModel chatUserModel) {
    _chatUserModel = chatUserModel;
  }



  // message query limits
  int _messagesQueryLimit;
  int get getMessagesQueryLimit => _messagesQueryLimit;
  set setMessagesQueryLimit(int messagesQueryLimit) {
    _messagesQueryLimit = messagesQueryLimit;
  }


  // startMap for checkpoint for get messages
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of messages
  List<MessageModel> _messagesList;
  List<MessageModel> get getMessagesList => _messagesList;
  set setMessagesList(List<MessageModel> messagesList) {
    _messagesList = messagesList;
  }

  // has more messages to loaded
  bool _hasMoreMessages;
  bool get getHasMoreMessages => _hasMoreMessages;
  set setHasMoreMessages(bool hasMoreMessages) {
    _hasMoreMessages = hasMoreMessages;
  }


  // has loaded messages to avoid repetition of messages
  // bloc provider implements this
  bool _hasLoadedMessages;
  bool get getHasLoadedMessages => _hasLoadedMessages;
  set setHasLoadedMessages(bool hasLoadedMessages) {
    _hasLoadedMessages = hasLoadedMessages;
  }


  MessageModel _referredMessageModel;
  MessageModel get getReferredMessageModel => _referredMessageModel;
  set setReferredMessageModel(MessageModel referredMessageModel) {
    _referredMessageModel = referredMessageModel;
  }

  // stream messageList
  BehaviorSubject<List<MessageModel>> _messagesListBehaviorSubject = BehaviorSubject<List<MessageModel>>();
  Stream<List<MessageModel>> get getMessagesListStream => _messagesListBehaviorSubject.stream;
  StreamSink<List<MessageModel>> get _getMessagesListSink => _messagesListBehaviorSubject.sink;

  StreamSubscription<QuerySnapshot> getLoadMessagesListQuerySnapshotStreamSubscription;
  StreamSubscription<QuerySnapshot> getLoadMoreMessagesListQuerySnapshotStreamSubscription;



  // stream has more messages
  BehaviorSubject<bool> _hasMoreMessagesBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMoreMessagesStream => _hasMoreMessagesBehaviorSubject.stream;
  StreamSink<bool> get _getHasMoreMessagesSink => _hasMoreMessagesBehaviorSubject.sink;




  // streaming chat user online status from realtime database
  BehaviorSubject<Event> _chatUserOnlineStatusEventBehaviorSubject = BehaviorSubject<Event>();
  Stream<Event> get getChatUserOnlineStatusEventStream => _chatUserOnlineStatusEventBehaviorSubject.stream;
  StreamSink<Event> get _getChatUserOnlineStatusEventSink => _chatUserOnlineStatusEventBehaviorSubject.sink;
  StreamSubscription<Event> _chatUserOnlineStatusEventStreamSubscription;


  // streaming current user online status from realtime database
  BehaviorSubject<Event> _currentUserOnlineStatusEventBehaviorSubject = BehaviorSubject<Event>();
  Stream<Event> get getCurrentUserOnlineStatusEventStream => _currentUserOnlineStatusEventBehaviorSubject.stream;
  StreamSink<Event> get _getCurrentUserOnlineStatusEventSink => _currentUserOnlineStatusEventBehaviorSubject.sink;
  StreamSubscription<Event> _currentUserOnlineStatusEventStreamSubscription;




  // streaming chat user typing status from realtime database
  BehaviorSubject<Event> _chatUserTypingStatusEventBehaviorSubject = BehaviorSubject<Event>();
  Stream<Event> get getChatUserTypingStatusEventStream => _chatUserTypingStatusEventBehaviorSubject.stream;
  StreamSink<Event> get _getChatUserTypingStatusEventSink => _chatUserTypingStatusEventBehaviorSubject.sink;
  StreamSubscription<Event> _chatUserTypingStatusEventStreamSubscription;




  // message Text Stream Controller
  BehaviorSubject<String> _textBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getTextStream => _textBehaviorSubject.stream.transform(ChatRoomValidators.textValidator);
  StreamSink<String> get _getTextSink => _textBehaviorSubject.sink;



  // Is Media Uploading stream
  BehaviorSubject<bool> _isMediaUploadingBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsMediaUploadingStream => _isMediaUploadingBehaviorSubject.stream;
  Sink<bool> get _getIsMediaUploadSink => _isMediaUploadingBehaviorSubject.sink;

  // Referred Message Model stream
  BehaviorSubject<MessageModel> _referredMessageModelBehaviorSubject = BehaviorSubject<MessageModel>();
  Stream<MessageModel> get getReferredMessageModelStream => _referredMessageModelBehaviorSubject.stream;
  Sink<MessageModel> get _getReferredMessageModelSink => _referredMessageModelBehaviorSubject.sink;



  ChatRoomBloc({@required UserModel chatUserModel, @required UserModel currentUserModel}){

    // setting chat user model and current user model data
    setChatUserModel = chatUserModel;
    setCurrentUserModel = currentUserModel;

    //listen to chat user online state
    _chatUserOnlineStatusEventStreamSubscription = getChatUserOnlineStatus(chatUserId: chatUserModel.userId).listen((Event event){
      addChatUserOnlineStatusToStream(event: event);
    });

    //listen to current user online state
    _currentUserOnlineStatusEventStreamSubscription = getChatUserOnlineStatus(chatUserId: currentUserModel.userId).listen((Event event){
      addCurrentUserOnlineStatusToStream(event: event);
    });

    //listen to chat user typing state
    _chatUserTypingStatusEventStreamSubscription = getChatUserTypingStatus(currentUserId: currentUserModel.userId, chatUserId: chatUserModel.userId).listen((Event event){
      addChatUserTypingStatusToStream(event: event);
    });

    // sets user is typing to false_0 and other features to false_0 in relation to the private chat
    onCurrentUserDisconnect(currentUserId: currentUserModel.userId, chatUserId: chatUserModel.userId);



    //this.updateChattersMessagesSeenField(currentUserId: currentUserModel.userId, chatUserId: chatUserModel.userId);

    setMessagesQueryLimit = 20;
    setHasMoreMessages = true;;
    setHasLoadedMessages = false;

    loadMessages(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId, messageQueryLimit: this.getMessagesQueryLimit);

    //setMessageSeen(messageId: null, currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId,);

  }




  Future<void> loadMessages({@required String currentUserId, @required String chatUserId, @required int messageQueryLimit, })async{

    // Sets the messages loaded as seen
    this.setMessagesSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);


    this.setHasMoreMessages = true;
    addHasMoreMessagesToStream(true);

    this.setMessagesList = List<MessageModel>();


    getLoadMessagesListQuerySnapshotStreamSubscription = getMessagesDataEvent(
        currentUserId: currentUserId,
        chatUserId: chatUserId,
        queryLimit: messageQueryLimit,
        startAfterMap: null
    ).listen((QuerySnapshot querySnapshot){

      this.setMessagesList = List<MessageModel>();
      List<MessageModel> messagesList = new List<MessageModel>();

      if(querySnapshot.documents != null){

        for (int index = 0; index < querySnapshot.documents.length; ++index){

          Map<String, dynamic> messageMap = querySnapshot.documents[index].data;
          MessageModel messageModel = MessageModel.fromJson(messageMap);
          messageModel.message_id = querySnapshot.documents[index].reference.documentID;

          assert(messageModel.message_id != null, "Message Id from querySnapshot is null");

          messagesList.add(messageModel);

          Timer(DURATION_BEFORE_SET_MESSAGE_AS_SEEN, (){
            if(this.getCurrentUserModel.userId != messageModel.sender_id){
              this.setSingleMessageSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);
            }
          });

          if (messageModel.seen == false && messageModel.sender_id == this.getChatUserModel.userId){
            // Set also sets chatuser  seen field to true
            this.setChatSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);
          }
        }
      }



      this.getMessagesList.clear();


      if (messagesList.length < messageQueryLimit){

        getMessagesList.addAll(messagesList);

        addMessagesListToStream(this.getMessagesList);

        addHasMoreMessagesToStream(false);
        this.setHasMoreMessages = false;
        return;
      }
      else{

        this.setQueryStartAfterMap = messagesList.last.toJson();

        getMessagesList.addAll(messagesList);

        addMessagesListToStream(this.getMessagesList);

        addHasMoreMessagesToStream(true);
        this.setHasMoreMessages = true;
      }

    });
  }




  Future<void> loadMoreMessages({@required String currentUserId, @required String chatUserId, @required int messageQueryLimit,})async{

    // Sets the more messages loaded as seen
    this.setMessagesSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);


    setHasMoreMessages = true;
    addHasMoreMessagesToStream(true);


    if (getHasMoreMessages){


      getLoadMoreMessagesListQuerySnapshotStreamSubscription = getMessagesDataEvent(
          currentUserId: currentUserId,
          chatUserId: chatUserId,
          queryLimit: messageQueryLimit,
          startAfterMap: this.getQueryStartAfterMap
      ).listen((QuerySnapshot querySnapshot){



        List<MessageModel> messagesList = new List<MessageModel>();

        if(querySnapshot.documents != null){

          for (int index = 0; index < querySnapshot.documents.length; ++index){

            Map<String, dynamic> messageMap = querySnapshot.documents[index].data;
            MessageModel messageModel = MessageModel.fromJson(messageMap);

            messageModel.message_id = querySnapshot.documents[index].reference.documentID;

            assert(messageModel.message_id != null, "Message Id from querySnapshot is null");

            messagesList.add(messageModel);

            Timer(DURATION_BEFORE_SET_MESSAGE_AS_SEEN, (){
              if(this.getCurrentUserModel.userId != messageModel.sender_id){
                this.setSingleMessageSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);
              }
            });

            if (messageModel.seen == false && messageModel.sender_id == this.getChatUserModel.userId){
              // Set also sets chatuser  seen field to true
              this.setChatSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);
            }
          }

        }


        if (messagesList.length < messageQueryLimit){

          getMessagesList.addAll(messagesList);

          addMessagesListToStream(this.getMessagesList);

          setHasMoreMessages = false;
          addHasMoreMessagesToStream(false);
        }
        else{

          setQueryStartAfterMap = messagesList.last.toJson();

          getMessagesList.addAll(messagesList);

          addMessagesListToStream(this.getMessagesList);

          setHasMoreMessages = true;
          addHasMoreMessagesToStream(true);
        }

      });

    }
    else{
      addHasMoreMessagesToStream(false);
      setHasMoreMessages = false;
    }

  }



  void addReferredMessageModelToStream(MessageModel referredMessageModel){
    setReferredMessageModel = referredMessageModel;
    _getReferredMessageModelSink.add(referredMessageModel);
  }

  void addIsMediaUploadingToStream(bool isMediaUploading){
    _getIsMediaUploadSink.add(isMediaUploading);
  }

  void addHasMoreMessagesToStream(bool hasMoreMessages){

    this.setHasMoreMessages = hasMoreMessages;
    _getHasMoreMessagesSink.add(hasMoreMessages);
  }

  void addMessagesListToStream(List<MessageModel> messagesList)async{

    // Sets the more messages loaded as seen
    this.setMessagesSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);

    _getMessagesListSink.add(messagesList);
  }




  void addChatUserOnlineStatusToStream({@required Event event}){
    _getChatUserOnlineStatusEventSink.add(event);
  }

  void addCurrentUserOnlineStatusToStream({@required Event event}){
    _getCurrentUserOnlineStatusEventSink.add(event);
  }

  void addChatUserTypingStatusToStream({@required Event event}){
    _getChatUserTypingStatusEventSink.add(event);
  }

  void addTextToStream({@required text}){
    _getTextSink.add(text);
  }






  Future<String>  addMessageData({@required MessageModel messageModel, @required String currentUserId, @required String chatUserId})async{

    DocumentReference currentUserMessageRef = Firestore
        .instance.collection(FirestoreCollectionsNames.users)
        .document(currentUserId)
        .collection(FirestoreCollectionsNames.chats)
        .document(chatUserId)
        .collection(FirestoreCollectionsNames.messages)
        .document();

    DocumentReference chatUserMessageRef = Firestore
        .instance.collection(FirestoreCollectionsNames.users)
        .document(chatUserId)
        .collection(FirestoreCollectionsNames.chats)
        .document(currentUserId)
        .collection(FirestoreCollectionsNames.messages)
        .document();

    WriteBatch batch = Firestore.instance.batch();

    batch.setData(currentUserMessageRef, messageModel.toJson());
    batch.setData(chatUserMessageRef, messageModel.toJson());

    await batch.commit();

    return currentUserMessageRef.documentID;
  }



  Future<void>  removeMessageData({@required String messageId, @required String currentUserId, @required String chatUserId})async{

    await Firestore.instance
        .collection(FirestoreCollectionsNames.users)
        .document(currentUserId)
        .collection(FirestoreCollectionsNames.chats)
        .document(chatUserId)
        .collection(FirestoreCollectionsNames.messages)
        .document(messageId)
        .delete();
  }


  Stream<QuerySnapshot> getMessagesDataEvent({
    @required String currentUserId, @required String chatUserId,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap}) {

    if (startAfterMap == null){
      return Firestore
          .instance.collection(FirestoreCollectionsNames.users)
          .document(currentUserId)
          .collection(FirestoreCollectionsNames.chats)
          .document(chatUserId)
          .collection(FirestoreCollectionsNames.messages)
          .orderBy(MessageDocumentFieldName.timestamp, descending: true)
          .limit(queryLimit)
          .snapshots();
    }
    else{
      return Firestore
          .instance.collection(FirestoreCollectionsNames.users)
          .document(currentUserId)
          .collection(FirestoreCollectionsNames.chats)
          .document(chatUserId)
          .collection(FirestoreCollectionsNames.messages)
          .orderBy(MessageDocumentFieldName.timestamp, descending: true)
          .limit(queryLimit)
          .startAfter([startAfterMap[MessageDocumentFieldName.timestamp]])
          .snapshots();
    }
  }


  Future<void> updateChattersMessagesSeenField({@required String currentUserId, @required String chatUserId}) async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(FirestoreCollectionsNames.users)
        .document(chatUserId)
        .collection(FirestoreCollectionsNames.chats)
        .document(currentUserId)
        .collection(FirestoreCollectionsNames.messages)
        .where(MessageDocumentFieldName.seen, isEqualTo: false)
        .where(MessageDocumentFieldName.sender_id, isEqualTo: chatUserId)
        .limit(AppDataLimits.maxNumberOfMessagesToLoad)
        .getDocuments();

    WriteBatch writeBatch = Firestore.instance.batch();

    if (querySnapshot.documents != null){

      for (int i = 0; i < querySnapshot.documents.length; ++i){

        if (querySnapshot.documents[i].data[MessageDocumentFieldName.seen] == false){
          querySnapshot.documents[i].reference.updateData({MessageDocumentFieldName.seen: true});
        }
      }
    }
  }



  Future<void> updateChattersSingleMessageSeenField({@required String currentUserId, @required String chatUserId, @required messageId}) async{

    Map<String, dynamic> updateDataMap = {MessageDocumentFieldName.seen: true};

    DocumentReference documentReference = Firestore.instance
        .collection(FirestoreCollectionsNames.users)
        .document(chatUserId)
        .collection(FirestoreCollectionsNames.chats)
        .document(currentUserId)
        .collection(FirestoreCollectionsNames.messages)
        .document(messageId);

    await documentReference.updateData(updateDataMap);
  }



  Stream<Event> getChatUserOnlineStatus({@required String chatUserId }){
    Stream<Event> event = FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users).child(chatUserId).child(RealtimeDatabaseChildNames.user_profile).child(OptimisedUserChiledFieldNames.online).onValue;
    return event;
  }

  Future<void> addCurrentUserTypingStatus({@required String currentUserId, @required chatUserId, @required bool isTyping}) async{
    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(chatUserId)
        .child(currentUserId)
        .child(OptimisedChatsChildFieldNames.tp)
        .set(isTyping);
  }



  Stream<Event> getChatUserTypingStatus({@required currentUserId, @required String chatUserId}){

    Stream<Event> event =  FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(currentUserId)
        .child(chatUserId)
        .child(OptimisedChatsChildFieldNames.tp)
        .onValue;

    return event;
  }



  Future<void> onCurrentUserDisconnect({@required String currentUserId, @required String chatUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(chatUserId)
        .child(currentUserId)
        .child(OptimisedChatsChildFieldNames.tp)
        .onDisconnect()
        .set(false);
  }



  Future<void> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel})async{

    FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(currentUserChatterModel.chat_user_id)
        .child(chatUserChatterModel.chat_user_id)
        .set(chatUserChatterModel.toJson());

    FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(chatUserChatterModel.chat_user_id)
        .child(currentUserChatterModel.chat_user_id)
        .set(currentUserChatterModel.toJson());

  }







  /*
  static Future<void> addNotificationData({@required OptimisedNotificationModel optimisedNotificationModel, @required String chatUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.message_notifications)
        .child(chatUserId)
        .push()
        .set(optimisedNotificationModel.toJson());
  }
   */


  Future<void> setChatSeen({@required String currentUserId, @required String chatUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(currentUserId)
        .child(chatUserId)
        .child(OptimisedChatsChildFieldNames.seen)
        .set(true);
  }


  Future<void> setCurrentUserSentMessageState({@required String messageState, @required String messageId, @required String currentUserId, @required String chatUserId})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.messages)
        .child(currentUserId)
        .child(chatUserId)
        .child(messageId)
        .child(OptimisedMessagesChildFieldNames.msg_state)
        .set(messageState);
  }


  Future<void> removeCurrentUserSentMessageState({@required String messageId, @required String currentUserId, @required String chatUserId})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.messages)
        .child(currentUserId)
        .child(chatUserId)
        .child(messageId)
        .remove();
  }



  Stream<Event> getCurrentUserSentMessageStateEvent({@required String messageId, @required String currentUserId, @required String chatUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.messages)
        .child(currentUserId)
        .child(chatUserId)
        .child(messageId)
        .child(OptimisedMessagesChildFieldNames.msg_state)
        .onValue;
  }



  Future<String> getMessageState({@required String messageId, @required String currentUserId, @required String chatUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.messages)
        .child(chatUserId)
        .child(currentUserId)
        .child(messageId)
        .child(OptimisedMessagesChildFieldNames.msg_state)
        .once();

    return dataSnapshot.value;
  }


  Future<void> setMessagesSeen({@required String currentUserId, @required String chatUserId})async{


    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.messages)
        .child(chatUserId)
        .child(currentUserId)
        .keepSynced(true);


    DataSnapshot dataSnapshots = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.messages)
        .child(chatUserId)
        .child(currentUserId)
        .orderByChild(OptimisedMessagesChildFieldNames.msg_state)
        .equalTo(MessageState.sent)
        .limitToLast(20)
        .once();

    if (dataSnapshots.value != null){
      Map<dynamic, dynamic> dataMap = dataSnapshots.value;

      List<dynamic> messageIdList = dataMap.keys.toList();
      messageIdList.sort();
      messageIdList.reversed;

      for (int index = 0; index < messageIdList.length; ++index){

        FirebaseDatabase.instance.reference()
            .child(RealtimeDatabaseChildNames.messages)
            .child(chatUserId)
            .child(currentUserId)
            .child(messageIdList[index])
            .child(OptimisedMessagesChildFieldNames.msg_state)
            .set(MessageState.seen);
      }
    }

  }



  Future<void> setSingleMessageSeen({@required String currentUserId, @required String chatUserId})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.messages)
        .child(chatUserId)
        .child(currentUserId)
        .keepSynced(true);

    DataSnapshot dataSnapshots = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.messages)
        .child(chatUserId)
        .child(currentUserId)
        .orderByChild(OptimisedMessagesChildFieldNames.msg_state)
        .equalTo(MessageState.sent)
        .limitToLast(3)
        .once();

    if (dataSnapshots.value != null){
      Map<dynamic, dynamic> dataMap = dataSnapshots.value;

      List<dynamic> messageIdList = dataMap.keys.toList();
      messageIdList.sort();
      messageIdList.reversed;

      for (int index = 0; index < messageIdList.length; ++index){

        FirebaseDatabase.instance.reference()
            .child(RealtimeDatabaseChildNames.messages)
            .child(chatUserId)
            .child(currentUserId)
            .child(messageIdList[index])
            .child(OptimisedMessagesChildFieldNames.msg_state)
            .set(MessageState.seen);
      }
    }
  }

  Future<void> setChatUserHasNewMessages({@required String chatUserId})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(chatUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.has_new_messages).set(true);
  }

  void dispose(){

  }

}