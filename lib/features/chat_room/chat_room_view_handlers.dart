
import 'dart:ui';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/resources/models/message_image_model.dart';
import 'package:paw_parent_app/resources/models/message_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_chat_model.dart';
import 'package:paw_parent_app/ui/image_viewer/image_viewer.dart';

import 'chat_room_bloc.dart';
import 'chat_room_bloc_provider.dart';
import 'chat_room_widgets.dart';

class ChatRoomViewHandlers{


  // When the text in text field change. we set the current user istyping value based on whether the field is empty or not
  void onTextChange({@required BuildContext context, @required String text}){

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;

    _bloc.addTextToStream(text: text);

    if (text.trim().length > 0){
      _bloc.addCurrentUserTypingStatus(currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId, isTyping: true);
    }
    else{
      _bloc.addCurrentUserTypingStatus(currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId, isTyping: false);
    }


  }



  Future<void> sendMessageText({@required BuildContext context, @required String cleanedMessage}) async{

    ChatRoomBlocProvider _provider = ChatRoomBlocProvider.of(context);
    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    TextEditingController textEditingController = ChatRoomBlocProvider.of(context).textEditingController;


    MessageModel newMessageModel = MessageModel(
        message_text: cleanedMessage,
        sender_id: _bloc.getCurrentUserModel.userId,
        receiver_id: _bloc.getChatUserModel.userId,
        seen: false,
        timestamp: Timestamp.now(),
        message_type: MessageType.text,
        message_data: null,
        downloadable: null,
        referred_message: _bloc.getReferredMessageModel != null? _bloc.getReferredMessageModel.toJson(): null,
      deleteUniqueId: Timestamp.now().microsecondsSinceEpoch.toString(),
    );


    // For chat user receving the message, the current user info is found also here
    OptimisedChatModel chatUserChattersModel = OptimisedChatModel(
      chat_user_id: _bloc.getCurrentUserModel.userId,
      sender_id: _bloc.getCurrentUserModel.userId,
      t: Timestamp.now().millisecondsSinceEpoch,
      text: cleanedMessage,
      seen: false,
      tp: false,
      msg_type: MessageType.text,

      name: _bloc.getCurrentUserModel.profileName,
      username: _bloc.getCurrentUserModel.username,
      thumb: _bloc.getCurrentUserModel.profileImageThumb
    );


    // For The current user sending the message, the chat user info is found also here
    OptimisedChatModel currentUserChattersModel = OptimisedChatModel(
      chat_user_id: _bloc.getChatUserModel.userId,
      sender_id: _bloc.getCurrentUserModel.userId,
      t: Timestamp.now().millisecondsSinceEpoch,
      text: cleanedMessage,
      seen: false,
      tp: false,
      msg_type: MessageType.text,

      name: _bloc.getChatUserModel.profileName,
      username: _bloc.getChatUserModel.username,
      thumb: _bloc.getChatUserModel.profileImageThumb
    );


    // add message to firestore and chats to realtime database and notification to chatUser notifications in realtime database
    _bloc.addMessageData(messageModel: newMessageModel, currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId).then((String messageId){

      _bloc.setChatUserHasNewMessages(chatUserId: _bloc.getChatUserModel.userId);

      if (messageId != null){
        _bloc.setCurrentUserSentMessageState(
            messageState: MessageState.sent, messageId: messageId, currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId
        );
      }
    });


    /*
    _bloc.addNotificationData(
      chatUserId: _bloc.getChatUserModel.userId,
      optimisedNotificationModel: OptimisedNotificationModel(
          from: _bloc.getCurrentUserModel.userId,
          n_type: NotificationType.msg,
          t: Timestamp.now().millisecondsSinceEpoch
      ),
    );
     */

    _bloc.addChatsData(chatUserChatterModel: chatUserChattersModel, currentUserChatterModel: currentUserChattersModel);


    // clears textfield
    textEditingController.clear();

    // when text controller is cleared, set istyping to 0
    _bloc.addCurrentUserTypingStatus(currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId, isTyping: false);

    // adds null text to stream after text being sent
    _bloc.addTextToStream(text: null);

    _provider.scrollController.jumpTo(_provider.scrollController.position.minScrollExtent);

    _bloc.addReferredMessageModelToStream(null);
  }



