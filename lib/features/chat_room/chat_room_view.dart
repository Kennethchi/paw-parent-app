



import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/profile/profile.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/message_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/date_time_utils.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'chat_room_bloc.dart';
import 'chat_room_bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

import 'chat_room_widgets.dart';




Widget getChatRoomAppBar({@required BuildContext context, @required UserModel chatUserModel}){

  CupertinoThemeData _themeData = CupertinoTheme.of(context);
  double screenwidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    leading: Padding(
      padding: const EdgeInsets.all(10.0),

      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back_ios, color: _themeData.primaryColor,),
      ),

    ),
    title: AppbarTitleView(),
  );
}





class ChatMessageTextField extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    TextEditingController _textEditingController = ChatRoomBlocProvider.of(context).textEditingController;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenwidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenwidth * scaleFactor * scaleFactor * 0.5),
      child: Container(
        width: screenwidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 80,
              child: Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                //color: RGBColors.light_grey_level_1,
                //color: CupertinoColors.lightBackgroundGray.withOpacity(0.5),
                color: Colors.white,
                child: Column(
                  children: <Widget>[

                    ReferredMessageWidget(),

                    TextField(
                        controller: _textEditingController,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: SubmitButtonWidget(),
                            hintText: "Write Message...",
                            hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.2)
                            ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
                        ),
                        onChanged: (String text){

                          ChatRoomBlocProvider.of(context).handlers.onTextChange(context: context, text: text);
                        },
                        keyboardType: TextInputType.text
                    ),

                    //EmojieWidget()
                  ],
                ),
              ),
            ),
            SizedBox(width: screenwidth * scaleFactor * scaleFactor,),

            Flexible(
                flex: 20,
                child: CurrentUserOnlineAvatarView(userModel: _bloc.getCurrentUserModel,)
            )
          ],
        ),
      ),
    );
  }

}



class MessagesListView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<List<MessageModel>>(
      stream: _bloc.getMessagesListStream,
      builder: (BuildContext context, AsyncSnapshot<List<MessageModel>> snapshot){

        if (snapshot.hasData){


          if (snapshot.data.length <= 0){

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(FontAwesomeIcons.comments, size: screenWidth * scaleFactor * 2.5, color: Colors.black.withOpacity(0.05),),
                  SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
                  Text("Chat",
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.headline.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.05)
                    ),
                  )
                ],
              ),
            );
          }
          else{

            return ListView.builder(
              controller: ChatRoomBlocProvider.of(context).scrollController,
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.25, vertical: screenHeight * scaleFactor * 0.25),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){


                bool shouldShowDataHeader = false;

                if (index > 0 && index < snapshot.data.length - 1){
                  DateTime currentMessageDatetime = snapshot.data[index].timestamp.toDate();
                  DateTime nextMessageDatetime = snapshot.data[index + 1].timestamp.toDate();
                  if (currentMessageDatetime.day == nextMessageDatetime.day
                      && currentMessageDatetime.month == nextMessageDatetime.month
                      && currentMessageDatetime.year == nextMessageDatetime.year)
                  {
                    shouldShowDataHeader = false;
                  }
                  else{
                    shouldShowDataHeader = true;
                  }
                }
                else if (index == snapshot.data.length - 1){
                  shouldShowDataHeader = true;
                }
                else{
                  shouldShowDataHeader = false;
                }


                return MessageModelViewHolder(
                  messageModel: snapshot.data[index],
                  showHeaderDate: shouldShowDataHeader,
                );


              },
            );

          }

        }
        else{
          return Center(
            child: DogLoaderWidget(width: 100.0, height: 100.0,),
          );
        }

      },
    );
  }

}




class MessageModelViewHolder extends StatelessWidget {

  MessageModel messageModel;

  bool showHeaderDate;

  MessageModelViewHolder({@required this.messageModel, @required this.showHeaderDate});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    double borderRadius = screenWidth * scaleFactor * 0.4;


    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimeLastSeen = messageModel.timestamp.toDate();

    String dateTimeDailyMessages;

