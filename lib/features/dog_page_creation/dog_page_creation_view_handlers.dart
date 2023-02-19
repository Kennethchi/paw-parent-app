

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/profile/profile_bloc.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/image_utils.dart';
import 'package:paw_parent_app/utils/string_utils.dart';

import 'dog_page_creation_bloc.dart';
import 'dog_page_creation_bloc_provider.dart';

class DogPageCreationViewHandlers{

  Future<void> showDogImageSelectOptionModal({@required BuildContext pageContext})async{


    DogPageCreationBlocProvider _provider = DogPageCreationBlocProvider.of(pageContext);
    DogPageCreationBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;

    ImagePicker imagePicker = ImagePicker();

    await showCupertinoModalPopup(
        context: pageContext,
        builder: (BuildContext context){

      return CupertinoActionSheet(
        title: Text("Select Profile Image"),
        actions: <Widget>[

          CupertinoActionSheetAction(

            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Take a Picture", style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                    ),),
                    SizedBox(width: 20.0,),
                    Icon(Icons.camera_alt)
                  ],
                )
            ),
            onPressed: ()async{

              PickedFile imagePickedFile = await imagePicker.getImage(
                  source: ImageSource.camera,
                  maxHeight: ImageResolutionOption.maxHeight,
                  maxWidth: ImageResolutionOption.maxWidth,
                  imageQuality: ImageResolutionOption.maxQuality
              );

              if (imagePickedFile.path != null){

                _bloc.dogProfileImageFileBehaviorSubject.sink.add(File(imagePickedFile.path));

                Navigator.of(context).pop();
              }

            },
          ),

          CupertinoActionSheetAction(
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Get From Gallery", style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                        fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                    ),),
                    SizedBox(width: 20.0,),
                    Icon(Icons.image)
                  ],
                )
            ),
            onPressed: ()async{

              PickedFile imagePickedFile = await imagePicker.getImage(
                  source: ImageSource.gallery,
                  maxHeight: ImageResolutionOption.maxHeight,
                  maxWidth: ImageResolutionOption.maxWidth,
                  imageQuality: ImageResolutionOption.maxQuality
              );

              if (imagePickedFile.path != null){

                _bloc.dogProfileImageFileBehaviorSubject.sink.add(File(imagePickedFile.path));

                Navigator.of(context).pop();
              }
            },
          ),

        ],

      );
    }
    );

  }


  Future<void> createDogPage({@required BuildContext pageContext}){


    DogPageCreationBlocProvider _provider = DogPageCreationBlocProvider.of(pageContext);
    DogPageCreationBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;

    String dogProfileName = StringUtils.toUpperCaseLower(_provider.dogProfileNameTextEditingController.text.trim());
    String dogUsername = StringUtils.removeAllSpaces(_provider.dogUsernameTextEditingController.text.trim()).toLowerCase();
    String dogAbout = _provider.dogAboutTextEditingController.text.trim();

    RegExp regExp = new RegExp(r"^[A-Za-z0-9_]+$");

    if (dogProfileName.isEmpty || dogUsername.isEmpty || dogAbout.isEmpty){

      BasicUI.showSnackBar(context: pageContext, message: "Some Fields are Empty", textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 1));
    }else if(_bloc.getProfileImageFile == null){

      BasicUI.showSnackBar(context: pageContext, message: "Select a Profile Image", textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 1));
    }
    else if (regExp.hasMatch(dogUsername) == false){
      BasicUI.showSnackBar(context: pageContext, message: "Username can only contain any of the following" + "\n" + "A-Z, a-z, 0-9, _",
          textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 2));
    }
    else{

      BasicUI.showProgressDialog(pageContext: pageContext, child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DogLoaderWidget(),
          SizedBox(height: 50.0,),
          Text("Creating Page in progress...", style: TextStyle(color: _themeData.primaryColor, fontSize: Theme.of(pageContext).textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),)
        ],
      ));


      _bloc.checkIfUsernameExists(dogUsername: dogUsername, ownerUserId: _bloc.getCurrentUserId).then((bool usernameExits){
        if (usernameExits){
          Navigator.of(pageContext).pop();

          BasicUI.showSnackBar(context: pageContext, message: "Username is already taken", textColor: CupertinoColors.destructiveRed,);
        }
        else{

          _bloc.uploadFileToCloudStorage(
              currentUserId: _bloc.getCurrentUserId,
              file: _bloc.getProfileImageFile,
              filename: Timestamp.now().microsecondsSinceEpoch.toString() + FileExtensions.jpg
          ).then((String imageDownloadUrl)async{


            if (imageDownloadUrl == null){

              Navigator.of(pageContext).pop();
              BasicUI.showSnackBar(context: pageContext, message: "An error occured during upload", textColor: CupertinoColors.destructiveRed,);
            }
            else{

              File compressedImageFile = await ImageUtils.getCompressedImageFile(imageFile: _bloc.getProfileImageFile, minWidth: ImageResolutionOption.mediumWidth.toInt(), quality: ImageResolutionOption.mediumQuality);

              if (compressedImageFile == null){

                Navigator.of(pageContext).pop();
                BasicUI.showSnackBar(context: pageContext, message: "An error occured when processing image", textColor: CupertinoColors.destructiveRed,);
              }
              else{
                _bloc.uploadFileToCloudStorage(
                    currentUserId: _bloc.getCurrentUserId,
                    file: compressedImageFile,
                    filename: Timestamp.now().microsecondsSinceEpoch.toString() + FileExtensions.jpg
                ).then((String imageThumbDownloadUrl){


                  if (imageThumbDownloadUrl == null){

                    Navigator.of(pageContext).pop();
                    BasicUI.showSnackBar(context: pageContext, message: "An error occured during upload", textColor: CupertinoColors.destructiveRed,);
                  }
                  else{

                    DogModel dogModel = DogModel(
                        profileName: dogProfileName,
                        username: dogUsername,
                        userId: dogUsername,
                        profileImage: imageDownloadUrl,
                        profileImageThumb: imageThumbDownloadUrl,
                        creationTimestamp: Timestamp.now(),
                        dogBreed: _bloc.getDogBreed,
                        genderType: _bloc.getGenderType,
                        isVaccinated: _bloc.getIsDogVaccinated,
                        isMixedBreed: _bloc.getIsDogMixedBreed,
                        about: dogAbout,
                        ownerUserId: _bloc.getCurrentUserId,
                      dateOfBirth: Timestamp.fromDate(_bloc.getDateOfBirth),
                      adoptible: _bloc.getCurrentUserModel.userType == UserType.adoption_center? true: false,
                      dogBehaviorsList: _bloc.getDogBehaviorsList
                    );

                    _bloc.addDogProfileData(currentUserId: _bloc.getCurrentUserId, dogModel: dogModel).then((String dogUserId){

                      _bloc.increaseNumberOfDogsCount(ownerUserId: _bloc.getCurrentUserId);

                      _bloc.addOptimisedDogModelData(currentUserId: _bloc.getCurrentUserId, dogUserId: dogUserId, optimisedDogModel: OptimisedDogModel(
                          profileName: dogProfileName,
                          username: dogUsername,
                          thumb: imageThumbDownloadUrl
                      ));

                      _bloc.updateCurrentUserDogs(currentUserId: _bloc.getCurrentUserId, dogUserId: dogUserId).then((value){

                        _bloc.showCreatePageButtonBehaviorSubject.add(false);

                        Navigator.pop(pageContext);
                        BasicUI.showSnackBar(context: pageContext, message: "Dog Page Successfully Created", textColor:_themeData.primaryColor, duration: Duration(seconds: 2));



                        // refreshes post screen of profile bloc
                        if (_provider.dynamicBloc != null && _provider.dynamicBloc is ProfileBloc){

                          ProfileBloc profileBloc = _provider.dynamicBloc;

                          profileBloc.loadDogs(profileUserId: _bloc.getCurrentUserId, dogQueryLimit: profileBloc.getDogsQueryLimit);
                        }


                        Timer(Duration(seconds: 2), (){
                          Navigator.pop(pageContext);
                        });

                      });

                    });
                  }

                });
              }


            }

          });



        }
      });

    }

  }

}