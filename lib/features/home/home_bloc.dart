import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';


class HomeBloc{


  bool _userConnectivity;
  bool get getUserConnectivity => _userConnectivity;
  set _setUserConnectivity(bool userConnectivity) {
    _userConnectivity = userConnectivity;
  }


  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }



  BehaviorSubject<int> bottomNavIndexBehaviorSubject = BehaviorSubject<int>();
  BehaviorSubject<UserModel> currentuserUserModelBehaviorSubject = BehaviorSubject<UserModel>();


  // Connectivity stream
  Stream<ConnectivityResult> get getConnectivityResultStream => Connectivity().onConnectivityChanged;
  StreamSubscription<ConnectivityResult>  _getConnectivityResultStreamSubscription;

  BehaviorSubject<bool> hasInternetConnectionBehaviorSubject = BehaviorSubject<bool>();

  StreamSubscription<DataConnectionStatus> _hasInternetConnectionStreamSubscription;



  HomeBloc(){

    bottomNavIndexBehaviorSubject.add(0);

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){

        setCurrentUserId = firebaseUser.uid;

        getUserModelData(userId: firebaseUser.uid).then((UserModel currentUserModel){
          currentuserUserModelBehaviorSubject.add(currentUserModel);
        });


        setCurrentUserOnlineStatus(currentUserId: firebaseUser.uid, onlineStatus: 1);

        setCurrentUserOnlineStatus(currentUserId: firebaseUser.uid, onlineStatus: Timestamp.now().millisecondsSinceEpoch, executeOnDisconnect: true);

        _getConnectivityResultStreamSubscription = getConnectivityResultStream.listen((ConnectivityResult connectivityResult){


          switch(connectivityResult){


            case ConnectivityResult.mobile:
              _setUserConnectivity = true;
              setCurrentUserOnlineStatus(currentUserId: firebaseUser.uid, onlineStatus: 1);
              setCurrentUserOnlineStatus(currentUserId: firebaseUser.uid, onlineStatus: Timestamp.now().millisecondsSinceEpoch, executeOnDisconnect: true);

              print("Conectivity State: Mobile");

              break;

            case ConnectivityResult.wifi:
              _setUserConnectivity = true;
              setCurrentUserOnlineStatus(currentUserId: firebaseUser.uid, onlineStatus: 1);
              setCurrentUserOnlineStatus(currentUserId: firebaseUser.uid, onlineStatus: Timestamp.now().millisecondsSinceEpoch, executeOnDisconnect: true);
              print("Conectivity State: Wifi");
              break;

            case ConnectivityResult.none:
              _setUserConnectivity = false;
              setCurrentUserOnlineStatus(currentUserId: firebaseUser.uid, onlineStatus: Timestamp.now().millisecondsSinceEpoch, executeOnDisconnect: true);
              print("Conectivity State: None");

              hasInternetConnectionBehaviorSubject.add(false);
              break;
          }
        });


        _hasInternetConnectionStreamSubscription = DataConnectionChecker()?.onStatusChange.listen((DataConnectionStatus status){


          switch (status) {
            case DataConnectionStatus.connected:
              print("Data Connection State: CONNECTED");
              hasInternetConnectionBehaviorSubject.add(true);

              setCurrentUserOnlineStatus(
                  currentUserId: firebaseUser.uid, onlineStatus: 1);
              setCurrentUserOnlineStatus(
                  currentUserId: firebaseUser.uid, onlineStatus: Timestamp
                  .now()
                  .millisecondsSinceEpoch, executeOnDisconnect: true);

              break;

            case DataConnectionStatus.disconnected:
              print("Data Connection state: DISCONNECTED");
              hasInternetConnectionBehaviorSubject.add(false);


              setCurrentUserOnlineStatus(
                  currentUserId: firebaseUser.uid,
                  onlineStatus: Timestamp.now().millisecondsSinceEpoch
              );
              break;
          }

        });



      }

    });

  }


  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }



  // Gets dogs from firestore
  Future<List<DogModel>> getCurrentUserDogsData({
    @required String currentUserId,
  })async{


    QuerySnapshot querySnapshot = await Firestore.instance
          .collection(FirestoreCollectionsNames.users)
          .document(currentUserId)
          .collection(FirestoreCollectionsNames.dogs)
          .orderBy(DogsDocumentFieldNames.creation_timestamp, descending: true)
          .getDocuments();


    List<DogModel> dogsList = new List<DogModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> dogMap = querySnapshot.documents[index].data;
        DogModel dogModel = DogModel.fromJson(dogMap);

        dogModel.userId = querySnapshot.documents[index].reference.documentID;

        assert(dogModel.userId != null, "Dog Id from provider is showing null");

        dogsList.add(dogModel);
      }

    }

    return dogsList;
  }



  static Future<void> setCurrentUserOnlineStatus({@required String currentUserId, @required int onlineStatus, bool executeOnDisconnect = false})async{


    if (executeOnDisconnect == null || executeOnDisconnect == false){
      await FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.users)
          .child(currentUserId).child(RealtimeDatabaseChildNames.user_profile)
          .child(OptimisedUserChiledFieldNames.online)
          .set(onlineStatus);

      return;
    }

    else if (executeOnDisconnect){
      await FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.users)
          .child(currentUserId)
          .child(RealtimeDatabaseChildNames.user_profile)
          .child(OptimisedUserChiledFieldNames.online)
          .onDisconnect()
          .set(onlineStatus);

      return;
    }

  }




  void dispose(){
    bottomNavIndexBehaviorSubject?.close();
  }

}