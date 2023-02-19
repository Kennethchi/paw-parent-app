


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_chat_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class ChatSpaceBloc{



  UserModel _currentUserData;
  UserModel get getCurrentUserData => _currentUserData;
  set setCurrentUserData(UserModel currentUserData) {
    _currentUserData = currentUserData;
  }

  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }


  BehaviorSubject<bool> showChatsBehaviorSubject = BehaviorSubject<bool>();




  ChatSpaceBloc(){

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseCurrentUser){

      if (firebaseCurrentUser != null){

        setCurrentUserId = firebaseCurrentUser.uid;

        getUserModelData(userId: firebaseCurrentUser.uid).then((UserModel userModel){
          setCurrentUserData = userModel;

          showChatsBehaviorSubject.add(true);
        });

        setCurrentUserHasNewMessages(currentUserId: firebaseCurrentUser.uid);
      }

    });

  }




  Future<void> setUpChatsData({@required List<OptimisedChatModel> chatsList})async{


    for (int index = 0; index < chatsList.length; ++index){

      // Its working but still check this
      if (chatsList.length > 1 && index < chatsList.length - 1){
        if (chatsList[index].t == chatsList[index + 1].t){
          continue;
        }
      }

      String chatUserId = chatsList[index].chat_user_id;

      // using current user function to get chat user data
      UserModel chatUserModel = await this.getUserModelData(userId: chatUserId);

      if (chatUserModel == null){
        continue;
      }

      chatsList[index].chatUserModel = chatUserModel;
      chatsList[index].name = chatUserModel.profileName;
      chatsList[index].thumb = chatUserModel.profileImageThumb;
      chatsList[index].username = chatUserModel.username;

    }
  }






  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    if (documentSnapshot.exists){
      return UserModel.fromJson(documentSnapshot.data);
    }

    return null;
  }




  Future<OptimisedChatModel> getChatUserChatData({@required String currentUserId,  @required String chatUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(currentUserId)
        .child(chatUserId)
        .once();

    if (dataSnapshot != null && dataSnapshot.value != null){

      OptimisedChatModel optimisedChatModel = OptimisedChatModel.fromJson(dataSnapshot.value);
      optimisedChatModel.chat_user_id = dataSnapshot.key;

      return optimisedChatModel;
    }

    return null;
  }




  Stream<Event> getChatsDataEvent({@required String currentUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(currentUserId)
        .orderByChild(OptimisedChatsChildFieldNames.t)
        .onValue;

    /*
    if (endAtValue == null){

      return FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.chats)
          .child(currentUserId)
          .orderByChild(OptimisedChatsChildFieldNames.t)
          .limitToLast(queryLimit)
          .onValue;

    }
    else{

      return FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.chats)
          .child(currentUserId)
          .orderByChild(OptimisedChatsChildFieldNames.t)
          .limitToLast(queryLimit)
          .endAt(endAtValue)
          .onValue;
    }
    */

  }


  Future<void> setChatSeen({@required String currentUserId, @required String chatUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(currentUserId)
        .child(chatUserId)
        .child(OptimisedChatsChildFieldNames.seen)
        .set(true);

  }


  Stream<Event> getChatSeenStreamEvent({@required String currentUserId, @required String chatUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.chats)
        .child(chatUserId)
        .child(currentUserId)
        .child(OptimisedChatsChildFieldNames.seen)
        .onValue;
  }



  Stream<Event> getChatUserOnlineStatus({@required String chatUserId}){
    Stream<Event> event = FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users).child(chatUserId).child(RealtimeDatabaseChildNames.user_profile).child(OptimisedUserChiledFieldNames.online).onValue;
    return event;
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



  Future<void> setCurrentUserHasNewMessages({@required String currentUserId})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(currentUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.has_new_messages).set(false);
  }

  @override
  void dispose() {

  }



}