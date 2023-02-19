import 'dart:async';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:ui';
import 'package:paw_parent_app/resources/models/message_model.dart';

import 'chat_room_bloc.dart';
import 'chat_room_bloc_provider.dart';








class MessageTextWidget extends StatelessWidget{

  MessageModel messageModel;

  MessageTextWidget({@required this.messageModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * scaleFactor),
      child: Text(messageModel.message_text != null? "${messageModel.message_text}": "",
        style: TextStyle(
            color: messageModel.sender_id == _bloc.getCurrentUserModel.userId? Colors.white: Colors.black,
            fontWeight: messageModel.sender_id == _bloc.getCurrentUserModel.userId? FontWeight.w700: FontWeight.normal
        ),
      ),
    );

  }

}




class MessageImageWidget extends StatelessWidget{

  MessageModel messageModel;

  MessageImageWidget({@required this.messageModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return MessageMediaTemplateWidget(
        messageModel: messageModel,
        child: ChatRoomBlocProvider.of(context).handlers.getMessageImagePreviewWidget(

            context: context,
            messageModel: messageModel
        )
    );
  }

}


/*
class MessageVideoWidget extends StatelessWidget{

  MessageModel messageModel;

  MessageVideoWidget({@required this.messageModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return MessageMediaTemplateWidget(
        messageModel: messageModel,
        child: ChatRoomBlocProvider.of(context).handlers.getMessageVideoPreviewWidget(

            context: context,
            messageModel: messageModel
        )
    );
  }

}
*/


/*
class MessageAudioWidget extends StatelessWidget{

  MessageModel messageModel;

  MessageAudioWidget({@required this.messageModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return Container(
      child: MessageMediaTemplateWidget(
          messageModel: messageModel,
          child: ChatRoomBlocProvider.of(context).handlers.getMessageAudioPreviewWidget(

              context: context,
              messageModel: messageModel
          )
      ),
    );
  }

}
*/





class MessageMediaTemplateWidget extends StatelessWidget{

  MessageModel messageModel;
  Widget child;

  MessageMediaTemplateWidget({@required this.messageModel, @required this.child});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    double widgetWidth = screenWidth * scaleFactor * 5;
    double widgetHeight = screenWidth * scaleFactor * 4;



    return Column(
      crossAxisAlignment: messageModel.sender_id == _bloc.getCurrentUserModel.userId? CrossAxisAlignment.end: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Flexible(
          child: Container(
              width: widgetWidth,
              height: widgetHeight,
              child: this.child
          ),
        ),

        Container(
            width: widgetWidth,
            child: messageModel.message_text != null && messageModel.message_text.isNotEmpty?  Column(
              crossAxisAlignment: messageModel.sender_id == _bloc.getCurrentUserModel.userId? CrossAxisAlignment.end: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                MessageTextWidget(messageModel: messageModel,),
              ],
            ):
            Container()
        )
      ],
    );
  }


}








class ReferredMessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ChatRoomBlocProvider _provider = ChatRoomBlocProvider.of(context);
    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<MessageModel>(
        stream: _bloc.getReferredMessageModelStream,
        builder: (context, snapshot) {

          if (snapshot.data == null){
            return Container();
          }
          else{
            return Dismissible(
              key: UniqueKey(),
              confirmDismiss: (DismissDirection direction)async{

                if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd){
                  _bloc.addReferredMessageModelToStream(null);
                }

                return false;
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: _themeData.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
                  ),
                  child: Stack(
                    children: <Widget>[

                      Positioned(

                        child: Container(
                          child: _provider.handlers.getReferredMessageWidget(pageContext: context, referredMessageModel: snapshot.data),
                        ),
                      ),

                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: (){
                              _bloc.addReferredMessageModelToStream(null);
                            },
                            child: Icon(Icons.close, size: 18.0,),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }

        }
    );
  }
}