  static void onChangeAppLifecycleState({@required AppLifecycleState state, @required ChatRoomBloc bloc}){

    switch(state){
      case AppLifecycleState.resumed:
        bloc.getLoadMessagesListQuerySnapshotStreamSubscription?.resume();
        bloc.getLoadMoreMessagesListQuerySnapshotStreamSubscription?.resume();
        break;
      case AppLifecycleState.inactive:

        bloc.addCurrentUserTypingStatus(currentUserId: bloc.getCurrentUserModel.userId, chatUserId: bloc.getChatUserModel.userId, isTyping: false);
        break;
      case AppLifecycleState.paused:

        bloc.getLoadMessagesListQuerySnapshotStreamSubscription?.pause();
        bloc.getLoadMoreMessagesListQuerySnapshotStreamSubscription?.pause();

        bloc.addCurrentUserTypingStatus(currentUserId: bloc.getCurrentUserModel.userId, chatUserId: bloc.getChatUserModel.userId, isTyping: false);
        break;
      case AppLifecycleState.detached:

        bloc.addCurrentUserTypingStatus(currentUserId: bloc.getCurrentUserModel.userId, chatUserId: bloc.getChatUserModel.userId, isTyping: false);
        break;
      default:
        break;
    }
  }


  Future<File> getVideoFromGallery() async{
    File videoFile = await ImagePicker.pickVideo(source: ImageSource.gallery);
    return videoFile;
  }

  Future<File> getVideoFromCamera() async{
    File videoFile = await ImagePicker.pickVideo(source: ImageSource.camera);

    return videoFile;
  }


  Future<File> getImageFromGallery() async{
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: ImageResolutionOption.maxWidth.toDouble(),
        maxHeight: ImageResolutionOption.maxWidth.toDouble(),
        imageQuality: ImageResolutionOption.maxQuality
    );