    if (dateTimeNow.day == dateTimeLastSeen.day
        &&  dateTimeNow.month == dateTimeLastSeen.month
        && dateTimeNow.year == dateTimeLastSeen.year
    ){
      dateTimeDailyMessages = "Today, " + DateFormat.yMMMMd().format(dateTimeLastSeen);
    }
    else if ((dateTimeNow.day  - dateTimeLastSeen.day) == 1
        &&  (dateTimeNow.month == dateTimeLastSeen.month
            || (dateTimeNow.month - dateTimeLastSeen.month) == 1
            || (dateTimeNow.month - dateTimeLastSeen.month) == -11
        )
        && dateTimeNow.year == dateTimeLastSeen.year
    ){

      dateTimeDailyMessages = "Yesterday, " + DateFormat.yMMMMd().format(dateTimeLastSeen);
    }
    else{

      dateTimeDailyMessages = DateFormat.yMMMMEEEEd().format(dateTimeLastSeen);
    }


    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (DismissDirection direction)async{

        if (direction == DismissDirection.endToStart){

          ChatRoomBlocProvider.of(context).handlers.showMessageDialogDeleteOption(context: context, messageModel: messageModel);
        }
        else if (direction == DismissDirection.startToEnd){
          _bloc.addReferredMessageModelToStream(messageModel);
        }

        return false;
      },
      child: StickyHeader(
        header: this.showHeaderDate != null && this.showHeaderDate
            ? Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              // DateFormat.yMMMMEEEEd().add_jm().format(messageModel.timestamp.toDate())
                dateTimeDailyMessages != null? dateTimeDailyMessages: DateFormat.yMMMMEEEEd().format(messageModel.timestamp.toDate()),
              style: TextStyle(color: Colors.black.withOpacity(0.7)),
            ),
          ),
        )
            : Container(),

        content: Row(
          mainAxisAlignment: messageModel.sender_id == _bloc.getCurrentUserModel.userId? MainAxisAlignment.end: MainAxisAlignment.start,

          children: <Widget>[

            Container(
              constraints: BoxConstraints(maxWidth: screenWidth * scaleFactor * 6.0),
              child: Card(

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: messageModel.sender_id == _bloc.getCurrentUserModel.userId? Radius.circular(borderRadius): Radius.zero,
                        topRight: Radius.circular(borderRadius),
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: messageModel.sender_id == _bloc.getCurrentUserModel.userId? Radius.zero: Radius.circular(borderRadius)
                    )
                ),


                elevation: 0.0,
                color: messageModel.sender_id == _bloc.getCurrentUserModel.userId? _themeData.primaryColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * scaleFactor * scaleFactor,
                      right: screenWidth * scaleFactor * scaleFactor,
                      top: screenWidth * scaleFactor * scaleFactor),
                  child: Column(
                    crossAxisAlignment: messageModel.sender_id == _bloc.getCurrentUserModel.userId? CrossAxisAlignment.end: CrossAxisAlignment.start,

                    children: <Widget>[


                      if (messageModel.referred_message != null)
                        GestureDetector(

                          onTap: (){

                            // Show referred message Modal Dialog
                            ChatRoomBlocProvider.of(context).handlers.showReferredMessageModal(
                                pageContext: context,
                                referredMessageModel: MessageModel.fromJson(messageModel.referred_message)
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: screenWidth * 0.3
                              ),
                              child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    color: messageModel.sender_id == _bloc.getCurrentUserModel.userId
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black.withOpacity(0.075),
                                  ),
                                  child: ChatRoomBlocProvider.of(context).handlers.getLoadedMessageReferredMessageWidget(
                                      pageContext: context, referredMessageModel: MessageModel.fromJson(messageModel.referred_message)
                                  )
                              ),
                            ),
                          ),
                        ),
                      ChatRoomBlocProvider.of(context).handlers.getMessageTypeWidget(chatContext: context, messageModel: messageModel),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "${DateTimeUtils.getTimeFromTimestampType_jm(messageModel.timestamp)}",
                              style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.overline.fontSize,
                                  color: messageModel.sender_id == _bloc.getCurrentUserModel.userId? Colors.white.withOpacity(0.8)
                                      : Colors.black.withOpacity(0.5)
                              ),
                            ),

                            /*
                            SizedBox(width: 10.0,),

                            if (messageModel.sender_id == _bloc.getCurrentUserModel.userId)
                              Container(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        child: FittedBox(
                                          child: Container(
                                            child: messageModel.sender_id == _bloc.getCurrentUserModel.userId && messageModel.seen
                                                ? Icon(FontAwesomeIcons.checkDouble, color: RGBColors.light_blue, size: 12.0,):
                                            //Icon(Icons.access_time, color: _themeData.primaryContrastingColor, size: 12.0,)
                                            Container(
                                              child: StreamBuilder<Event>(
                                                  stream: _bloc.getCurrentUserSentMessageStateEvent(
                                                      messageId: messageModel.message_id,
                                                      currentUserId: _bloc.getCurrentUserModel.userId,
                                                      chatUserId: _bloc.getChatUserModel.userId
                                                  ),
                                                  builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {


                                                    switch(snapshot.connectionState){
                                                      case ConnectionState.none:case ConnectionState.waiting:
                                                      return SpinKitThreeBounce(color: _themeData.primaryContrastingColor, size: 12.0);
                                                      case ConnectionState.active:case ConnectionState.done:

                                                      if (snapshot.data.snapshot.value == null){
                                                        return Container();
                                                      }
                                                      else if (snapshot.data.snapshot.value == MessageState.sent){
                                                        return Icon(FontAwesomeIcons.check, color: Colors.white.withOpacity(0.8), size: 12.0,);
                                                      }
                                                      else if (snapshot.data.snapshot.value == MessageState.seen){
                                                        return Icon(FontAwesomeIcons.checkDouble, color: RGBColors.light_blue, size: 12.0,);
                                                      }
                                                      else{
                                                        // Give a check regardless of the outcome of message seen event
                                                        return Icon(FontAwesomeIcons.check, color: Colors.white.withOpacity(0.8), size: 12.0,);
                                                      }

                                                    }

                                                  }
                                              ),
                                            ),
                                          ),
                                        ),
                                      )

                                  )


                              )

                            */

                          ],
                        ),
                      )

                    ],
                  ),
                ),

              ),
            ),


          ],
        ),
      ),
    );
  }


}





