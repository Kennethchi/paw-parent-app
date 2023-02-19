

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/profile/profile_bloc.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_bloc.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_bloc_provider.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_view.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/image_utils.dart';

class ProfileSettingsViewHandlers{



  Future<void> showProfileImageSelectOptionModal({@required BuildContext pageContext})async{


    ProfileSettingsBlocProvider _provider = ProfileSettingsBlocProvider.of(pageContext);
    ProfileSettingsBloc _bloc = _provider.bloc;
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

                    _bloc.profileImageFileBehaviorSubject.sink.add(File(imagePickedFile.path));

                    Navigator.of(context).pop();



                    _uploadAndUpdateProfileImage(pageContext: pageContext, profileImageFile: File(imagePickedFile.path));
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

                    _bloc.profileImageFileBehaviorSubject.sink.add(File(imagePickedFile.path));

                    Navigator.of(context).pop();

                    await _uploadAndUpdateProfileImage(pageContext: pageContext, profileImageFile: File(imagePickedFile.path));
                  }
                },
              ),

            ],

          );
        }
    );

  }



  Future<void> updateUserProfileNameModal({@required BuildContext pageContext}){


    ProfileSettingsBlocProvider _provider = ProfileSettingsBlocProvider.of(pageContext);
    ProfileSettingsBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;

    _provider.profileNameTextEditingController.text = _bloc.getCurrentUserModel.profileName;

    showDialog(
      context: pageContext,
      builder: (BuildContext context){
        return Center(
          child: Card(
            shadowColor: _themeData.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _provider.profileNameTextEditingController,
                maxLines: 1,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                  prefixIcon: Icon(Icons.person, color: _themeData.primaryColor,),
                  hintText: "Profile Name",
                  labelText: "Profile Name",
                  labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                  hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.2)
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  suffix: StreamBuilder<bool>(
                    stream: _bloc.showUpdateProfileNameButtonBehaviorSubject,
                    builder: (context, snapshot) {

                      return GestureDetector(
                        child: Text("save", style: TextStyle(color: snapshot.hasData && snapshot.data? _themeData.primaryColor: Colors.black26, fontWeight: FontWeight.bold),),
                        onTap: snapshot.hasData && snapshot.data? ()async{


                          BasicUI.showProgressDialog(pageContext: context, child: Center(child: DogLoaderWidget(),));

                          String profileNameText = _provider.profileNameTextEditingController.text.trim();

                          await _bloc.updateUserModelProfileData(userId: _bloc.getCurrentUserModel.userId, dataMap: {UsersDocumentFieldNames.profile_name: profileNameText});
                          await _bloc.updateUserOptimisedUserModelProfileData(userId: _bloc.getCurrentUserModel.userId, dataMap: {OptimisedUserChiledFieldNames.profile_name: profileNameText});

                          UserModel userModel = await _bloc.getUserModelData(userId: _bloc.getCurrentUserModel.userId);
                          _bloc.currentUserModelBehaviorSubject.add(userModel);

                          if (_provider.dynamicProfileBloc is ProfileBloc){
                            ProfileBloc profileBloc = _provider.dynamicProfileBloc;
                            profileBloc.profileUserModelBehaviorSubject.add(userModel);
                          }

                          Navigator.pop(context);
                          Navigator.pop(context);

                          BasicUI.showSnackBar(context: pageContext, message: "Profile Name Updated", textColor: _themeData.primaryColor);
                        }: null,
                      );
                    }
                  )
                ),
              ),

            ),
          ),
        );

      }
    );

  }




  Future<void> _uploadAndUpdateProfileImage({@required BuildContext pageContext, @required profileImageFile}){


    ProfileSettingsBlocProvider _provider = ProfileSettingsBlocProvider.of(pageContext);
    ProfileSettingsBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;


    BasicUI.showProgressDialog(pageContext: pageContext, child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DogLoaderWidget(),
        SizedBox(height: 50.0,),
        Text("Uploading Image in progress...", style: TextStyle(color: _themeData.primaryColor, fontSize: Theme.of(pageContext).textTheme.headline6.fontSize, fontWeight: FontWeight.bold),)
      ],
    ));

    _bloc.uploadFileToCloudStorage(
        currentUserId: _bloc.getCurrentUserModel.userId,
        file: profileImageFile,
        filename: Timestamp.now().microsecondsSinceEpoch.toString() + FileExtensions.jpg
    ).then((String imageDownloadUrl)async{


      if (imageDownloadUrl == null){

        Navigator.of(pageContext).pop();
        BasicUI.showSnackBar(context: pageContext, message: "An error occured during upload", textColor: CupertinoColors.destructiveRed,);
      }
      else{

        File compressedImageFile = await ImageUtils.getCompressedImageFile(imageFile: profileImageFile, minWidth: ImageResolutionOption.mediumWidth.toInt(), quality: ImageResolutionOption.mediumQuality);

        if (compressedImageFile == null){

          Navigator.of(pageContext).pop();
          BasicUI.showSnackBar(context: pageContext, message: "An error occured when processing image", textColor: CupertinoColors.destructiveRed,);
        }
        else{
          _bloc.uploadFileToCloudStorage(
              currentUserId: _bloc.getCurrentUserModel.userId,
              file: compressedImageFile,
              filename: Timestamp.now().microsecondsSinceEpoch.toString() + FileExtensions.jpg
          ).then((String imageThumbDownloadUrl)async{


            if (imageThumbDownloadUrl == null){

              Navigator.of(pageContext).pop();
              BasicUI.showSnackBar(context: pageContext, message: "An error occured during upload", textColor: CupertinoColors.destructiveRed,);
            }
            else{

              await _bloc.updateUserModelProfileData(userId: _bloc.getCurrentUserModel.userId, dataMap: {
                UsersDocumentFieldNames.profile_image: imageDownloadUrl,
                UsersDocumentFieldNames.profile_image_thumb: imageDownloadUrl
              });

              await _bloc.updateUserOptimisedUserModelProfileData(userId: _bloc.getCurrentUserModel.userId, dataMap: {
                OptimisedUserChiledFieldNames.thumb: imageThumbDownloadUrl
              });

              UserModel userModel = await _bloc.getUserModelData(userId: _bloc.getCurrentUserModel.userId);
              _bloc.currentUserModelBehaviorSubject.add(userModel);


              if (_provider.dynamicProfileBloc is ProfileBloc){
                ProfileBloc profileBloc = _provider.dynamicProfileBloc;
                profileBloc.profileUserModelBehaviorSubject.add(userModel);
              }

              Navigator.of(pageContext).pop();
              BasicUI.showSnackBar(context: pageContext, message: "Profile Image Updated", textColor: _themeData.primaryColor);

            }

          });
        }


      }

    });

  }




}