

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/resources/models/insight_tag_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_insight_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:paw_parent_app/services/server_api.dart';
import 'package:rxdart/rxdart.dart';

class CreateInsightPostBloc{



  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }

  String _insightType;
  String get getInsightType => _insightType;
  set setInsightType(String insightType) {
    _insightType = insightType;
  }



  File _insightImageFile;
  File get getInsightImageFile => _insightImageFile;
  set setInsightImageFile(File insightImageFile) {
    _insightImageFile = insightImageFile;
  }


  List _insightTagsList;
  List get getInsightTagsList => _insightTagsList;
  set setInsightTagsList(List insightTagsList) {
    _insightTagsList = insightTagsList;
  }


  BehaviorSubject<File> insightImageFileBehaviorSubject = BehaviorSubject<File>();
  BehaviorSubject<bool> showCreateInsightButtonBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<List<String>> insightTagsListBehaviorSubject = BehaviorSubject<List<String>>();
  BehaviorSubject<String> insightTypeBehaviorSubject = BehaviorSubject<String>();


  CreateInsightPostBloc(){


    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

      setCurrentUserId = firebaseUser.uid;

      insightTagsListBehaviorSubject.add(List<String>());
      insightTypeBehaviorSubject.add(InsightType.image);


      insightImageFileBehaviorSubject.listen((File insightImageFile){
        setInsightImageFile = insightImageFile;
      });

      insightTagsListBehaviorSubject.listen((List<String> insightsTagsList) {
        setInsightTagsList = insightsTagsList;
      });

      insightTypeBehaviorSubject.listen((String insightType) {
        setInsightType = insightType;
      });

      showCreateInsightButtonBehaviorSubject.sink.add(true);
    });

  }



  Future<bool> checkIfTagNameExists({@required String tagName})async{

    QuerySnapshot querySnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.insights_tags)
        .where(InsightTagModelDocumentFieldNames.unique_name, isEqualTo: tagName).limit(1).getDocuments();
    if (querySnapshot.documents != null && querySnapshot.documents.length > 0){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> addTagsData({@required List<String> tagsList})async{

    for (int index = 0 ; index < tagsList.length; ++index){

      String tag = tagsList[index].toLowerCase();

      if (await checkIfTagNameExists(tagName: tag)){

        QuerySnapshot querySnapshot = await Firestore.instance
            .collection(FirestoreCollectionsNames.insights_tags)
            .where(InsightTagModelDocumentFieldNames.unique_name, isEqualTo: tag)
            .limit(1).getDocuments();

        Firestore.instance.collection(FirestoreCollectionsNames.insights_tags)
            .document(querySnapshot.documents.first.documentID)
            .updateData({InsightTagModelDocumentFieldNames.count: FieldValue.increment(1) });

      }
      else{

        InsightTagModel insightTagModel = InsightTagModel(
          uniqueName: tag
        );
        Firestore.instance.collection(FirestoreCollectionsNames.insights_tags).add(insightTagModel.toJson());
      }

    }
  }


  Future<String> uploadFileToCloudStorage({@required String currentUserId, @required File file, @required String filename})async{

    return await ServerApi.uploadFileToCloudStorage(file: file, filename: filename, storagePath: "users/${currentUserId}/insights" );
  }



  Future<String> addInisghtModelData({@required String currentUserId, @required InsightModel insightModel})async{


    DocumentReference documentReference =  Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId).collection(FirestoreCollectionsNames.insights).document();

    await documentReference.setData(insightModel.toJson());

    await documentReference.updateData({InsightDocumentFieldName.insight_id: documentReference.documentID});

    return documentReference.documentID;
  }

  Future<void> addOptimisedInsightModelData({@required currentUserId, @required String insightId, @required OptimisedInsightModel optimisedInsightModel})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights)
        .child(currentUserId)
        .child(insightId)
        .set(optimisedInsightModel.toJson());

  }



  Future<void> increaseNumberOfInsightsCount({ @required String currentUserId})async{

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(currentUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.num_insights);

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


  }


}