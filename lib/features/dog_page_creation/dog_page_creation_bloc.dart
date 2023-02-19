
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/constants/dog_breeds_list.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:paw_parent_app/services/server_api.dart';
import 'package:rxdart/rxdart.dart';

class DogPageCreationBloc{


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



  File _profileImageFile;
  File get getProfileImageFile => _profileImageFile;
  set setProfileImageFile(File profileImageFile) {
    _profileImageFile = profileImageFile;
  }

  String _dogBreed;
  String get getDogBreed => _dogBreed;
  set setDogBreed(String dogBreed) {
    _dogBreed = dogBreed;
  }

  DateTime _dateOfBirth;
  DateTime get getDateOfBirth => _dateOfBirth;
  set setDateOfBirth(DateTime dateOfBirth) {
    _dateOfBirth = dateOfBirth;
  }

  String _genderType;
  String get getGenderType => _genderType;
  set setGenderType(String genderType) {
    _genderType = genderType;
  }

  List _dogBehaviorsList;
  List get getDogBehaviorsList => _dogBehaviorsList;
  set setDogBehaviorsList(List dogBehaviorsList) {
    _dogBehaviorsList = dogBehaviorsList;
  }


  bool _isDogVaccinated;
  bool get getIsDogVaccinated => _isDogVaccinated;
  set setIsDogVaccinated(bool isDogVaccinated) {
    _isDogVaccinated = isDogVaccinated;
  }

  bool _isDogMixedBreed;
  bool get getIsDogMixedBreed => _isDogMixedBreed;
  set setIsDogMixedBreed(bool isDogMixedBreed) {
    _isDogMixedBreed = isDogMixedBreed;
  }

  BehaviorSubject<String> dogBreedBehaviorSubject = BehaviorSubject<String>();
  BehaviorSubject<bool> isDogVaccinatedBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<bool> isDogMixedBreedBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<File> dogProfileImageFileBehaviorSubject = BehaviorSubject<File>();
  BehaviorSubject<bool> showCreatePageButtonBehaviorSubject = BehaviorSubject<bool>();
  BehaviorSubject<DateTime> dateOfBirthBehaviorSubject = BehaviorSubject<DateTime>();
  BehaviorSubject<String> genderTypeBehaviorSubject = BehaviorSubject<String>();
  BehaviorSubject<List<String>> dogBehaviorsListBehaviorSubject = BehaviorSubject<List<String>>();


  DogPageCreationBloc({@required UserModel currentUserModel}){

    setCurrentUserModel = currentUserModel;

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){
      setCurrentUserId = firebaseUser.uid;
    });


    dogBreedBehaviorSubject.sink.add(get_dog_breeds_list.first);
    isDogVaccinatedBehaviorSubject.add(false);
    isDogMixedBreedBehaviorSubject.add(false);
    dateOfBirthBehaviorSubject.add(DateTime.fromMillisecondsSinceEpoch(0));
    genderTypeBehaviorSubject.add(GenderType.male);
    dogBehaviorsListBehaviorSubject.add(List<String>());


    dogBreedBehaviorSubject.stream.listen((String dogBreed) {
      setDogBreed = dogBreed;
    });

    isDogVaccinatedBehaviorSubject.listen((bool isDogVaccinated) {
      setIsDogVaccinated = isDogVaccinated;
    });

    isDogMixedBreedBehaviorSubject.listen((bool isDogMixedBreed) {
      setIsDogMixedBreed = isDogMixedBreed;
    });

    dogProfileImageFileBehaviorSubject.listen((File profileImageFile){
      setProfileImageFile = profileImageFile;
    });

    dateOfBirthBehaviorSubject.listen((DateTime dateTime) {
      setDateOfBirth = dateTime;
    });

    genderTypeBehaviorSubject.listen((String genderType) {
      setGenderType = genderType;
    });

    dogBehaviorsListBehaviorSubject.listen((List<String> dogBehaviorsList) {
      setDogBehaviorsList = dogBehaviorsList;
    });

    showCreatePageButtonBehaviorSubject.sink.add(true);
  }


  Future<String> uploadFileToCloudStorage({@required String currentUserId, @required File file, @required String filename})async{

    return await ServerApi.uploadFileToCloudStorage(file: file, filename: filename, storagePath: "users/${currentUserId}/dogs" );
  }


  Future<bool> checkIfUsernameExists({@required String dogUsername, @required ownerUserId})async{

    QuerySnapshot querySnapshot = await Firestore.instance.collection("users").document(ownerUserId).collection("dogs").where(DogsDocumentFieldNames.username, isEqualTo: dogUsername).limit(1).getDocuments();
    if (querySnapshot.documents != null && querySnapshot.documents.length > 0){
      return true;
    }
    else{
      return false;
    }
  }


  Future<String> addDogProfileData({@required String currentUserId, @required DogModel dogModel})async{

    await Firestore.instance.collection("users").document(currentUserId).collection("dogs").document().setData(dogModel.toJson());

    QuerySnapshot querySnapshot = await Firestore.instance.collection("users").document(currentUserId).collection("dogs").where(DogsDocumentFieldNames.username, isEqualTo: dogModel.username).limit(1).getDocuments();

    String dogUserId = querySnapshot.documents.first.documentID;

    await Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId).collection(FirestoreCollectionsNames.dogs).document(dogUserId).updateData({
      DogsDocumentFieldNames.user_id: dogUserId
    });

    return dogUserId;
  }

  Future<void> addOptimisedDogModelData({@required currentUserId, @required String dogUserId, @required OptimisedDogModel optimisedDogModel})async{

    await FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(currentUserId)
        .child(RealtimeDatabaseChildNames.dogs)
        .child(dogUserId)
        .child(RealtimeDatabaseChildNames.dog_profile)
        .set(optimisedDogModel.toJson());

  }


  Future<void> updateCurrentUserDogs({@required String currentUserId, @required String dogUserId})async{

    DocumentReference documentReference = Firestore.instance.collection(FirestoreCollectionsNames.users).document(currentUserId);

    documentReference.firestore.runTransaction((Transaction transaction)async{

      await transaction.update(documentReference, {UsersDocumentFieldNames.dogs_list: FieldValue.arrayUnion([dogUserId])});
    });
  }



  Future<void> increaseNumberOfDogsCount({ @required String ownerUserId})async{

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference()
        .child(RealtimeDatabaseChildNames.users)
        .child(ownerUserId)
        .child(RealtimeDatabaseChildNames.user_profile)
        .child(OptimisedUserChiledFieldNames.num_dogs);

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

    dogBreedBehaviorSubject?.close();
  }

}