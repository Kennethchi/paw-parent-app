import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post_bloc.dart';
import 'package:paw_parent_app/features/dog_page/dog_page_bloc.dart';
import 'package:paw_parent_app/main.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_dog_post_model.dart';
import 'package:paw_parent_app/services/server_api.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/image_utils.dart';

import 'create_dog_post_bloc_provider.dart';



class CreateDogPostViewHandlers {


  Future<File> getImageFromGallery() async{

    ImagePicker imagePicker = ImagePicker();

    File imageFile = File((await imagePicker.getImage(source: ImageSource.gallery,
        maxWidth: ImageResolutionOption.maxWidth,
        maxHeight: ImageResolutionOption.maxHeight,
        imageQuality: ImageResolutionOption.maxQuality
    )).path);
    return imageFile;
  }

  Future<File> getImageFromCamera() async{

    ImagePicker imagePicker = ImagePicker();

    File imageFile = File((await imagePicker.getImage(source: ImageSource.camera,
        maxWidth: ImageResolutionOption.maxWidth,
        maxHeight: ImageResolutionOption.maxHeight,
        imageQuality: ImageResolutionOption.maxQuality
    )).path);
    return imageFile;
  }





  Future<void> showChangeSelectedUploadImageOptionModal({@required BuildContext pageContext, @required int imageToChangeIndexInList})async{


    CreateDogPostBloc _bloc = CreateDogPostBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenwidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;


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
                        Text("Take a Snapshot", style: TextStyle(
                            color: CupertinoTheme.of(context).primaryColor,
                            fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                        ),),
                        SizedBox(width: 20.0,),
                        Icon(Icons.camera_alt)
                      ],
                    )
                ),
                onPressed: ()async{

                  File imageFile = await getImageFromCamera();

                  _bloc.getPostImagesPaths.remove(_bloc.getPostImagesPaths.removeAt(imageToChangeIndexInList));
                  _bloc.getPostImagesPaths.insert(imageToChangeIndexInList, imageFile.path);
                  _bloc.imagesPathBehaviorSubject.add(_bloc.getPostImagesPaths);


                  if (_bloc.getPostImagesPaths.length == AppDataLimits.numberOfImagesPerPost){
                    _bloc.isPostImagesLimitReachedBehaviorSubject.add(true);
                  }

                  Navigator.pop(context);
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


                  File imageFile = await getImageFromGallery();

                  _bloc.getPostImagesPaths.remove(_bloc.getPostImagesPaths.removeAt(imageToChangeIndexInList));
                  _bloc.getPostImagesPaths.insert(imageToChangeIndexInList, imageFile.path);
                  _bloc.imagesPathBehaviorSubject.add(_bloc.getPostImagesPaths);


                  if (_bloc.getPostImagesPaths.length == AppDataLimits.numberOfImagesPerPost){
                    _bloc.isPostImagesLimitReachedBehaviorSubject.add(true);
                  }

                  Navigator.pop(context);
                },
              ),


              CupertinoActionSheetAction(
                child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Remove Image", style: TextStyle(
                            color: CupertinoTheme.of(context).primaryColor,
                            fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                        ),),
                        SizedBox(width: 20.0,),
                        Icon(Icons.delete, color: CupertinoColors.destructiveRed,)
                      ],
                    )
                ),
                onPressed: ()async{

                  _bloc.getPostImagesPaths.removeAt(imageToChangeIndexInList);
                  _bloc.imagesPathBehaviorSubject.add(_bloc.getPostImagesPaths);


                  if (_bloc.getPostImagesPaths.length < AppDataLimits.numberOfImagesPerPost){
                    _bloc.isPostImagesLimitReachedBehaviorSubject.add(false);
                  }

                  if (_bloc.getPostImagesPaths.length <= 0){
                    _bloc.imagesPathBehaviorSubject.add(List<String>());
                  }

                  Navigator.pop(context);
                },
              )

            ],

          );
        }
    );

  }



  Future<void> showUploadImageOptionModal({BuildContext pageContext}) async{

    CreateDogPostBloc _bloc = CreateDogPostBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenwidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;


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
                    Text("Take a Snapshot", style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                        fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                    ),),
                    SizedBox(width: 20.0,),
                    Icon(Icons.camera_alt)
                  ],
                )
            ),
            onPressed: ()async{

              File imageFile = await getImageFromCamera();

              _bloc.getPostImagesPaths.add(imageFile.path);
              _bloc.imagesPathBehaviorSubject.add(_bloc.getPostImagesPaths);

              CreateDogPostBlocProvider.of(pageContext).imagesSwiperController.move(_bloc.getPostImagesPaths.length - 1);

              if (_bloc.getPostImagesPaths.length == AppDataLimits.numberOfImagesPerPost){
                _bloc.isPostImagesLimitReachedBehaviorSubject.add(true);
              }

              Navigator.pop(context);
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


              File imageFile = await getImageFromGallery();

              _bloc.getPostImagesPaths.add(imageFile.path);
              _bloc.imagesPathBehaviorSubject.add(_bloc.getPostImagesPaths);

              CreateDogPostBlocProvider.of(pageContext).imagesSwiperController.move(_bloc.getPostImagesPaths.length - 1);


              if (_bloc.getPostImagesPaths.length == AppDataLimits.numberOfImagesPerPost){
                _bloc.isPostImagesLimitReachedBehaviorSubject.add(true);
              }

              Navigator.pop(context);
            },
          ),

        ],

      );
    }
    );

  }





  Future<void> createPost({@required BuildContext pageContext})async{


    CreateDogPostBlocProvider _provider = CreateDogPostBlocProvider.of(pageContext);
    CreateDogPostBloc _bloc = CreateDogPostBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;



    BasicUI.showProgressDialog(pageContext: pageContext, child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DogLoaderWidget(),
        SizedBox(height: 50.0,),
        Text("Creating Post...", style: TextStyle(color: _themeData.primaryColor, fontSize: Theme.of(pageContext).textTheme.headline6.fontSize, fontWeight: FontWeight.bold),)
      ],
    ));



    if (_bloc.getPostImagesPaths != null && _bloc.getPostImagesPaths.length > 0){

      List<String> postImagesUrlList = List<String>();
      List<String> postImagesThumbsUrlList = List<String>();

      bool uploadError = false;

      for (int index = 0; index < _bloc.getPostImagesPaths.length; ++index){


        File imageFile = File(_bloc.getPostImagesPaths[index]);

        File imageThumbFile = await ImageUtils.getCompressedImageFile(
            imageFile: imageFile,
            minWidth: ImageResolutionOption.mediumWidth.toInt(),
            quality: ImageResolutionOption.mediumQuality
        );


        String downloadImageUrl = await ServerApi.uploadFileToCloudStorage(
            file: imageFile, filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            storagePath: "users/${_bloc.getUserModel.userId}/dogs/${_bloc.getDogModel.userId};");

        String downloadImageThumbUrl = await ServerApi.uploadFileToCloudStorage(
            file: imageThumbFile, filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            storagePath: "users/${_bloc.getUserModel.userId}/dogs/${_bloc.getDogModel.userId};");


        if (downloadImageUrl == null || downloadImageThumbUrl == null){
          Navigator.of(pageContext).pop();
          BasicUI.showSnackBar(context: pageContext, message: "An error occured during upload", textColor: CupertinoColors.destructiveRed);

          uploadError = true;
          break;
        }
        else{

          postImagesUrlList.add(downloadImageUrl);
          postImagesThumbsUrlList.add(downloadImageThumbUrl);
        }

      }


      if (uploadError){

        Navigator.of(pageContext).pop();
        BasicUI.showSnackBar(context: pageContext, message: "An error occured during upload", textColor: CupertinoColors.destructiveRed);

        return;
      }
      else{


        ImageModel imageModel = ImageModel(
          imagesUrl: postImagesUrlList,
          imagesThumbsUrl: postImagesThumbsUrlList,
        );

        DogPostModel dogPostModel = DogPostModel(
            postType: _bloc.getPostType,
            postData: imageModel.toJson(),
            postCaption: _provider.postTextEditingController.text,
            timestamp: Timestamp.now(),
            dogUserId: _bloc.getDogModel.userId,
            ownerUserId: _bloc.getUserModel.userId
        );


        _bloc.addDogPostData(dogUserId: _bloc.getDogModel.userId, ownerUserId: _bloc.getUserModel.userId, dogPostModel: dogPostModel).then((String postId){

          _bloc.increaseDogPostsCount(dogUserId: _bloc.getDogModel.userId, ownerUserId: _bloc.getUserModel.userId);

          _bloc.addDogOptimisedPostData(
              dogUserId: _bloc.getDogModel.userId,
              optimisedDogPostModel: OptimisedDogPostModel(postId: postId),
              postId: postId
          );
        });


        Navigator.of(pageContext).pop();
        BasicUI.showSnackBar(
            context: pageContext,
            message: "Post was Published", textColor: _themeData.primaryColor
        );


        // refreshes post screen of profile bloc
        if (_provider.dynamicBloc != null && _provider.dynamicBloc is DogPageBloc){

          DogPageBloc dogPageBloc = _provider.dynamicBloc;


          dogPageBloc.loadPosts(
            dogId: dogPageBloc.getDogModel.userId,
              userId: dogPageBloc.getCurrentUserModel.userId,
            dogQueryLimit: dogPageBloc.getPostsQueryLimit
          );

        }


        Timer(Duration(seconds: 2), (){
          Navigator.of(pageContext).pop();
        });


        // Add show button to false
        _bloc.showCreatePostButtonBehaviorSubject.add(false);
      }

    }
    else{

      Navigator.of(pageContext).pop();
      BasicUI.showSnackBar(context: pageContext, message: "No Images Selected", textColor: CupertinoColors.destructiveRed);
    }


  }





}



