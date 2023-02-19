

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class AdoptionCentersBloc{


  // dog query limits
  int _usersQueryLimit;
  int get getUsersQueryLimit => _usersQueryLimit;
  set setUsersQueryLimit(int usersQueryLimit) {
    _usersQueryLimit = usersQueryLimit;
  }


  // startMap for checkpoint for get users
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of users
  List<UserModel> _usersList;
  List<UserModel> get getUsersList => _usersList;
  set setUsersList(List<UserModel> usersList) {
    _usersList = usersList;
  }

  // has more users to loaded
  bool _hasMoreUsers;
  bool get getHasMoreUsers => _hasMoreUsers;
  set setHasMoreUsers(bool hasMoreUsers) {
    _hasMoreUsers = hasMoreUsers;
  }


  // has loaded users to avoid repetition of users
  // bloc provider implements this
  bool _hasLoadedUsers;
  bool get getHasLoadedUsers => _hasLoadedUsers;
  set setHasLoadedUsers(bool hasLoadedUsers) {
    _hasLoadedUsers = hasLoadedUsers;
  }


  BehaviorSubject<List<UserModel>> usersListBehaviorSubject = BehaviorSubject<List<UserModel>>();
  BehaviorSubject<bool> hasMoreUsersBehaviorSubject = BehaviorSubject<bool>();



  AdoptionCentersBloc(){

    setUsersQueryLimit = 15;

    loadUsers(dogQueryLimit: getUsersQueryLimit);
  }


  void loadUsers({@required int dogQueryLimit, }){

    this.setUsersList = List<UserModel>();
    this.setHasMoreUsers = false;
    setHasLoadedUsers = false;

    hasMoreUsersBehaviorSubject.add(true);


    getAdoptionCenterUserUsersData(
        queryLimit: dogQueryLimit,
        startAfterMap: null
    ).then((usersList){

      this.getUsersList.clear();

      if (usersList.length < dogQueryLimit){

        getUsersList.addAll(usersList);
        usersListBehaviorSubject.add(this.getUsersList);

        this.setHasMoreUsers = false;
        hasMoreUsersBehaviorSubject.add(false);
        return;
      }
      else{


        setQueryStartAfterMap = usersList.last.toJson();

        getUsersList.addAll(usersList);

        usersListBehaviorSubject.add(this.getUsersList);

        this.setHasMoreUsers = true;
        hasMoreUsersBehaviorSubject.add(true);
      }

    });
  }




  Future<void> loadMoreUsers({@required int dogQueryLimit})async{


    hasMoreUsersBehaviorSubject.add(true);

    if (getHasMoreUsers){


      List<UserModel> usersList = await getAdoptionCenterUserUsersData(
          queryLimit: dogQueryLimit,
          startAfterMap: getQueryStartAfterMap
      );


      if (usersList.length < dogQueryLimit){

        getUsersList.addAll(usersList);
        usersListBehaviorSubject.add(this.getUsersList);


        setHasMoreUsers = false;
        hasMoreUsersBehaviorSubject.add(false);
      }
      else{

        setQueryStartAfterMap = usersList.last.toJson();

        getUsersList.addAll(usersList);

        usersListBehaviorSubject.add(this.getUsersList);


        setHasMoreUsers = true;
        hasMoreUsersBehaviorSubject.add(true);
      }


    }
    else{

      hasMoreUsersBehaviorSubject.add(false);
      setHasMoreUsers = false;
    }

  }



  // Gets users from firestore
  static Future<List<UserModel>> getAdoptionCenterUserUsersData({
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;

    if (startAfterMap == null){

      querySnapshot = await Firestore.instance
          .collection(FirestoreCollectionsNames.users)
          .orderBy(UsersDocumentFieldNames.signup_timestamp, descending: true)
          .where(UsersDocumentFieldNames.user_type, isEqualTo: UserType.adoption_center)
          .limit(queryLimit)
          .getDocuments();
    }
    else{

      querySnapshot = await Firestore.instance
          .collection(FirestoreCollectionsNames.users)
          .orderBy(UsersDocumentFieldNames.signup_timestamp, descending: true)
          .where(UsersDocumentFieldNames.user_type, isEqualTo: UserType.adoption_center)
          .limit(queryLimit)
          .startAfter([startAfterMap[UsersDocumentFieldNames.signup_timestamp]])
          .getDocuments();
    }


    List<UserModel> usersList = new List<UserModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> dogMap = querySnapshot.documents[index].data;
        UserModel dogModel = UserModel.fromJson(dogMap);

        dogModel.userId = querySnapshot.documents[index].reference.documentID;

        assert(dogModel.userId != null, "Dog Id from provider is showing null");

        usersList.add(dogModel);

      }

    }


    return usersList;
  }



  void dispose(){

  }
}