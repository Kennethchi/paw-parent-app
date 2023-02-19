

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/post_comments/post_comments_validators.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_comment_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class PostCommentsBloc{

  DogPostModel _dogPostModel;
  DogPostModel get getDogPostModel => _dogPostModel;
  set setDogPostModel(DogPostModel dogPostModel) {
    _dogPostModel = dogPostModel;
  }

  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }


  int _commentsQueryLimit;
  int get getCommentsQueryLimit => _commentsQueryLimit;
  set setCommentsQueryLimit(int commentsQueryLimit) {
    _commentsQueryLimit = commentsQueryLimit;
  }

  int _queryEndAtValue;
  int get getQueryEndAtValue => _queryEndAtValue;
  set setQueryEndAtValue(int queryEndAtValue) {
    _queryEndAtValue = queryEndAtValue;
  }

  List<OptimisedCommentModel> _CommentsList;
  List<OptimisedCommentModel> get getCommentsList => _CommentsList;
  set setCommentsList(List<OptimisedCommentModel> commentsList) {
    _CommentsList = commentsList;
  }

  bool _hasMoreComments;
  bool get getHasMoreComments => _hasMoreComments;
  set setHasMoreComments(bool hasMoreComments) {
    _hasMoreComments = hasMoreComments;
  }

  bool _hasLoadedComments;
  bool get getHasLoadedComments => _hasLoadedComments;
  set setHasLoadedComments(bool hasLoadedComments) {
    _hasLoadedComments = hasLoadedComments;
  }

  BehaviorSubject<String> _textBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getTextStream => _textBehaviorSubject.stream.transform(PostCommentsValidators.textValidator);
  StreamSink<String> get _getTextSink => _textBehaviorSubject.sink;

  BehaviorSubject<List<OptimisedCommentModel>> _commentsListBehaviorSubject = BehaviorSubject<List<OptimisedCommentModel>>();
  Stream<List<OptimisedCommentModel>> get getCommentListStream => _commentsListBehaviorSubject.stream;
  StreamSink<List<OptimisedCommentModel>> get _getCommentListSink => _commentsListBehaviorSubject.sink;

  BehaviorSubject<bool> _hasMoreCommentsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMoreCommentsStream => _hasMoreCommentsBehaviorSubject.stream;
  StreamSink<bool> get _getHasMoreCommentsSink => _hasMoreCommentsBehaviorSubject.sink;

  BehaviorSubject<String> _currentUserIdBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getCurrentUserIdStream => _currentUserIdBehaviorSubject.stream;
  StreamSink<String> get _getCurrentUserIdSink => _currentUserIdBehaviorSubject.sink;

  BehaviorSubject<String> currentUserIdBehaviorSubject = BehaviorSubject<String>();

  PostCommentsBloc({@required DogPostModel dogPostModel}){

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){

        setCurrentUserId = firebaseUser.uid;
        currentUserIdBehaviorSubject.add(firebaseUser.uid);

        setDogPostModel = dogPostModel;

        setCommentsQueryLimit = 20;

        setCommentsList = List<OptimisedCommentModel>();
        setHasMoreComments = true;
        setHasLoadedComments = false;

        loadComments(
            commentsPostId: dogPostModel.postId,
            dogId: dogPostModel.dogUserId,
            queryLimit: getCommentsQueryLimit,
            endAtValue: null
        );


      }

    });

  }



  Future<List<OptimisedCommentModel>> setUpCommentsData({@required List<OptimisedCommentModel> commentsList})async{

    List<OptimisedCommentModel> processedList = List<OptimisedCommentModel>();

    for (int index = 0; index < commentsList.length; ++index){

      String userId = commentsList[index].user_id;

      commentsList[index].userModel = await getUserModelData(userId: userId);

      UserModel userModel = commentsList[index].userModel;

      commentsList[index].name = userModel.profileName;
      commentsList[index].thumb = userModel.profileImageThumb;
      commentsList[index].username = await userModel.username;

      processedList.add(commentsList[index]);
    }

    return processedList;
  }



  void loadComments({@required String commentsPostId, @required String dogId, @required int queryLimit, int endAtValue}){

    this.setCommentsList = List<OptimisedCommentModel>();
    setHasMoreComments = true;
    setHasLoadedComments = false;


    getCommentsData(postId: commentsPostId, dogId: dogId, queryLimit: queryLimit, endAtValue: endAtValue).then((commentsList){

      this.getCommentsList.clear();

      if (commentsList.length < getCommentsQueryLimit){

        setHasMoreComments = false;
        addHasMoreCommentsToStream(false);
      }
      else{
        setQueryEndAtValue = commentsList.removeLast().t;
      }


      setUpCommentsData(commentsList: commentsList).then((List<OptimisedCommentModel> processedCommentsList){

        getCommentsList.addAll(processedCommentsList);

        addCommentListToStream(this.getCommentsList);
      });


    });
  }



  Future<void> loadMoreComments({String commentsPostId, @required String dogId, @required int queryLimit, int endAtValue})async{


    if (getHasMoreComments){

      List<OptimisedCommentModel> commentsList = await getCommentsData(postId: commentsPostId, dogId: dogId, queryLimit: queryLimit, endAtValue: endAtValue);

      if (commentsList.length < getCommentsQueryLimit){

        setHasMoreComments = false;
        addHasMoreCommentsToStream(false);
      }
      else{

        setQueryEndAtValue = commentsList.removeLast().t;
      }

      setUpCommentsData(commentsList: commentsList).then((List<OptimisedCommentModel> processedCommentsList){

        this.getCommentsList.addAll(processedCommentsList);

        addCommentListToStream(getCommentsList);
      });

    }
    else{
      addHasMoreCommentsToStream(false);
      setHasMoreComments = false;

    }

  }


  void addHasMoreCommentsToStream(bool hasMoreVideos){
    _getHasMoreCommentsSink.add(hasMoreVideos);
  }

  void addCommentListToStream(List<OptimisedCommentModel> optimisedVideoPreviewList){
    _getCommentListSink.add(optimisedVideoPreviewList);
  }


  void addTextToStream({@required String text}) {
    _getTextSink.add(text);
  }





  // Gets all comments data from database with pagination
  static Future<List<OptimisedCommentModel>> getCommentsData({@required String postId, @required String dogId, @required int queryLimit, @required int endAtValue})async{

    DataSnapshot dataSnapshots;


    if (endAtValue == null){

      // keeps the comments in synced
      // Note that if your billing is expensive for no reason, check this code and delete it
      await FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.posts_comments)
          .child(dogId)
          .child(postId)
          .orderByChild(CommentFieldNamesOptimised.t)
          .limitToLast(queryLimit).keepSynced(true);

      dataSnapshots = await FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.posts_comments)
          .child(dogId)
          .child(postId)
          .orderByChild(CommentFieldNamesOptimised.t)
          .limitToLast(queryLimit)
          .once();
    }
    else{

      dataSnapshots = await FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.posts_comments)
          .child(dogId)
          .child(postId)
          .orderByChild(CommentFieldNamesOptimised.t)
          .limitToLast(queryLimit)
          .endAt(endAtValue)
          .once();
    }


    Map<dynamic, dynamic> dataMap = dataSnapshots.value;

    List<OptimisedCommentModel> commentsList = new List<OptimisedCommentModel>();

    if(dataMap != null){

      dataMap.forEach((key, value){

        Map<dynamic, dynamic> commentMap = dataMap[key];

        OptimisedCommentModel optimisedCommentModel = OptimisedCommentModel.fromJson(commentMap);
        optimisedCommentModel.id = key;

        commentsList.add(optimisedCommentModel);
      });

    }


    // sorts according to timestamp in optimised comment model
    commentsList.sort();


    return commentsList;
  }









  Future<String>  addCommentData({@required OptimisedCommentModel optimisedCommentModel, @required String dogId, @required String postId})async{

    DatabaseReference databaseReference = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.posts_comments)
        .child(dogId)
        .child(postId)
        .push();



    await databaseReference.set(optimisedCommentModel.toJson()).then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.dog_posts)
          .child(dogId)
          .child(postId)
          .child(OptimisedDogPostFieldNames.num_comments);


      ref.runTransaction((MutableData transactionData) async{

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


    return databaseReference.key;
  }


  Future<void> deletePostComment({@required String dogId, @required String postId, @required String commentId})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.posts_comments)
        .child(dogId)
        .child(postId)
        .child(commentId)
        .remove().then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.dog_posts)
          .child(dogId)
          .child(postId)
          .child(OptimisedDogPostFieldNames.num_comments);

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




  Future<String> getCommentUserUserName({@required String commentUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RealtimeDatabaseChildNames.users)
        .child(commentUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.username).once();

    return dataSnapshot.value;
  }

  Future<String> getCommentUserProfileName({@required String commentUserId})async{


    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RealtimeDatabaseChildNames.users)
        .child(commentUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.profile_name).once();
    return dataSnapshot.value;
  }

  Future<String> getCommentUserProfileThumb({@required String commentUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RealtimeDatabaseChildNames.users)
        .child(commentUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.thumb).once();

    return dataSnapshot.value;
  }


  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }



  void dispose(){

  }

}