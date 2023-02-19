


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/resources/models/insight_tag_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_insight_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:rxdart/rxdart.dart';

class InsightsPageBloc{


  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }


  // dog query limits
  int _insightsQueryLimit;
  int get getInsightsQueryLimit => _insightsQueryLimit;
  set setInsightsQueryLimit(int insightsQueryLimit) {
    _insightsQueryLimit = insightsQueryLimit;
  }


  // startMap for checkpoint for get insights
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of insights
  List<InsightModel> _insightsList;
  List<InsightModel> get getInsightsList => _insightsList;
  set setInsightsList(List<InsightModel> insightsList) {
    _insightsList = insightsList;
  }

  // has more insights to loaded
  bool _hasMoreInsights;
  bool get getHasMoreInsights => _hasMoreInsights;
  set setHasMoreInsights(bool hasMoreInsights) {
    _hasMoreInsights = hasMoreInsights;
  }


  // has loaded insights to avoid repetition of insights
  // bloc provider implements this
  bool _hasLoadedInsights;
  bool get getHasLoadedInsights => _hasLoadedInsights;
  set setHasLoadedInsights(bool hasLoadedInsights) {
    _hasLoadedInsights = hasLoadedInsights;
  }


  BehaviorSubject<List<InsightModel>> insightsListBehaviorSubject = BehaviorSubject<List<InsightModel>>();
  BehaviorSubject<bool> hasMoreInsightsBehaviorSubject = BehaviorSubject<bool>();


  InsightsPageBloc(){


    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){
        setCurrentUserId = firebaseUser.uid;
        setInsightsQueryLimit = 10;

        int queryLimitForFirstInsightsLoad = 3;

        loadInsights(insightsQueryLimit: queryLimitForFirstInsightsLoad);
      }

    });

  }




  void loadInsights({@required int insightsQueryLimit, DOG_POST_QUERY_TYPE dog_post_query_type, List<dynamic> currentUserDogFollowingList}){

    this.setInsightsList = List<InsightModel>();
    this.setHasMoreInsights = false;
    setHasLoadedInsights = false;

    hasMoreInsightsBehaviorSubject.add(true);
    
    getInsightsData(
        queryLimit: insightsQueryLimit,
        startAfterMap: null
    ).then((insightsList){

      this.getInsightsList.clear();

      if (insightsList.length < insightsQueryLimit){

        getInsightsList.addAll(insightsList);
        insightsListBehaviorSubject.add(this.getInsightsList);

        this.setHasMoreInsights = false;
        hasMoreInsightsBehaviorSubject.add(false);
        return;
      }
      else{


        setQueryStartAfterMap = insightsList.last.toJson();

        getInsightsList.addAll(insightsList);
        insightsListBehaviorSubject.add(this.getInsightsList);

        this.setHasMoreInsights = true;
        hasMoreInsightsBehaviorSubject.add(true);
      }

    });
  }




  Future<void> loadMoreInsights({ @required int insightsQueryLimit, DOG_POST_QUERY_TYPE dog_post_query_type, List<dynamic> currentUserDogFollowingList})async{


    hasMoreInsightsBehaviorSubject.add(true);

    if (getHasMoreInsights){


      List<InsightModel> insightsList = await getInsightsData(
          queryLimit: insightsQueryLimit,
          startAfterMap: getQueryStartAfterMap,
      );
      
      if (insightsList.length < insightsQueryLimit){

        getInsightsList.addAll(insightsList);
        insightsListBehaviorSubject.add(this.getInsightsList);


        setHasMoreInsights = false;
        hasMoreInsightsBehaviorSubject.add(false);
      }
      else{

        setQueryStartAfterMap = insightsList.last.toJson();

        getInsightsList.addAll(insightsList);
        insightsListBehaviorSubject.add(this.getInsightsList);

        setHasMoreInsights = true;
        hasMoreInsightsBehaviorSubject.add(true);
      }


    }
    else{

      hasMoreInsightsBehaviorSubject.add(false);
      setHasMoreInsights = false;
    }

  }




  Future<List<InsightModel>> getInsightsData({
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap,

  })async{


    QuerySnapshot querySnapshot;


    if (startAfterMap == null){

      querySnapshot = await Firestore.instance
          .collectionGroup(FirestoreCollectionsNames.insights)
          .orderBy(InsightDocumentFieldName.timestamp, descending: true)
          .limit(queryLimit)
          .getDocuments();
    }
    else{

      querySnapshot = await Firestore.instance
          .collectionGroup(FirestoreCollectionsNames.insights)
          .orderBy(InsightDocumentFieldName.timestamp, descending: true)
          .limit(queryLimit)
          .startAfter([startAfterMap[InsightDocumentFieldName.timestamp]])
          .getDocuments();
    }




    List<InsightModel> insightsList = new List<InsightModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> insightMap = querySnapshot.documents[index].data;
        InsightModel insightModel = InsightModel.fromJson(insightMap);

        insightModel.insightId = querySnapshot.documents[index].reference.documentID;

        insightModel.userModel= await getUserModelData(userId: insightModel.userId);

        insightsList.add(insightModel);
      }

    }

    return insightsList;
  }



  Future<List<InsightTagModel>> getPopularInsightsTags()async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(FirestoreCollectionsNames.insights_tags)
        .orderBy(InsightTagModelDocumentFieldNames.count, descending: true)
        .limit(10)
        .getDocuments();

    List<InsightTagModel> insightsTagList = new List<InsightTagModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> insightTagMap = querySnapshot.documents[index].data;
        InsightTagModel insightTagModel = InsightTagModel.fromJson(insightTagMap);

        insightTagModel.tagId = querySnapshot.documents[index].reference.documentID;


        insightsTagList.add(insightTagModel);
      }

    }

    return insightsTagList;
  }


  Future<List<InsightModel>> getTopInsightsData()async{


    QuerySnapshot querySnapshot = await Firestore.instance
        .collectionGroup(FirestoreCollectionsNames.insights)
        //.orderBy(InsightDocumentFieldName.num_seens, descending: true)
        .limit(10)
        .getDocuments();


    List<InsightModel> insightsList = new List<InsightModel>();


    if(querySnapshot != null && querySnapshot.documents != null){


      for (int index = 0; index < querySnapshot.documents.length; ++index){


        Map<String, dynamic> insightMap = querySnapshot.documents[index].data;
        InsightModel insightModel = InsightModel.fromJson(insightMap);

        insightModel.insightId = querySnapshot.documents[index].reference.documentID;

        insightModel.userModel= await getUserModelData(userId: insightModel.userId);

        insightsList.add(insightModel);
      }

    }

    return insightsList;
  }



  Future<int> getNumberOfInsightSeens({@required String insightId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.insights)
        .child(insightId)
        .child(OptimisedInsightFieldNames.num_seens)
        .once();

    return dataSnapshot.value;
  }



  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }


  void dispose(){

  }

}