

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class TrendingAdoptiblesBloc{


  // dog query limits
  int _dogsQueryLimit;
  int get getDogsQueryLimit => _dogsQueryLimit;
  set setDogsQueryLimit(int dogsQueryLimit) {
    _dogsQueryLimit = dogsQueryLimit;
  }


  // startMap for checkpoint for get dogs
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of dogs
  List<DogModel> _dogsList;
  List<DogModel> get getDogsList => _dogsList;
  set setDogsList(List<DogModel> dogsList) {
    _dogsList = dogsList;
  }

  // has more dogs to loaded
  bool _hasMoreDogs;
  bool get getHasMoreDogs => _hasMoreDogs;
  set setHasMoreDogs(bool hasMoreDogs) {
    _hasMoreDogs = hasMoreDogs;
  }


  // has loaded dogs to avoid repetition of dogs
  // bloc provider implements this
  bool _hasLoadedDogs;
  bool get getHasLoadedDogs => _hasLoadedDogs;
  set setHasLoadedDogs(bool hasLoadedDogs) {
    _hasLoadedDogs = hasLoadedDogs;
  }


  BehaviorSubject<List<DogModel>> dogsListBehaviorSubject = BehaviorSubject<List<DogModel>>();
  BehaviorSubject<bool> hasMoreDogsBehaviorSubject = BehaviorSubject<bool>();


  TrendingAdoptiblesBloc(){

    setDogsQueryLimit = 15;
    loadDogs(dogQueryLimit: getDogsQueryLimit);
  }



  void loadDogs({@required int dogQueryLimit, }){

    this.setDogsList = List<DogModel>();
    this.setHasMoreDogs = false;
    setHasLoadedDogs = false;

    hasMoreDogsBehaviorSubject.add(true);


    getTrendingAdoptiblesDogsData(
        queryLimit: dogQueryLimit,
        startAfterMap: null
    ).then((dogsList){

      this.getDogsList.clear();

      if (dogsList.length < dogQueryLimit){

        getDogsList.addAll(dogsList);
        dogsListBehaviorSubject.add(this.getDogsList);

        this.setHasMoreDogs = false;
        hasMoreDogsBehaviorSubject.add(false);
        return;
      }
      else{


        setQueryStartAfterMap = dogsList.last.toJson();

        getDogsList.addAll(dogsList);

        dogsListBehaviorSubject.add(this.getDogsList);

        this.setHasMoreDogs = true;
        hasMoreDogsBehaviorSubject.add(true);
      }

    });
  }




  Future<void> loadMoreDogs({@required int dogQueryLimit})async{


    hasMoreDogsBehaviorSubject.add(true);

    if (getHasMoreDogs){


      List<DogModel> dogsList = await getTrendingAdoptiblesDogsData(
          queryLimit: dogQueryLimit,
          startAfterMap: getQueryStartAfterMap
      );


      if (dogsList.length < dogQueryLimit){

        getDogsList.addAll(dogsList);
        dogsListBehaviorSubject.add(this.getDogsList);


        setHasMoreDogs = false;
        hasMoreDogsBehaviorSubject.add(false);
      }
      else{

        setQueryStartAfterMap = dogsList.last.toJson();

        getDogsList.addAll(dogsList);

        dogsListBehaviorSubject.add(this.getDogsList);


        setHasMoreDogs = true;
        hasMoreDogsBehaviorSubject.add(true);
      }


    }
    else{

      hasMoreDogsBehaviorSubject.add(false);
      setHasMoreDogs = false;
    }

  }



  // Gets dogs from firestore
  Future<List<DogModel>> getTrendingAdoptiblesDogsData({
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;

    if (startAfterMap == null){

      querySnapshot = await Firestore.instance
          .collectionGroup(FirestoreCollectionsNames.dogs)
          .orderBy(DogsDocumentFieldNames.num_followers, descending: true)
          .where(DogsDocumentFieldNames.adoptible, isEqualTo: true)
          .limit(queryLimit)
          .getDocuments();
    }
    else{

      querySnapshot = await Firestore.instance
          .collection(FirestoreCollectionsNames.dogs)
          .orderBy(DogsDocumentFieldNames.num_followers, descending: true)
          .where(DogsDocumentFieldNames.adoptible, isEqualTo: true)
          .limit(queryLimit)
          .startAfter([startAfterMap[DogsDocumentFieldNames.creation_timestamp]])
          .getDocuments();
    }


    List<DogModel> dogsList = new List<DogModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> dogMap = querySnapshot.documents[index].data;
        DogModel dogModel = DogModel.fromJson(dogMap);

        dogModel.userId = querySnapshot.documents[index].reference.documentID;

        dogModel.ownerUserModel = await getUserModelData(userId: dogModel.ownerUserId);

        assert(dogModel.userId != null, "Dog Id from provider is showing null");

        dogsList.add(dogModel);

      }

    }


    return dogsList;
  }



  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }

  void dispose(){

  }


}