

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_insight_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';




class InsightRoomBloc{

  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }


  BehaviorSubject<InsightModel> insightModelBehaviorSubject = BehaviorSubject<InsightModel>();

  InsightRoomBloc({@required InsightModel insightModel}){

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){
        setCurrentUserId = firebaseUser.uid;

        increaseInsightNumSeen(insightId: insightModel.insightId);

        insightModelBehaviorSubject.add(insightModel);
      }

    });

  }



  Future<bool> checkIfInsightIsBookMarked({String insightId, String currentUserId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId).get();

    if (documentSnapshot != null && documentSnapshot.data != null){

      UserModel userModel = UserModel.fromJson(documentSnapshot.data);

      if (userModel.insightsBookmarkList != null && userModel.insightsBookmarkList.contains(insightId)){
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


  Future<void> bookmarkInsight({@required String insightId, @required String currentUserId})async{

    DocumentReference documentReference = Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId);

    await documentReference.firestore.runTransaction((Transaction transaction)async{

      await transaction.update(documentReference, {UsersDocumentFieldNames.insights_bookmark_list: FieldValue.arrayUnion([insightId])});
    });
  }


  Future<void> increaseInsightNumSeen({@required String insightId}){

    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights)
        .child(insightId)
        .child(OptimisedInsightFieldNames.num_seens);


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

  }


  Future<void> increaseInsightNumShares({@required String insightId}){

    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights)
        .child(insightId)
        .child(OptimisedInsightFieldNames.num_shares);

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

  }



  Stream<Event> getIfUserLikedInsightStream({@required String insightId, @required String currentUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights_likes)
        .child(insightId).child(currentUserId).onValue;
  }

  Future<void> addInsightLike({@required String insightId, @required String currentUserId}) async{

    FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights_likes)
        .child(insightId)
        .child(currentUserId)
        .set(true)
        .then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.insights)
          .child(insightId)
          .child(OptimisedInsightFieldNames.num_likes);


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


  }





  Future<void> removeInsightLike({@required String insightId, @required String currentUserId}) async{

    FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights_likes)
        .child(insightId)
        .child(currentUserId)
        .remove()
        .then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RealtimeDatabaseChildNames.insights)
          .child(insightId)
          .child(OptimisedInsightFieldNames.num_likes);



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




  Stream<Event> getNumberOfInsightLikesStream({@required String insightId}){

    return FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights)
        .child(insightId)
        .child(OptimisedInsightFieldNames.num_likes)
        .onValue;
  }


  Future<int> getNumberOfInsightLikes({@required String insightId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights)
        .child(insightId)
        .child(OptimisedInsightFieldNames.num_likes)
        .once();

    return dataSnapshot.value;
  }


  Future<int> getNumberOfInsightSeens({@required String insightId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights)
        .child(insightId)
        .child(OptimisedInsightFieldNames.num_seens)
        .once();

    return dataSnapshot.value;
  }



  Future<int> getNumberOfInsightShares({@required String insightId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights)
        .child(insightId)
        .child(OptimisedInsightFieldNames.num_shares)
        .once();

    return dataSnapshot.value;
  }


  Stream<DocumentSnapshot> getCurrentUserStreamModel({@required currentUserId}){
    return Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId).snapshots();
  }


  void dispose(){

  }

}