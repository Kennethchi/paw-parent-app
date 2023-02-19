import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';


class ProfileBloc{

  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }

  String _profileUserId;
  String get getProfileUserId => _profileUserId;
  set setProfileUserId(String profileUserId) {
    _profileUserId = profileUserId;
  }



  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }

  UserModel _profileUserModel;
  UserModel get getProfileUserModel => _profileUserModel;
  set setProfileUserModel(UserModel profileUserModel) {
    _profileUserModel = profileUserModel;
  }

  

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


  BehaviorSubject<bool> isListViewBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<UserModel> profileUserModelBehaviorSubject = BehaviorSubject<UserModel>();
  BehaviorSubject<List<DogModel>> dogsListBehaviorSubject = BehaviorSubject<List<DogModel>>();
  BehaviorSubject<bool> hasMoreDogsBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<bool> isProfileUserEqualCurrentUserBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<int> numberOfFollowingsBehaviorSubject = BehaviorSubject<int>();


  ProfileBloc({@required UserModel profileUserModel}){

    isListViewBehaviorSubject.add(false);


    if (profileUserModel != null){

      FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

        if (firebaseUser != null){

          setCurrentUserId = firebaseUser.uid;
          setDogsQueryLimit = 20;



          if (firebaseUser.uid == profileUserModel.userId){

            isProfileUserEqualCurrentUserBehaviorSubject.add(true);

            setProfileUserId = firebaseUser.uid;

            getUserModelData(userId: profileUserModel.userId).then((UserModel profileUserModel){

              setProfileUserModel = profileUserModel;
              setCurrentUserModel = profileUserModel;

              profileUserModelBehaviorSubject.sink.add(getProfileUserModel);
              loadDogs(profileUserId: getProfileUserModel.userId, dogQueryLimit: getDogsQueryLimit);
            });

          }
          else{

            isProfileUserEqualCurrentUserBehaviorSubject.add(false);

            getUserModelData(userId: firebaseUser.uid).then((UserModel userModel){

              getUserModelData(userId: profileUserModel.userId).then((UserModel profileUserModel){
                setProfileUserModel = profileUserModel;

                profileUserModelBehaviorSubject.sink.add(profileUserModel);
                setCurrentUserModel = userModel;

                loadDogs(profileUserId: getProfileUserModel.userId, dogQueryLimit: getDogsQueryLimit);
              });

            });
          }

          getNumberOfFollowings(profileUserId: profileUserModel.userId).then((int numFollowings){
            numberOfFollowingsBehaviorSubject.add(numFollowings);
          });

        }

      });
    }


  }





  void loadDogs({@required String profileUserId,  @required int dogQueryLimit, }){

    this.setDogsList = List<DogModel>();
    this.setHasMoreDogs = false;
    setHasLoadedDogs = false;

    hasMoreDogsBehaviorSubject.add(true);


    getProfileUserDogsData(
        profileUserId: profileUserId,
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




  Future<void> loadMoreDogs({@required profileUserId, @required int dogQueryLimit})async{


    hasMoreDogsBehaviorSubject.add(true);

    if (getHasMoreDogs){


      List<DogModel> dogsList = await getProfileUserDogsData(
          profileUserId: profileUserId,
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
  static Future<List<DogModel>> getProfileUserDogsData({
    @required String profileUserId,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;

    if (startAfterMap == null){

      querySnapshot = await Firestore.instance
          .collection(FirestoreCollectionsNames.users)
          .document(profileUserId)
          .collection(FirestoreCollectionsNames.dogs)
          .orderBy(DogsDocumentFieldNames.creation_timestamp, descending: true)
          .limit(queryLimit)
          .getDocuments();
    }
    else{

      querySnapshot = await Firestore.instance
          .collection(FirestoreCollectionsNames.users)
          .document(profileUserId)
          .collection(FirestoreCollectionsNames.dogs)
          .orderBy(DogsDocumentFieldNames.creation_timestamp, descending: true)
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

        assert(dogModel.userId != null, "Dog Id from provider is showing null");

        dogsList.add(dogModel);

      }

    }


    return dogsList;
  }



  Stream<Event> getNumberOfDogsStreamEvent({@required String profileUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(profileUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.num_dogs)
        .onValue;
  }


  Future<int> getNumberOfDogs({@required String profileUserId}) async{

    return (await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(profileUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.num_dogs)
        .once()).value;
  }


  Future<int> getNumberOfFollowings({@required String profileUserId}) async{

    return (await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(profileUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.num_followings)
        .once()).value;
  }


  void dispose(){

    isListViewBehaviorSubject?.close();
    profileUserModelBehaviorSubject?.close();
    isProfileUserEqualCurrentUserBehaviorSubject?.close();
  }


  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }
}