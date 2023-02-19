


import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class DogPostsBloc{


  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }

  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }

  List<String> _currentUserDogsFollowingList;
  List<String> get getCurrentUserDogsFollowingList => _currentUserDogsFollowingList;
  set setCurrentUserDogsFollowingList(List<String> currentUserDogsFollowingList) {
    _currentUserDogsFollowingList = currentUserDogsFollowingList;
  }


  // dog query limits
  int _postsQueryLimit;
  int get getPostsQueryLimit => _postsQueryLimit;
  set setPostsQueryLimit(int postsQueryLimit) {
    _postsQueryLimit = postsQueryLimit;
  }


  // startMap for checkpoint for get posts
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of posts
  List<DogPostModel> _postsList;
  List<DogPostModel> get getPostsList => _postsList;
  set setPostsList(List<DogPostModel> postsList) {
    _postsList = postsList;
  }

  // has more posts to loaded
  bool _hasMorePosts;
  bool get getHasMorePosts => _hasMorePosts;
  set setHasMorePosts(bool hasMorePosts) {
    _hasMorePosts = hasMorePosts;
  }


  DOG_POST_QUERY_TYPE _dog_post_query_type;
  DOG_POST_QUERY_TYPE get get_dog_post_query_type => _dog_post_query_type;
  set set_dog_post_query_type(DOG_POST_QUERY_TYPE dog_post_query_type) {
    _dog_post_query_type = dog_post_query_type;
  }


  // has loaded posts to avoid repetition of posts
  // bloc provider implements this
  bool _hasLoadedPosts;
  bool get getHasLoadedPosts => _hasLoadedPosts;
  set setHasLoadedPosts(bool hasLoadedPosts) {
    _hasLoadedPosts = hasLoadedPosts;
  }



  BehaviorSubject<List<DogPostModel>> postsListBehaviorSubject = BehaviorSubject<List<DogPostModel>>();
  BehaviorSubject<bool> hasMorePostsBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<DOG_POST_QUERY_TYPE> dogPostQueryTypeBehaviorSubject = BehaviorSubject<DOG_POST_QUERY_TYPE>();


  DogPostsBloc(){

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){
        setCurrentUserId = firebaseUser.uid;
        setPostsQueryLimit = 10;

        int queryLimitForFirstPostsLoad = 3;

        dogPostQueryTypeBehaviorSubject.add(DOG_POST_QUERY_TYPE.FOLLOWING);

        dogPostQueryTypeBehaviorSubject.listen((DOG_POST_QUERY_TYPE dog_post_query_type) {

          postsListBehaviorSubject.add(null);

          set_dog_post_query_type = dog_post_query_type;


          switch(dog_post_query_type){

            case DOG_POST_QUERY_TYPE.FEVORITES:
              loadPosts(postsQueryLimit: queryLimitForFirstPostsLoad, dog_post_query_type: DOG_POST_QUERY_TYPE.FEVORITES);
              break;
            case DOG_POST_QUERY_TYPE.FOLLOWING:

              getUserModelData(userId: firebaseUser.uid).then((UserModel currentUserModel){
                setCurrentUserModel = currentUserModel;


                if (getCurrentUserDogsFollowingList == null || getCurrentUserDogsFollowingList.isEmpty){


                  if(currentUserModel.followedDogsList != null && currentUserModel.followedDogsList.length > 10){


                    List<String> tempList = List<String>();
                    Random rand = Random();

                    for (int i = 1; i <= 10; ++i){
                      int randInt = rand.nextInt(currentUserModel.followedDogsList.length);
                      tempList.add(currentUserModel.followedDogsList[randInt]);
                    }

                    setCurrentUserDogsFollowingList = tempList;

                    loadPosts(postsQueryLimit: queryLimitForFirstPostsLoad, dog_post_query_type: DOG_POST_QUERY_TYPE.FOLLOWING, currentUserDogFollowingList: tempList);
                  }
                  else{

                    loadPosts(postsQueryLimit: queryLimitForFirstPostsLoad, dog_post_query_type: DOG_POST_QUERY_TYPE.FOLLOWING, currentUserDogFollowingList: currentUserModel.followedDogsList);
                  }
                }
                else{
                  loadPosts(postsQueryLimit: queryLimitForFirstPostsLoad, dog_post_query_type: DOG_POST_QUERY_TYPE.FOLLOWING, currentUserDogFollowingList: getCurrentUserDogsFollowingList);
                }

              });
              break;
            case DOG_POST_QUERY_TYPE.TRENDING:
              loadPosts(postsQueryLimit: queryLimitForFirstPostsLoad, dog_post_query_type: DOG_POST_QUERY_TYPE.TRENDING);
              break;
            default:
              loadPosts(postsQueryLimit: queryLimitForFirstPostsLoad);
          }

        });

       }

    });

  }




  void loadPosts({@required int postsQueryLimit, DOG_POST_QUERY_TYPE dog_post_query_type, List<dynamic> currentUserDogFollowingList}){

    this.setPostsList = List<DogPostModel>();
    this.setHasMorePosts = false;
    setHasLoadedPosts = false;

    hasMorePostsBehaviorSubject.add(true);

    DogPostModel dogPostModel = DogPostModel(postType: DogPostType.google_ads);

    getDogPostsData(
        queryLimit: postsQueryLimit,
        startAfterMap: null,
      dog_post_query_type: dog_post_query_type,
      currentUserDogFollowingList: currentUserDogFollowingList
    ).then((postsList){

      this.getPostsList.clear();

      if (postsList.length < postsQueryLimit){

        getPostsList.addAll(postsList);
        getPostsList.add(dogPostModel);
        postsListBehaviorSubject.add(this.getPostsList);

        this.setHasMorePosts = false;
        hasMorePostsBehaviorSubject.add(false);
        return;
      }
      else{


        setQueryStartAfterMap = postsList.last.toJson();

        getPostsList.addAll(postsList);
        getPostsList.add(dogPostModel);
        postsListBehaviorSubject.add(this.getPostsList);

        this.setHasMorePosts = true;
        hasMorePostsBehaviorSubject.add(true);
      }

    });
  }




  Future<void> loadMorePosts({ @required int postsQueryLimit, DOG_POST_QUERY_TYPE dog_post_query_type, List<dynamic> currentUserDogFollowingList})async{


    hasMorePostsBehaviorSubject.add(true);

    if (getHasMorePosts){


      List<DogPostModel> postsList = await getDogPostsData(
          queryLimit: postsQueryLimit,
          startAfterMap: getQueryStartAfterMap,
        dog_post_query_type: dog_post_query_type,
        currentUserDogFollowingList: currentUserDogFollowingList
      );

      DogPostModel dogPostModel = DogPostModel(postType: DogPostType.google_ads);


      if (postsList.length < postsQueryLimit){

        getPostsList.addAll(postsList);
        getPostsList.add(dogPostModel);
        postsListBehaviorSubject.add(this.getPostsList);


        setHasMorePosts = false;
        hasMorePostsBehaviorSubject.add(false);
      }
      else{

        setQueryStartAfterMap = postsList.last.toJson();

        getPostsList.addAll(postsList);
        getPostsList.add(dogPostModel);
        postsListBehaviorSubject.add(this.getPostsList);


        setHasMorePosts = true;
        hasMorePostsBehaviorSubject.add(true);
      }


    }
    else{

      hasMorePostsBehaviorSubject.add(false);
      setHasMorePosts = false;
    }

  }




  Future<List<DogPostModel>> getDogPostsData({
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap,

    DOG_POST_QUERY_TYPE dog_post_query_type,
    List<dynamic> currentUserDogFollowingList
    
  })async{


    QuerySnapshot querySnapshot;


    switch(dog_post_query_type){

      case DOG_POST_QUERY_TYPE.FEVORITES:
        if (startAfterMap == null){

          querySnapshot = await Firestore.instance
              .collectionGroup(FirestoreCollectionsNames.dog_posts)
              .orderBy(DogPostDocumentFieldName.num_likes, descending: true)
              .limit(queryLimit)
              .getDocuments();
        }
        else{
          querySnapshot = await Firestore.instance
              .collectionGroup(FirestoreCollectionsNames.dog_posts)
              .orderBy(DogPostDocumentFieldName.num_likes, descending: true)
              .limit(queryLimit)
              .startAfter([startAfterMap[DogPostDocumentFieldName.timestamp]])
              .getDocuments();
        }
        break;
      case DOG_POST_QUERY_TYPE.FOLLOWING:

        if (currentUserDogFollowingList != null && currentUserDogFollowingList.length > 0){

          if (startAfterMap == null){


            querySnapshot = await Firestore.instance
                .collectionGroup(FirestoreCollectionsNames.dog_posts)
                .where(DogPostDocumentFieldName.dog_user_id, whereIn: currentUserDogFollowingList,)
                .orderBy(DogPostDocumentFieldName.timestamp, descending: true)
                .limit(queryLimit)
                .getDocuments();
          }
          else{

            querySnapshot = await Firestore.instance
                .collectionGroup(FirestoreCollectionsNames.dog_posts)
                .where(DogPostDocumentFieldName.dog_user_id, whereIn: currentUserDogFollowingList)
                .orderBy(DogPostDocumentFieldName.timestamp, descending: true)
                .limit(queryLimit)
                .startAfter([startAfterMap[DogPostDocumentFieldName.timestamp]])
                .getDocuments();
          }
        }

        break;
      case DOG_POST_QUERY_TYPE.TRENDING:
        if (startAfterMap == null){

          querySnapshot = await Firestore.instance
              .collectionGroup(FirestoreCollectionsNames.dog_posts)
              .orderBy(DogPostDocumentFieldName.num_comments, descending: true)
              .limit(queryLimit)
              .getDocuments();
        }
        else{

          querySnapshot = await Firestore.instance
              .collectionGroup(FirestoreCollectionsNames.dog_posts)
              .orderBy(DogPostDocumentFieldName.num_comments, descending: true)
              .limit(queryLimit)
              .startAfter([startAfterMap[DogPostDocumentFieldName.timestamp]])
              .getDocuments();
        }
        break;
      default:
        if (startAfterMap == null){

          querySnapshot = await Firestore.instance
              .collectionGroup(FirestoreCollectionsNames.dog_posts)
              .orderBy(DogPostDocumentFieldName.timestamp, descending: true)
              .limit(queryLimit)
              .getDocuments();
        }
        else{

          querySnapshot = await Firestore.instance
              .collectionGroup(FirestoreCollectionsNames.dog_posts)
              .orderBy(DogPostDocumentFieldName.timestamp, descending: true)
              .limit(queryLimit)
              .startAfter([startAfterMap[DogPostDocumentFieldName.timestamp]])
              .getDocuments();
        }
    }




    List<DogPostModel> postsList = new List<DogPostModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> dogPostMap = querySnapshot.documents[index].data;
        DogPostModel dogPostModel = DogPostModel.fromJson(dogPostMap);

        dogPostModel.postId = querySnapshot.documents[index].reference.documentID;

        dogPostModel.dogModel = await getDogModelData(ownerId: dogPostModel.ownerUserId, dogId: dogPostModel.dogUserId);
        dogPostModel.ownerUserModel = await getUserModelData(userId: dogPostModel.ownerUserId);

        postsList.add(dogPostModel);

      }

    }

    return postsList;
  }



  Stream<Event> getIfUserLikedPostStream({@required String postId, @required String dogId, @required String currentUserId}){

    return FirebaseDatabase.instance.reference().child(RealtimeDatabaseChildNames.dog_posts_likes).child(dogId).child(postId).child(currentUserId).onValue;
  }



  Future<void> addPostLike({@required String postId, @required String dogId, @required String currentUserId}) async{

    FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_posts_likes)
        .child(dogId)
        .child(postId)
        .child(currentUserId)
        .set(true)
        .then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.dog_posts)
          .child(dogId)
          .child(postId).child(OptimisedDogPostFieldNames.num_likes);


      ref.runTransaction((MutableData transactionData) async{
        //transactionData.value = (transactionData.value ?? 0) + 1;

        if (transactionData.value == null){
          transactionData.value = 1;
        }
        else if (transactionData.value < 0){
          transactionData.value = 1;
        }
        else{
          transactionData.value = transactionData.value + 1;
        }

        return await transactionData;
      });


    });


  }





  Future<void> removePostLike({@required String postId, @required String dogId, @required String currentUserId}) async{

    FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_posts_likes)
        .child(dogId)
        .child(postId)
        .child(currentUserId)
        .remove()
        .then((_){


      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.dog_posts)
          .child(dogId)
          .child(postId)
          .child(OptimisedDogPostFieldNames.num_likes);



      ref.runTransaction((MutableData transactionData) async{

        if (transactionData.value == null){
          transactionData.value = 0;
        }
        else if (transactionData.value <= 0){
          transactionData.value = 0;
        }
        else{
          transactionData.value = transactionData.value - 1;
        }

        return await transactionData;
      });


    });


  }


  Future<int> getNumberOfPostLikes({@required String postId, @required String dogId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_posts)
        .child(dogId)
        .child(postId)
        .child(OptimisedDogPostFieldNames.num_likes)
        .once();

    return dataSnapshot.value;
  }


  Stream<Event> getNumberOfPostLikesStream({@required String postId, @required String dogId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_posts)
        .child(dogId)
        .child(postId)
        .child(OptimisedDogPostFieldNames.num_likes)
        .onValue;
  }





  Future<bool> checkIfDogPostIsBookMarked({String postId, String currentUserId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId).get();

    if (documentSnapshot != null && documentSnapshot.data != null){

      UserModel userModel = UserModel.fromJson(documentSnapshot.data);

      if (userModel.dogPostsBookmarkList != null && userModel.dogPostsBookmarkList.contains(postId)){
        return true;
      }
      else{
        return false;
      }
    }
    else{
      return false;
    }

  }


  Future<void> bookmarkDogPost({@required String postId, @required String currentUserId})async{

    DocumentReference documentReference = Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId);

    await documentReference.firestore.runTransaction((Transaction transaction)async{

      await transaction.update(documentReference, {UsersDocumentFieldNames.dog_posts_bookmark_list: FieldValue.arrayUnion([postId])});
    });
  }



  Stream<DocumentSnapshot> getCurrentUserStreamModel({@required currentUserId}){
    return Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId).snapshots();
  }


  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }

  Future<DogModel> getDogModelData({@required String ownerId, @required String dogId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection(FirestoreCollectionsNames.users).document(ownerId).collection(FirestoreCollectionsNames.dogs).document(dogId).get();

    return DogModel.fromJson(documentSnapshot.data);
  }



  void dispose(){

  }
}