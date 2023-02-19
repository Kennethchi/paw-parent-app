


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class DogPostRoomBloc{

  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }


  BehaviorSubject<DogPostModel> dogPostModelBehaviorSubject = BehaviorSubject<DogPostModel>();



  DogPostRoomBloc({@required DogPostModel dogPostModel}){

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){
        setCurrentUserId = firebaseUser.uid;

        dogPostModelBehaviorSubject.add(dogPostModel);
      }

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


  void dispose(){

  }

}