import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';


class AuthenticationBloc{

  String _userType;
  String get getUserType => _userType;
  set setUserType(String userType) {
    _userType = userType;
  }

  BehaviorSubject<bool> isLoginViewBehaviorSubject = BehaviorSubject<bool>();

  BehaviorSubject<bool> isTermsAndPolicyAcceptedBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<String> userTypeBehaviorSubject = BehaviorSubject<String>();

  BehaviorSubject<bool> showSignInPasswordBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<bool> showRegisterationPasswordBehaviorSubject = BehaviorSubject<bool>();

  AuthenticationBloc(){

    userTypeBehaviorSubject.stream.listen((String userType) {
      setUserType = userType;
    });

    userTypeBehaviorSubject.sink.add(UserType.pet_owner);

    showSignInPasswordBehaviorSubject.add(false);
    showRegisterationPasswordBehaviorSubject.add(false);
  }


  Future<void> addUserProfileData({UserModel userModel, String userId}) async{

    await Firestore.instance.collection("users").document(userId).setData(userModel.toJson());
  }

  Future<void> addUserOptimisedProfileData({@required String userId, @required OptimisedUserModel optimisedUserModel})async{
    await FirebaseDatabase.instance.reference().child(RealtimeDatabaseChildNames.users).child(userId).child(RealtimeDatabaseChildNames.user_profile).set(optimisedUserModel.toJson());
  }

  Future<bool> checkIfUserDataExists({@required String userId})async{

    QuerySnapshot querySnapshot = await Firestore.instance.collection("users").where(UsersDocumentFieldNames.user_id, isEqualTo: userId).limit(1).getDocuments();
    if (querySnapshot.documents.isEmpty){
      return false;
    }
    else{
      return true;
    }
  }


  Future<UserModel> getSignedInUserData({@required String email})async{

    QuerySnapshot querySnapshot =  await Firestore.instance.collection("users").where(UsersDocumentFieldNames.email, isEqualTo: email).limit(1).getDocuments();
    if (querySnapshot.documents != null){
      for (int i = 0; i < querySnapshot.documents.length; ++i){
        DocumentSnapshot documentSnapshot = querySnapshot.documents[i];
        if (documentSnapshot != null && documentSnapshot.exists){
          return UserModel.fromJson(documentSnapshot.data);
        }
        else{
          return null;
        }
      }
    }else{
      return null;
    }
  }

  Future<AuthResult> signInUserWithEmailAndPassword({@required String email, @required String password})async{

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }


  Future<AuthResult> createUserWithEmailAndPassword({@required String email, @required String password})async{

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }


  Future<bool> checkIfUsernameExists({@required String username})async{

    QuerySnapshot querySnapshot = await Firestore.instance.collection("users").where("username", isEqualTo: username).limit(1).getDocuments();
    if (querySnapshot.documents != null && querySnapshot.documents.length > 0){
      return true;
    }
    else{
      return false;
    }
  }


  void dispose(){

    isLoginViewBehaviorSubject?.close();
    userTypeBehaviorSubject?.close();
  }
}