class ChatUserLastSeenView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<Event>(
      stream: _bloc.getChatUserOnlineStatusEventStream,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshots){

        if(snapshots.hasData){

          if (snapshots.data.snapshot.value == null){
            return Container();
          }
          else if (snapshots.data.snapshot.value == 1){
            return Container(
                child: Text("Online",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: Theme.of(context).textTheme.caption.fontSize),
                )
            );
          }
          else{

            DateTime dateTimeNow = DateTime.now();
            DateTime dateTimeLastSeen = DateTime.fromMillisecondsSinceEpoch(snapshots.data.snapshot.value);

            if (dateTimeNow.day == dateTimeLastSeen.day
                &&  dateTimeNow.month == dateTimeLastSeen.month
                && dateTimeNow.year == dateTimeLastSeen.year
            ){

              String dateTimeLastSeenString = DateFormat.jm().format(dateTimeLastSeen);

              //DateTimeUtils.getTimeFromMillisecondsSinceEpochType_jm(snapshots.data.snapshot.value)

              return Text("Last Seen:" + " Today,  " + dateTimeLastSeenString,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: Theme.of(context).textTheme.caption.fontSize),
              );

            }
            else if ((dateTimeNow.day  - dateTimeLastSeen.day) == 1
                &&  (dateTimeNow.month == dateTimeLastSeen.month
                    || (dateTimeNow.month - dateTimeLastSeen.month) == 1
                    || (dateTimeNow.month - dateTimeLastSeen.month) == -11
                )
                && dateTimeNow.year == dateTimeLastSeen.year
            ){

              String dateTimeLastSeenString = DateFormat.jm().format(dateTimeLastSeen);

              return Text("Last Seen:" + " Yesterday,  " + dateTimeLastSeenString,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: Theme.of(context).textTheme.caption.fontSize),
              );

            }
            else if ((dateTimeNow.day  - dateTimeLastSeen.day) < 7
                &&  (dateTimeNow.month == dateTimeLastSeen.month
                    || (dateTimeNow.month - dateTimeLastSeen.month) == 1
                    || (dateTimeNow.month - dateTimeLastSeen.month) == -11
                )
                && dateTimeNow.year == dateTimeLastSeen.year
            ){


              String dateTimeLastSeenString = DateFormat.E().add_d().add_MMM().format(dateTimeLastSeen) + ",  " + DateFormat.jm().format(dateTimeLastSeen);


              return Text("Last Seen:" + " " + dateTimeLastSeenString,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: Theme.of(context).textTheme.caption.fontSize),
              );

            }
            else{

              //String dateTimeLastSeenString = DateFormat.yMMMMEEEEd().add_jm().format(dateTimeLastSeen);

              String dateTimeLastSeenString = DateFormat.yMMMEd().add_jm().format(dateTimeLastSeen);

              return Text("Last Seen:" + " " + dateTimeLastSeenString,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: Theme.of(context).textTheme.caption.fontSize),
              );
            }


          }


        }else{
          return Container();
        }


      },
    );
  }

}





