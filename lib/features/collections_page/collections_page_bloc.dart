import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';



class CollectionsPageBloc{

  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }


  CollectionsPageBloc({@required UserModel currentUserModel}){

    setCurrentUserModel = currentUserModel;
  }


  Future<List<DogPostModel>> getBookmarkedDogPostModelData({@required List<dynamic> postIdList})async{


    List<DogPostModel> postModelList = List<DogPostModel>();

    if (postIdList != null && postIdList.length > 0){

      for (int index = 0; index < postIdList.length; ++index){

        QuerySnapshot querySnapshot = await Firestore.instance
            .collectionGroup(FirestoreCollectionsNames.dog_posts)
            .where(DogPostDocumentFieldName.post_id, isEqualTo: postIdList[index])
            .orderBy(DogPostDocumentFieldName.timestamp, descending: true)
            .getDocuments();

        if (querySnapshot != null && querySnapshot.documents != null){

          DogPostModel dogPostModel = DogPostModel.fromJson(querySnapshot.documents.first.data);
          dogPostModel.ownerUserModel = await getUserModelData(userId: dogPostModel.ownerUserId);
          dogPostModel.dogModel =  await getDogModelData(ownerId: dogPostModel.ownerUserId, dogId: dogPostModel.dogUserId);
          postModelList.add(dogPostModel);
        }
      }

      return postModelList;
    }


    return postModelList;
  }


  Future<List<InsightModel>> getBookmarkedInsightsModelData({@required List<dynamic> insightIdList})async{

    List<InsightModel> insightModelList = List<InsightModel>();

    if (insightIdList != null && insightIdList.length > 0){

      for (int index = 0; index < insightIdList.length; ++index){
        QuerySnapshot querySnapshot = await Firestore.instance
            .collectionGroup(FirestoreCollectionsNames.insights)
            .where(InsightDocumentFieldName.insight_id, isEqualTo: insightIdList[index])
            .orderBy(InsightDocumentFieldName.timestamp, descending: true)
            .limit(1).getDocuments();

        if (querySnapshot != null && querySnapshot.documents != null){

          InsightModel insightModel = InsightModel.fromJson(querySnapshot.documents.first.data);
          insightModel.userModel = await getUserModelData(userId: insightModel.userId);

          insightModelList.add(insightModel);
        }
      }
    }

    return insightModelList;
  }



  Future<DogModel> getDogModelData({@required String ownerId, @required String dogId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection(FirestoreCollectionsNames.users).document(ownerId).collection(FirestoreCollectionsNames.dogs).document(dogId).get();

    return DogModel.fromJson(documentSnapshot.data);
  }



  Future<UserModel> getUserModelData({@required String userId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(FirestoreCollectionsNames.users).document(userId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }

  void dispose(){

  }

}