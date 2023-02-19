



import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:paw_parent_app/services/server_api.dart';
import 'package:rxdart/rxdart.dart';

class ProfileSettingsBloc {

  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }



  File _profileImageFile;
  File get getProfileImageFile => _profileImageFile;
  set setProfileImageFile(File profileImageFile) {
    _profileImageFile = profileImageFile;
  }


  BehaviorSubject<File> profileImageFileBehaviorSubject = BehaviorSubject<File>();
  BehaviorSubject<UserModel> currentUserModelBehaviorSubject = BehaviorSubject<UserModel>();
  BehaviorSubject<bool> showUpdateProfileNameButtonBehaviorSubject = BehaviorSubject<bool>();


  ProfileSettingsBloc(){

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){
      if (firebaseUser != null){
        getUserModelData(userId: firebaseUser.uid).then((UserModel userModel){
          currentUserModelBehaviorSubject.add(userModel);
        });
      }
    });


    currentUserModelBehaviorSubject.listen((UserModel currentUserModel) {
      setCurrentUserModel = currentUserModel;
    });

  }


  Future<void> updateUserModelProfileData({@required String userId, @required Map<String, dynamic> dataMap}) async{

    await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).updateData(dataMap);
  }


  Future<void> updateUserOptimisedUserModelProfileData({@required String userId, @required Map<String, dynamic> dataMap})async{
    await FirebaseDatabase.instance.reference().child(RealtimeDatabaseChildNames.users).child(userId).child(RealtimeDatabaseChildNames.user_profile).update(dataMap);
  }



  Future<String> uploadFileToCloudStorage({@required String currentUserId, @required File file, @required String filename})async{

    return await ServerApi.uploadFileToCloudStorage(file: file, filename: filename, storagePath: "${FirebaseStorageChildNames.users}/${currentUserId}" );
  }



  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }

  void dispose(){
    profileImageFileBehaviorSubject?.close();
  }

}