    return imageFile;
  }

  Future<File> getImageFromCamera() async{
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: ImageResolutionOption.maxWidth.toDouble(),
        maxHeight: ImageResolutionOption.maxWidth.toDouble(),
        imageQuality: ImageResolutionOption.maxQuality
    );
    return imageFile;
  }





  Widget getMessageTypeWidget({@required BuildContext chatContext, @required MessageModel messageModel}){

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(chatContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(chatContext);
    double screenwidth = MediaQuery.of(chatContext).size.width;
    double screenHeight = MediaQuery.of(chatContext).size.height;
    double scaleFactor = 0.125;



    switch(messageModel.message_type){

      case MessageType.text:
        return MessageTextWidget(messageModel: messageModel);
      case MessageType.image:
        return MessageImageWidget(messageModel: messageModel);
      case MessageType.video:
        return Container();
        //return MessageVideoWidget(messageModel: messageModel);
      case MessageType.audio:
        return Container();
        //return MessageAudioWidget(messageModel: messageModel);

      default:
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * scaleFactor * 0.25,
              horizontal: screenwidth * scaleFactor
          ),
          child: Center(
            child: Text("No Data Found", style: TextStyle(
              fontSize: Theme.of(chatContext).textTheme.title.fontSize,
              fontWeight: FontWeight.bold,
              color: messageModel.sender_id == _bloc.getCurrentUserModel.userId? Colors.white: _themeData.primaryColor,
            ),),
          ),
        );

    }

  }



  Widget getMessageImagePreviewWidget({@required BuildContext context, @required MessageModel messageModel}){


    MessageImageModel messageImageModel = MessageImageModel.fromJson(messageModel.message_data);

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double borderRadius = screenWidth * scaleFactor * 0.33;

    double imagePadding  =  screenWidth * scaleFactor * scaleFactor * 0.25;


    if (messageImageModel.imagesThumbsUrl.length == 1){
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[0],),
                fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(borderRadius)
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: (){

              Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (BuildContext context){
                      return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: 0);
                    },
                  )
              );


            },
          ),
        ),
      );
    }else if(messageImageModel.imagesThumbsUrl.length == 2){
      return Row(
        children: <Widget>[

          for (int index = 0; index < 2; ++index)

            Flexible(
              child: Padding(
                padding: EdgeInsets.all(imagePadding),
                child: Container(

                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index],),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(borderRadius)
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(borderRadius),
                      onTap: (){

                        Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (BuildContext context){
                                return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index);
                              },
                            )
                        );

                      },
                    ),
                  ),
                ),
              ),
            ),

        ],
      );
    }
    else if (messageImageModel.imagesThumbsUrl.length == 3){

      return Column(
        children: <Widget>[

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                for (int index = 0; index < 2; ++index)

                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index],),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(borderRadius)
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: (){

                                Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index);
                                      },
                                    )
                                );
                              },
                            ),
                          ),
                        )
                    ),
                  ),


              ],
            ),
          ),

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(imagePadding),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[2],),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(borderRadius)
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(borderRadius),
                          onTap: (){

                            Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (BuildContext context){
                                    return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: 2);
                                  },
                                )
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      );
    }
    else if(messageImageModel.imagesThumbsUrl.length >= 4){


      return Column(
        children: <Widget>[

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                for (int index = 0; index < 2; ++index)

                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index],),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(borderRadius)
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: (){

                                Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index);
                                      },
                                    )
                                );

                              },
                            ),
                          ),
                        )
                    ),
                  ),

              ],
            ),
          ),

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                for (int index = 2; index < 4; ++index)

                  Container(
                    child: messageImageModel.imagesThumbsUrl.length > 4 && index == 3? Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: Container(
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index]),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: (){

                                Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index);
                                      },
                                    )
                                );

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  color: _themeData.primaryColor.withOpacity(0.3),
                                ),
                                child: Center(
                                  child: Text("+ ${messageImageModel.imagesThumbsUrl.length - 4}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context).textTheme.headline.fontSize,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ): Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index]),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(borderRadius)
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: (){

                                Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index);
                                      },
                                    )
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ) ,
                  ),

              ],
            ),
          )

        ],
      );

    }
    else{

      return Container(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[0],),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(borderRadius)
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: (){

                  Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (BuildContext context){
                          return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: 0);
                        },
                      )
                  );
                },
              ),
            ),
          )
      );
    }



  }







  /*
  Widget getMessageVideoPreviewWidget({@required BuildContext context, @required MessageModel messageModel}){

    MessageVideoModel messageVideoModel = MessageVideoModel.fromJson(messageModel.message_data);

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double borderRadius = screenWidth * scaleFactor * 0.33;

    double imagePadding  =  screenWidth * scaleFactor * scaleFactor * 0.25;


    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(messageVideoModel.videoThumb,),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),

          onTap: (){


            Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context){
                    return VideoViewer(videoUrl: messageVideoModel.videoUrl, videoDownloadable: messageModel.downloadable, videoImageUrl: messageVideoModel.videoImage, );
                  },
                )
            );

          },

          child: messageModel.downloadable != null && messageModel.downloadable? Container(

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.eye, color: Colors.white),
                  SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
                  Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
            ),

          ): Container(
            child: Center(
              child: Icon(Icons.play_arrow, color: _themeData.primaryColor,),
            ),
          ),
        ),
      ),
    );

  }


  */




