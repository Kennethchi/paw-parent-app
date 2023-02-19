


import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/create_insight_post/create_insight_post_bloc_provider.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_insight_model.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/image_utils.dart';
import 'package:paw_parent_app/utils/string_utils.dart';

import 'create_insight_post_bloc.dart';

class CreateInsightPostViewHandlers{



  Future<void> showInsightImageSelectOptionModal({@required BuildContext pageContext})async{


    CreateInsightPostBlocProvider _provider = CreateInsightPostBlocProvider.of(pageContext);
    CreateInsightPostBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;

    ImagePicker imagePicker = ImagePicker();

    await showCupertinoModalPopup(
        context: pageContext,
        builder: (BuildContext context){

          return CupertinoActionSheet(
            title: Text("Select Insight Image"),
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

                    _bloc.insightImageFileBehaviorSubject.sink.add(File(imagePickedFile.path));

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

                    _bloc.insightImageFileBehaviorSubject.sink.add(File(imagePickedFile.path));

                    Navigator.of(context).pop();
                  }
                },
              ),

            ],

          );
        }
    );

  }


  Future<void> createInsight({@required BuildContext pageContext}){

    CreateInsightPostBlocProvider _provider = CreateInsightPostBlocProvider.of(pageContext);
    CreateInsightPostBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;

    String title = StringUtils.toUpperCaseLower(_provider.titleTextEditingController.text.trim());
    String content = _provider.contentTextEditingController.text;


    if (title.isEmpty || content.trim().isEmpty){

      BasicUI.showSnackBar(context: pageContext, message: "Some Fields are Empty", textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 1));
    }else if(_bloc.getInsightImageFile == null){

      BasicUI.showSnackBar(context: pageContext, message: "Select a Insight Image", textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 1));
    }
    else{

      BasicUI.showProgressDialog(pageContext: pageContext, child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DogLoaderWidget(),
          SizedBox(height: 50.0,),
          Text("Creating Insight in progress...", style: TextStyle(color: _themeData.primaryColor, fontSize: Theme.of(pageContext).textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),)
        ],
      ));


      _bloc.uploadFileToCloudStorage(
          currentUserId: _bloc.getCurrentUserId,
          file: _bloc.getInsightImageFile,
          filename: Timestamp.now().microsecondsSinceEpoch.toString() + FileExtensions.jpg
      ).then((String imageDownloadUrl)async{


        if (imageDownloadUrl == null){

          Navigator.of(pageContext).pop();
          BasicUI.showSnackBar(context: pageContext, message: "An error occured during upload", textColor: CupertinoColors.destructiveRed,);
        }
        else{

          File compressedImageFile = await ImageUtils.getCompressedImageFile(imageFile: _bloc.getInsightImageFile, minWidth: ImageResolutionOption.mediumWidth.toInt(), quality: ImageResolutionOption.mediumQuality);

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

                ImageModel imageModel = ImageModel(
                  imagesUrl: [imageDownloadUrl],
                  imagesThumbsUrl: [imageThumbDownloadUrl],
                );

                InsightModel insightModel = InsightModel(
                    insightType: _bloc.getInsightType,
                    insightData: imageModel.toJson(),
                    insightTitle: title,
                    insightContent: content,
                    tags: _bloc.getInsightTagsList,
                    timestamp: Timestamp.now(),
                    userId: _bloc.getCurrentUserId
                );

                _bloc.addInisghtModelData(currentUserId: _bloc.getCurrentUserId, insightModel: insightModel).then((String insightId){

                  _bloc.increaseNumberOfInsightsCount(currentUserId: _bloc.getCurrentUserId);

                  _bloc.addTagsData(tagsList: _bloc.getInsightTagsList);

                  _bloc.addOptimisedInsightModelData(currentUserId: _bloc.getCurrentUserId, insightId: insightId, optimisedInsightModel: OptimisedInsightModel(
                      insightId: insightId
                  ));

                  _bloc.showCreateInsightButtonBehaviorSubject.add(false);

                  Navigator.pop(pageContext);
                  BasicUI.showSnackBar(context: pageContext, message: "Insight Successfully Created", textColor:_themeData.primaryColor, duration: Duration(seconds: 4));


                  Timer(Duration(seconds: 4), (){
                    Navigator.pop(pageContext);
                  });

                });
              }

            });
          }

        }

      });

    }

  }

}