class ChatUserOnlineAvatarView extends StatelessWidget{

  UserModel chatUserModel;

  ChatUserOnlineAvatarView({@required this.chatUserModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: chatUserModel.profileImageThumb != null && chatUserModel.profileImageThumb.isNotEmpty? Hero(
        tag: chatUserModel.userId,
        child: Container(
          child: CircleAvatar(
            backgroundColor: _themeData.primaryColor,
            backgroundImage: CachedNetworkImageProvider(chatUserModel.profileImageThumb),
          ),
        ),
      ): Hero(
        tag: chatUserModel.userId,
        child: Container(
          child: CircleAvatar(
            backgroundColor: _themeData.primaryColor,
            child: Center(
              child: Text(chatUserModel.profileName.characters.first.toUpperCase(), style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headline6.fontSize,
                color: Colors.white
              ),),
            ),
          ),
        ),
      ),
    );
  }

}







class CurrentUserOnlineAvatarView extends StatelessWidget{

  UserModel userModel;

  CurrentUserOnlineAvatarView({@required this.userModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return GestureDetector(
        onLongPress: (){
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context){
                return Profile(profileUserModel: userModel);
              }
          ));
        },
        child: Container(
          child: userModel.profileImageThumb != null && userModel.profileImageThumb.isNotEmpty? Hero(
            tag: userModel.userId,
            child: Container(
              child: CircleAvatar(
                backgroundColor: _themeData.primaryColor,
                backgroundImage: CachedNetworkImageProvider(userModel.profileImageThumb),
              ),
            ),
          ): Hero(
            tag: userModel.userId,
            child: Container(
              child: CircleAvatar(
                backgroundColor: _themeData.primaryColor,
                child: Center(
                  child: Text(userModel.profileName.characters.first.toUpperCase(), style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
          ),
        )
    );
  }

}








class ChatUserTypingStateView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<Event>(
      stream: _bloc.getChatUserTypingStatusEventStream,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot){


        if (snapshot.hasData && snapshot.data.snapshot.value == true){

          return Padding(
            padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.25, horizontal: screenWidth * scaleFactor * 0.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[

                Text(
                  "Typing",
                  style: TextStyle(
                      color: _themeData.primaryColor,
                      fontSize: Theme.of(context).textTheme.caption.fontSize,
                      fontWeight: FontWeight.bold
                    //fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

                SpinKitThreeBounce(color: _themeData.primaryColor, size: 10.0,)
              ],
            ),
          );


        }
        else{
          return Container();
        }

      },
    );
  }

}




class SubmitButtonWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build



    ChatRoomBloc _bloc = ChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<String>(
      stream: _bloc.getTextStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){

        // validate
        bool validateText = snapshot.hasData && snapshot.hasError == false;

        return CupertinoButton(
          padding: EdgeInsets.only(top: 0.0, bottom: 0.0, right: screenWidth * scaleFactor * 0.25),

          child: Icon(FontAwesomeIcons.solidPaperPlane),

          onPressed: validateText? (){
            ChatRoomBlocProvider.of(context).handlers.sendMessageText(context: context, cleanedMessage: snapshot.data);
          }: null,

        );
      },
    );
  }

}



class AppbarTitleView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    ChatRoomBloc bloc = ChatRoomBlocProvider.of(context).bloc;



    return InkWell(
      onTap: (){

        Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context)=> Profile(
                profileUserModel: bloc.getChatUserModel
            )
        ));

      },
      child: Row(
        children: [
          ChatUserOnlineAvatarView(chatUserModel: bloc.getChatUserModel),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Flexible(
                        child: Text(
                          bloc.getChatUserModel.profileName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black.withOpacity(0.8)),)
                    ),

                  ],
                ),
                //Text("@" + bloc.getChatUserModel.username, style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: Theme.of(context).textTheme.caption.fontSize),)



                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(child: ChatUserLastSeenView()),

                    /*
                            SizedBox(width: screenWidth * scaleFactor * scaleFactor,),
                            ChatUserTypingStateView()
                            */
                  ],
                )



              ],
            ),
          ),
        ],
      ),
    );
  }



}



