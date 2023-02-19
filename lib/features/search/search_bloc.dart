


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc{

  SEARCH_TYPE _search_type;
  SEARCH_TYPE get get_search_type => _search_type;
  set set_search_type(SEARCH_TYPE search_type) {
    _search_type = search_type;
  }

  BehaviorSubject<SEARCH_TYPE> searchTypeBehaviorSubject = BehaviorSubject<SEARCH_TYPE>();
  BehaviorSubject<String> searchTextBehaviorSubject = BehaviorSubject<String>();
  BehaviorSubject<bool> isSearchingBehaviorSunject = BehaviorSubject<bool>();
  BehaviorSubject<UserModel> searchUserModelBehaviorSubject = BehaviorSubject<UserModel>();
  BehaviorSubject<DogModel> searchDogModelBehaviorSubject = BehaviorSubject<DogModel>();


  SearchBloc(){

    searchTypeBehaviorSubject.listen((SEARCH_TYPE search_type) {
      set_search_type = search_type;
    });

    searchTypeBehaviorSubject.add(SEARCH_TYPE.DOG_USERNAME);
    isSearchingBehaviorSunject.add(false);
  }



  Future<UserModel> getSearchUser({@required String searchUserUsername})async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(FirestoreCollectionsNames.users)
        .where(UsersDocumentFieldNames.username, isEqualTo: searchUserUsername.toLowerCase(),)
        .limit(1)
        .getDocuments();

    if (querySnapshot.documents.isEmpty){
      return null;
    }
    else{
      return UserModel.fromJson(querySnapshot.documents[0].data);
    }

  }

  Future<DogModel> getSearchDog({@required String searchDogUsername})async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collectionGroup(FirestoreCollectionsNames.dogs)
        .where(DogsDocumentFieldNames.username, isEqualTo: searchDogUsername.toLowerCase(),)
        .limit(1)
        .getDocuments();

    if (querySnapshot.documents.isEmpty){
      return null;
    }
    else{

      DogModel dogModel = DogModel.fromJson(querySnapshot.documents[0].data);
      dogModel.ownerUserModel = await getUserModelData(userId: dogModel.ownerUserId);
      return dogModel;
    }

  }



  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }


  void dispose(){

  }

}