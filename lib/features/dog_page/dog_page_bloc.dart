



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_ff_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class DogPageBloc{

  DogModel _dogModel;
  DogModel get getDogModel => _dogModel;
  set setDogModel(DogModel dogModel) {
    _dogModel = dogModel;
  }

  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }
  
  UserModel _ownerUserModel;
  UserModel get getOwnerUserModel => _ownerUserModel;
  set setOwnerUserModel(UserModel ownerUserModel) {
    _ownerUserModel = ownerUserModel;
  }

  bool _showDogInfoMenu;
  bool get getShowDogInfoMenu => _showDogInfoMenu;
  set setShowDogInfoMenu(bool showDogInfoMenu) {
    _showDogInfoMenu = showDogInfoMenu;
  }



  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
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


  // has loaded posts to avoid repetition of posts
  // bloc provider implements this
  bool _hasLoadedPosts;
  bool get getHasLoadedPosts => _hasLoadedPosts;
  set setHasLoadedPosts(bool hasLoadedPosts) {
    _hasLoadedPosts = hasLoadedPosts;
  }





  BehaviorSubject<bool> isListViewBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<DogModel> dogModelBehaviorSubject = BehaviorSubject<DogModel>();
  BehaviorSubject<UserModel> ownerUserModelBehaviorSubject = BehaviorSubject<UserModel>();
  BehaviorSubject<bool> isCurrentUserDogOwnerBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<String> dogInfoMenuTypeBehaviorSubject = BehaviorSubject<String>();
  //BehaviorSubject<bool> showDogInfoMenuBehaviorSubject = BehaviorSubject<bool>();

  BehaviorSubject<List<DogPostModel>> postsListBehaviorSubject = BehaviorSubject<List<DogPostModel>>();
  BehaviorSubject<bool> hasMorePostsBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<int> numberOfFollowersBehaviorSubject = BehaviorSubject<int>();



  DogPageBloc({@required UserModel ownerUserModel, @required DogModel dogModel}){

    if (ownerUserModel != null && dogModel != null){



      FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

        if (firebaseUser != null){

          setPostsQueryLimit = 20;

          setCurrentUserId = firebaseUser.uid;

          if ( firebaseUser.uid == dogModel.ownerUserId){

            isCurrentUserDogOwnerBehaviorSubject.add(true);

            setOwnerUserModel = ownerUserModel;
            setCurrentUserModel = ownerUserModel;


            dogModelBehaviorSubject.add(dogModel);
            ownerUserModelBehaviorSubject.add(getOwnerUserModel);

            loadPosts(userId: getOwnerUserModel.userId, dogId: dogModel.userId, dogQueryLimit: getPostsQueryLimit);
          }else{

            getUserModelData(userId: dogModel.ownerUserId).then((UserModel ownerUserModel){

              getUserModelData(userId: firebaseUser.uid).then((UserModel currentUserModel){
                setCurrentUserModel = currentUserModel;

                setOwnerUserModel = ownerUserModel;

                dogModelBehaviorSubject.add(dogModel);
                ownerUserModelBehaviorSubject.add(getOwnerUserModel);
                loadPosts(userId: getOwnerUserModel.userId, dogId: dogModel.userId, dogQueryLimit: getPostsQueryLimit);
              });

            });

          }


          getNumberOfFollowers(ownerUserId: dogModel.ownerUserId, dogId: dogModel.userId).then((int numFollowers){
            numberOfFollowersBehaviorSubject.add(numFollowers);
          });

        }


      });
      

    }

    dogModelBehaviorSubject.listen((DogModel dogModel) {
      setDogModel = dogModel;
    });


    /*
    showDogInfoMenuBehaviorSubject.listen((showDogInfoMenu) {
      setShowDogInfoMenu = showDogInfoMenu;
    });

     */

    dogInfoMenuTypeBehaviorSubject.add(DogInfoMenuType.about);
    //showDogInfoMenuBehaviorSubject.add(false);
    
    
  }




  void loadPosts({@required String userId, @required String dogId,  @required int dogQueryLimit, }){

    this.setPostsList = List<DogPostModel>();
    this.setHasMorePosts = false;
    setHasLoadedPosts = false;

    hasMorePostsBehaviorSubject.add(true);


    getDogPostsData(
        userId: userId,
        dogId: dogId,
        queryLimit: dogQueryLimit,
        startAfterMap: null
    ).then((postsList){

      this.getPostsList.clear();

      if (postsList.length < dogQueryLimit){

        getPostsList.addAll(postsList);
        postsListBehaviorSubject.add(this.getPostsList);

        this.setHasMorePosts = false;
        hasMorePostsBehaviorSubject.add(false);
        return;
      }
      else{


        setQueryStartAfterMap = postsList.last.toJson();

        getPostsList.addAll(postsList);

        postsListBehaviorSubject.add(this.getPostsList);

        this.setHasMorePosts = true;
        hasMorePostsBehaviorSubject.add(true);
      }

    });
  }




  Future<void> loadMorePosts({@required userId, @required String dogId, @required int dogQueryLimit})async{


    hasMorePostsBehaviorSubject.add(true);

    if (getHasMorePosts){


      List<DogPostModel> postsList = await getDogPostsData(
          userId: userId,
          dogId: dogId,
          queryLimit: dogQueryLimit,
          startAfterMap: getQueryStartAfterMap
      );


      if (postsList.length < dogQueryLimit){

        getPostsList.addAll(postsList);
        postsListBehaviorSubject.add(this.getPostsList);


        setHasMorePosts = false;
        hasMorePostsBehaviorSubject.add(false);
      }
      else{

        setQueryStartAfterMap = postsList.last.toJson();

        getPostsList.addAll(postsList);

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
    @required String userId,
    @required String dogId,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;

    if (startAfterMap == null){

      querySnapshot = await Firestore.instance
          .collection(FirestoreCollectionsNames.users)
          .document(userId)
          .collection(FirestoreCollectionsNames.dogs)
          .document(dogId)
          .collection(FirestoreCollectionsNames.dog_posts)
          .orderBy(DogPostDocumentFieldName.timestamp, descending: true)
          .limit(queryLimit)
          .getDocuments();
    }
    else{

      querySnapshot = await Firestore.instance
          .collection(FirestoreCollectionsNames.users)
          .document(userId)
          .collection(FirestoreCollectionsNames.dogs)
          .document(dogId)
          .collection(FirestoreCollectionsNames.dog_posts)
          .orderBy(DogPostDocumentFieldName.timestamp, descending: true)
          .limit(queryLimit)
          .startAfter([startAfterMap[DogPostDocumentFieldName.timestamp]])
          .getDocuments();
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


  Stream<Event> getNumberOfPostsStreamEvent({@required String ownerUserId, @required String dogId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(ownerUserId)
        .child(RealtimeDatabaseChildNames.dogs)
        .child(dogId)
        .child(RealtimeDatabaseChildNames.dog_profile)
        .child(OptimisedDogsChildFieldNames.num_posts)
        .onValue;
  }


  Future<int> getNumberOfPosts({@required String ownerUserId, @required String dogId}) async{

    return (await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(ownerUserId)
        .child(RealtimeDatabaseChildNames.dogs)
        .child(dogId)
        .child(RealtimeDatabaseChildNames.dog_profile)
        .child(OptimisedDogsChildFieldNames.num_posts)
        .once()).value;
  }


  Future<int> getNumberOfFollowers({@required String ownerUserId, @required String dogId}) async{

    return (await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(ownerUserId)
        .child(RealtimeDatabaseChildNames.dogs)
        .child(dogId)
        .child(RealtimeDatabaseChildNames.dog_profile)
        .child(OptimisedDogsChildFieldNames.num_followers)
        .once()).value;
  }





  Stream<Event> checkIfCurrentUserIsADogFollowerStreamEvent({@required String currentUserId, @required dogId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_followers)
        .child(dogId)
        .child(currentUserId)
        .onValue;
  }




  Future<void> addDogFollower({@required OptimisedFFModel optimisedFFModel, @required String currentUserId, @required String dogId, @required String dogOwnerId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_followers)
        .child(dogId)
        .child(currentUserId)
        .set(optimisedFFModel.toJson()).then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.users)
          .child(dogOwnerId).child(RealtimeDatabaseChildNames.dogs)
          .child(dogId).child(RealtimeDatabaseChildNames.dog_profile)
          .child(OptimisedDogsChildFieldNames.num_followers);

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



  Future<void> removeDogFollower({@required String currentUserId, @required String dogId, @required dogOwnerId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_followers)
        .child(dogId)
        .child(currentUserId)
        .remove().then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.users)
          .child(dogOwnerId).child(RealtimeDatabaseChildNames.dogs)
          .child(dogId).child(RealtimeDatabaseChildNames.dog_profile)
          .child(OptimisedDogsChildFieldNames.num_followers);

      ref.runTransaction((MutableData transactionData) async{
        //transactionData.value = (transactionData.value ?? 0) - 1;

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




  Future<void> addDogFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId, @required String dogId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.user_dog_followings)
        .child(currentUserId)
        .child(dogId)
        .set(optimisedFFModel.toJson()).then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.users)
          .child(currentUserId)
          .child(RealtimeDatabaseChildNames.user_profile).child(OptimisedUserChiledFieldNames.num_followings);


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



  Future<void> removeDogFollowing({@required String dogId, @required String currentUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.user_dog_followings)
        .child(currentUserId)
        .child(dogId)
        .remove().then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.users)
          .child(currentUserId)
          .child(RealtimeDatabaseChildNames.user_profile).child(OptimisedUserChiledFieldNames.num_followings);

      ref.runTransaction((MutableData transactionData) async{
        //transactionData.value = (transactionData.value ?? 0) - 1;

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


  Future<void> addUserDogFollowingUserId({String currentUserId, String dogId}){


    DocumentReference documentReference = Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId);

    documentReference.firestore.runTransaction((Transaction transaction)async{

      await transaction.update(documentReference, {UsersDocumentFieldNames.followed_dogs_list: FieldValue.arrayUnion([dogId])});
    });

  }


  Future<void> removeUserDogFollowingUserId({String currentUserId, String dogId}){


    DocumentReference documentReference = Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId);

    documentReference.firestore.runTransaction((Transaction transaction)async{

      await transaction.update(documentReference, {UsersDocumentFieldNames.followed_dogs_list: FieldValue.arrayRemove([dogId])});
    });

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


  Future<int> getNumberOfPostComments({@required String postId, @required String dogId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_posts)
        .child(dogId)
        .child(postId)
        .child(OptimisedDogPostFieldNames.num_comments)
        .once();

    return dataSnapshot.value;
  }



  Future<void> deleteDogPostData({@required String dogUserId, @required String ownerUserId, @required String postId})async{

    await Firestore.instance
        .collection(FirestoreCollectionsNames.users)
        .document(ownerUserId)
        .collection(FirestoreCollectionsNames.dogs)
        .document(dogUserId)
        .collection(FirestoreCollectionsNames.dog_posts)
        .document(postId)
        .delete();


    DatabaseReference databaseReference = FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(ownerUserId)
        .child(RealtimeDatabaseChildNames.dogs)
        .child(dogUserId)
        .child(RealtimeDatabaseChildNames.dog_profile)
        .child(OptimisedDogsChildFieldNames.num_posts);


    await databaseReference.runTransaction((MutableData transactionData) async{

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

    return debugDescribeFocusTree();
  }




  Future<void> deleteOptimisedDogPost({@required String dogUserId, @required String ownerUserId, @required String postId})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_posts)
        .child(dogUserId)
        .child(postId).remove();
  }



  Future<void> deleteAllPostLikes({@required String postId, @required String dogId, })async{

    await FirebaseDatabase.instance.reference().child(RealtimeDatabaseChildNames.dog_posts_likes).child(dogId).child(postId).remove();
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

    isListViewBehaviorSubject?.close();
    dogModelBehaviorSubject?.close();
    isCurrentUserDogOwnerBehaviorSubject?.close();
    dogInfoMenuTypeBehaviorSubject?.close();

  }

}