/*
  Widget getMessageAudioPreviewWidget({@required BuildContext context, @required MessageModel messageModel}){

    MessageAudioModel messageAudioModel = MessageAudioModel.fromJson(messageModel.message_data);

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double borderRadius = screenWidth * scaleFactor * 0.33;

    double imagePadding  =  screenWidth * scaleFactor * scaleFactor * 0.25;



    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          image: messageAudioModel.audioThumb != null? DecorationImage(
              image: CachedNetworkImageProvider(messageAudioModel.audioThumb != null? messageAudioModel.audioThumb: "",),
              fit: BoxFit.cover
          ): DecorationImage(
              image: AssetImage(AppBackgroundImages.audio_background_image_orion_nebula),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.color)

          ),
          borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: Stack(
        children: <Widget>[


          Center(
            child: Icon(
              FontAwesomeIcons.music,
              color: Colors.white.withOpacity(0.2),
              size: MediaQuery.of(context).size.width * scaleFactor * 2,
            ),
          ),


          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),

                onTap: (){


                  Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (BuildContext context){
                          return AudioViewer(audioUrl: messageAudioModel.audioUrl, audioDownloadable: messageModel.downloadable, audioImageUrl: messageAudioModel.audioImage, );
                        },
                      )
                  );

                },

                child: messageModel.downloadable != null && messageModel.downloadable? Container(

                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.headphonesAlt, color: Colors.white,),
                        SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
                        Text("Listen", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize))

                      ],
                    ),
                  ),

                ): Container(
                  child: Center(
                    child: Icon(Icons.play_arrow, color: _themeData.primaryColor,),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
*/



  Future<void> showMessageDialogDeleteOption({@required BuildContext context, @required MessageModel messageModel})async{

    ChatRoomBlocProvider _provider = ChatRoomBlocProvider.of(context);
    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    await showDialog(
        context: context,
        builder: (BuildContext context){



          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              duration: Duration.zero,

              builder: (context, anim, _){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                    title: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.25),
                        child: Text("Do you want to Delete Message?", style: TextStyle( fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),


                    content: Column(
                      children: <Widget>[
                        Text(
                          "Message will only be removed For You",
                          textAlign: TextAlign.center,
                        ),

                        if (_bloc.getCurrentUserModel.userId == messageModel.sender_id
                            && (messageModel.message_type == MessageType.image
                                || messageModel.message_type == MessageType.audio
                                || messageModel.message_type == MessageType.video
                            ))
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: screenHeight * scaleFactor * 0.33),
                                Text(
                                  "Your Media File will also only be deleted For You.\nIf needed, download before deleting Message",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    actions: <Widget>[


                      CupertinoDialogAction(
                        child: Text("YES",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: ()async{

                          List<MessageModel> dummyMessageList = List<MessageModel>();
                          for (int index = 0; index < _bloc.getMessagesList.length; ++index){
                            dummyMessageList.add(_bloc.getMessagesList[index]);
                          }

                          for (int index = 0; index < dummyMessageList.length; ++index){
                            if (messageModel.message_id == dummyMessageList[index].message_id){
                              MessageModel messageModelToDelete = _bloc.getMessagesList[index];

                              if (messageModel.message_id == messageModelToDelete.message_id){

                                _bloc.removeMessageData(
                                    messageId: messageModel.message_id,
                                    currentUserId: _bloc.getCurrentUserModel.userId,
                                    chatUserId: _bloc.getChatUserModel.userId
                                );

                                _bloc.removeCurrentUserSentMessageState(
                                    messageId: messageModel.message_id,
                                    currentUserId: _bloc.getCurrentUserModel.userId,
                                    chatUserId: _bloc.getChatUserModel.userId
                                );


                                if (_bloc.getCurrentUserModel.userId == messageModel.sender_id){

                                  //AppBlocProvider.of(context).bloc.deleteAllFilesInModelData(dynamicModel: messageModel);
                                }

                                _bloc.getMessagesList.removeAt(index);

                                _bloc.addMessagesListToStream(_bloc.getMessagesList);

                                break;
                              }

                              break;
                            }
                          }

                          Navigator.of(context).pop(true);
                        },
                      ),



                      CupertinoDialogAction(
                        child: Text("NO",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: (){

                          Navigator.of(context).pop();
                        },
                      ),

                    ],

                  ),
                );
              },
            ),
          );
        }
    );

  }











  static Future<bool> showChatInfo({@required BuildContext context})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){


          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (context, anim, _){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                    title: Center(
                      //child: Icon(Icons.info_outline)
                      child: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Icon(Icons.info_outline),
                            SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                            Text("Chat Info", style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),


                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Slide message from Left to Right to refer to the message",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * scaleFactor * 0.25,),
                        Text(
                          "Slide message from Right to Left to delete the message",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * scaleFactor * 0.25,),

                        Text(
                          "Perform a Long-press on your profile image to view your profile",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    actions: <Widget>[

                      CupertinoDialogAction(
                        child: Text("OK",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: (){

                          Navigator.of(context).pop(true);
                        },
                      ),

                    ],

                  ),
                );
              },
            ),
          );
        }
    );

  }






  Widget getReferredMessageWidget({@required BuildContext pageContext, @required MessageModel referredMessageModel}){


    ChatRoomBlocProvider _provider = ChatRoomBlocProvider.of(pageContext);
    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;


    Widget referredMessageTitleText = Text(referredMessageModel.sender_id == _bloc.getChatUserModel.userId? _bloc.getChatUserModel.profileName: "Me",
      style: TextStyle(
          color: _themeData.primaryColor,
          fontWeight: FontWeight.bold
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );


    if (referredMessageModel.message_type == MessageType.text){

      return ListTile(
          title: referredMessageTitleText,
          subtitle: Text(referredMessageModel.message_text,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          dense: true
      );
    }
    else if (referredMessageModel.message_type == MessageType.image){
      return ListTile(
        title: referredMessageTitleText,
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.camera_alt, color: Colors.black.withOpacity(0.5)),
            SizedBox(width: 10.0,),
            Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Image",
              style: TextStyle(
                  fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Semantics(
          label: "FittedBox is needed here to make the render box not to overflow to unlimited bounds",
          child: FittedBox(
            fit: BoxFit.fill,
            child: CachedNetworkImage(
              imageUrl: MessageImageModel.fromJson(referredMessageModel.message_data).imagesThumbsUrl[0],
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider){
                return Container(
                  width: screenWidth,
                  height: screenWidth,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(60.0)
                  ),
                );
              },
            ),
          ),
        ),
        dense: true,
      );
    }
    else if (referredMessageModel.message_type == MessageType.video){
      return Container();
      /*
      return ListTile(
        title: referredMessageTitleText,
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.videocam, color: Colors.black.withOpacity(0.5)),
            SizedBox(width: 10.0,),
            Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Video",
              style: TextStyle(
                  fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,

            ),
          ],
        ),
        trailing: Semantics(
          label: "FittedBox is needed here to make the render box not to overflow to unlimited bounds",
          child: FittedBox(
            fit: BoxFit.fill,
            child: CachedNetworkImage(
              imageUrl: MessageVideoModel.fromJson(referredMessageModel.message_data).videoThumb,
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider){
                return Container(
                  width: screenWidth,
                  height: screenWidth,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(60.0)
                  ),
                );
              },
            ),
          ),
        ),
        dense: true,
      );
      */
    }
    else if(referredMessageModel.message_type == MessageType.audio){
      return Container();
      /*
      return ListTile(
        title: referredMessageTitleText,
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.headset, color: Colors.black.withOpacity(0.5),),
            SizedBox(width: 10.0,),
            Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Audio",
              style: TextStyle(
                  fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

       */
    }
    else{
      return Container();
    }

  }









  Widget getLoadedMessageReferredMessageWidget({@required BuildContext pageContext, @required MessageModel referredMessageModel}){


    ChatRoomBlocProvider _provider = ChatRoomBlocProvider.of(pageContext);
    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;


    Widget referredMessageTitleText = Text(referredMessageModel.sender_id == _bloc.getChatUserModel.userId? _bloc.getChatUserModel.profileName: "Me",
      style: TextStyle(
          color: _themeData.primaryColor,
          fontWeight: FontWeight.bold
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );


    if (referredMessageModel.message_type == MessageType.text){

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          referredMessageTitleText,
          SizedBox(height: 5.0,),
          Text(referredMessageModel.message_text,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          )
        ],
      );

    }
    else if (referredMessageModel.message_type == MessageType.image){
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              referredMessageTitleText,
              SizedBox(height: 5.0,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.camera_alt, color: Colors.black.withOpacity(0.5)),
                  SizedBox(width: 10.0,),
                  Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Image",
                    style: TextStyle(
                        fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: screenWidth * scaleFactor * 0.5,),

          Flexible(
            child: CachedNetworkImage(
              imageUrl: MessageImageModel.fromJson(referredMessageModel.message_data).imagesThumbsUrl[0],
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider){
                return Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                );
              },
            ),
          )

        ],
      );

    }
    else if (referredMessageModel.message_type == MessageType.video){

      return Container();
      /*
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              referredMessageTitleText,
              SizedBox(height: 5.0,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.videocam, color: Colors.black.withOpacity(0.5)),
                  SizedBox(width: 10.0,),
                  Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Video",
                    style: TextStyle(
                        fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: screenWidth * scaleFactor * 0.5,),

          Flexible(
            child: CachedNetworkImage(
              imageUrl: MessageVideoModel.fromJson(referredMessageModel.message_data).videoThumb,
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider){
                return Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                );
              },
            ),
          )

        ],
      );
      */

    }
    else if(referredMessageModel.message_type == MessageType.audio){

      return Container();
      /*
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              referredMessageTitleText,
              SizedBox(height: 5.0,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.headset, color: Colors.black.withOpacity(0.5)),
                  SizedBox(width: 10.0,),
                  Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Audio",
                    style: TextStyle(
                        fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
                    ),maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: screenWidth * scaleFactor * 0.5,),

        ],
      );
      */

    }
    else{
      return Container();
    }

  }





  Future<void> showReferredMessageModal({@required BuildContext pageContext, @required MessageModel referredMessageModel})async{

    ChatRoomBlocProvider _provider = ChatRoomBlocProvider.of(pageContext);
    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;

    Widget messageTypeWidget;

    if (referredMessageModel.message_type == MessageType.image){
      messageTypeWidget = getMessageImagePreviewWidget(context: pageContext, messageModel: referredMessageModel);
    }
    else{
      messageTypeWidget = Container();
    }




    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimeLastSeen = referredMessageModel.timestamp.toDate();

    String dateTimeDailyMessages;

    if (dateTimeNow.day == dateTimeLastSeen.day
        &&  dateTimeNow.month == dateTimeLastSeen.month
        && dateTimeNow.year == dateTimeLastSeen.year
    ){
      dateTimeDailyMessages = "Today, " + DateFormat.yMMMMd().add_jm().format(dateTimeLastSeen);
    }
    else if ((dateTimeNow.day  - dateTimeLastSeen.day) == 1
        &&  (dateTimeNow.month == dateTimeLastSeen.month
            || (dateTimeNow.month - dateTimeLastSeen.month) == 1
            || (dateTimeNow.month - dateTimeLastSeen.month) == -11
        )
        && dateTimeNow.year == dateTimeLastSeen.year
    ){
      dateTimeDailyMessages = "Yesterday, " + DateFormat.yMMMMd().add_jm().format(dateTimeLastSeen);
    }
    else{
      dateTimeDailyMessages = DateFormat.yMMMMEEEEd().add_jm().format(dateTimeLastSeen);
    }



    await showDialog(
        context: pageContext,
        builder: (BuildContext context){

          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeOutBack,
              duration: Duration(milliseconds: 500),

              builder: (context, anim, _){
                return Transform.scale(
                  scale: anim.value,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth * 0.5,
                      maxWidth: screenWidth * 0.75,
                      maxHeight: screenHeight * 0.75,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      color: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? _themeData.primaryColor: Colors.white,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[

                              Row(
                                children: <Widget>[
                                  Text(referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? "Me": _bloc.getChatUserModel.profileName,
                                    style: TextStyle(
                                        color: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? Colors.white: _themeData.primaryColor,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                              if (referredMessageModel.message_data != null)
                                Flexible(
                                    child: Container(
                                        width: screenWidth * scaleFactor * 5,
                                        height: screenWidth * scaleFactor * 4,
                                        child: messageTypeWidget
                                    )
                                ),

                              if (referredMessageModel.message_text != null)
                                Container(
                                  padding: EdgeInsets.all( screenWidth * scaleFactor * scaleFactor),
                                  child: Text(referredMessageModel.message_text != null? "${referredMessageModel.message_text}": "",
                                    style: TextStyle(
                                        color: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? Colors.white: Colors.black,
                                        fontWeight: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? FontWeight.w700: FontWeight.normal
                                    ),
                                  ),
                                ),

                              Padding(
                                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                                child: Text(dateTimeDailyMessages,
                                  style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.caption.fontSize,
                                      color: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.black.withOpacity(0.5)
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
    );

  }




}











