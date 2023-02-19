


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class CreateDogPostBloc{

  UserModel _userModel;
  UserModel get getUserModel => _userModel;
  set setUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  DogModel _dogModel;
  DogModel get getDogModel => _dogModel;
  set setDogModel(DogModel dogModel) {
    _dogModel = dogModel;
  }



  // images for image post
  List<String> _postImagesPaths;
  List<String> get getPostImagesPaths => _postImagesPaths;
  set setPostImagesPaths(List<String> postImagesPaths) {
    _postImagesPaths = postImagesPaths;
  }


  String _postType;
  String get getPostType => _postType;
  set setPostType(String postType) {
    _postType = postType;
  }



  BehaviorSubject<List<String>> imagesPathBehaviorSubject = BehaviorSubject<List<String>>();
  BehaviorSubject<String> postTypeBehaviorSubject= BehaviorSubject<String>();
  BehaviorSubject<bool> isPostImagesLimitReachedBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<bool> showCreatePostButtonBehaviorSubject = BehaviorSubject<bool>();



  CreateDogPostBloc({@required UserModel currentUserModel, @required DogModel dogModel}){

    setPostImagesPaths = List<String>();

    if (currentUserModel != null && dogModel != null){
      setUserModel = currentUserModel;
      setDogModel = dogModel;

      postTypeBehaviorSubject.add(DogPostType.image);
    }

    postTypeBehaviorSubject.listen((String postType) {
      setPostType = postType;
    });


    imagesPathBehaviorSubject.listen((List<String> imagesList) {
      if (imagesList != null && imagesList.length > 0){
        showCreatePostButtonBehaviorSubject.add(true);
      }
      else{
        showCreatePostButtonBehaviorSubject.add(false);
      }
    });


  }


  Future<String> addDogPostData({@required String dogUserId, @required String ownerUserId, @required DogPostModel dogPostModel})async{

    DocumentReference documentReference = Firestore.instance
        .collection(FirestoreCollectionsNames.users)
        .document(ownerUserId)
        .collection(FirestoreCollectionsNames.dogs)
        .document(dogUserId)
        .collection(FirestoreCollectionsNames.dog_posts)
        .document();

    await documentReference.setData(dogPostModel.toJson());

    documentReference.updateData({DogPostDocumentFieldName.post_id: documentReference.documentID});

    return documentReference.documentID;
  }


  Future<String> addDogOptimisedPostData({
    @required String dogUserId, @required OptimisedDogPostModel optimisedDogPostModel, @required String postId})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.dog_posts)
        .child(dogUserId)
        .child(postId)
        .set(optimisedDogPostModel.toJson());
  }


  Future<void> increaseDogPostsCount({@required String dogUserId, @required String ownerUserId})async{

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(ownerUserId)
        .child(RealtimeDatabaseChildNames.dogs)
        .child(dogUserId)
        .child(RealtimeDatabaseChildNames.dog_profile)
        .child(OptimisedDogsChildFieldNames.num_posts);


    await databaseReference.runTransaction((MutableData transactionData) async{

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
  }

  void dispose(){

    showCreatePostButtonBehaviorSubject?.close();
    postTypeBehaviorSubject?.close();
    imagesPathBehaviorSubject?.close();

  }
}