

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:paw_parent_app/features/chat_room/chat_room.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_chat_model.dart';
import 'package:paw_parent_app/ui/image_viewer/image_viewer.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';

import 'chat_space_bloc.dart';
import 'chat_space_bloc_provider.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as time_ago_provider;

import 'chat_space_view_widgets.dart';


class ChatSpaceView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    
    ChatSpaceBloc _bloc = ChatSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return SafeArea(
      child: StreamBuilder<bool>(
        stream: _bloc.showChatsBehaviorSubject,
        builder: (context, snapshot) {

          if (snapshot.hasData && snapshot.data){
            return Container(
              child: StreamBuilder<Event>(
                stream: _bloc.getChatsDataEvent(currentUserId: _bloc.getCurrentUserId),
                builder: (BuildContext context, AsyncSnapshot<Event> snapshots){


                  switch(snapshots.connectionState){

                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return Center(
                        child: DogLoaderWidget(width: 100.0, height: 100.0,),
                      );
                    case ConnectionState.active: case ConnectionState.done:


                    if (snapshots.hasData && snapshots.data.snapshot.value != null){

                      Map<dynamic, dynamic> dataMap = snapshots.data.snapshot.value;
                      List<OptimisedChatModel> optimisedChatModelList = List<OptimisedChatModel>();
                      dataMap.forEach((key, value) {
                        optimisedChatModelList.add(OptimisedChatModel.fromJson(value));
                      });


                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor),
                        controller: ChatSpaceBlocProvider.of(context).scrollController,
                        itemCount: optimisedChatModelList.length,
                        itemBuilder: (BuildContext context, int index){

                          return ChatUserViewModel(optimisedChatModel: optimisedChatModelList[index]);
                        },
                      );

                    }
                    else{
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * scaleFactor),
                          child: Text(
                            "No Chats",
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.headline6.fontSize,
                              color: _themeData.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }



                  }





                },
              ),
            );
          }
          else{
            return Container();
          }

        }
      ),
    );
  }

}







class ChatUserViewModel extends StatelessWidget {


  OptimisedChatModel optimisedChatModel;

  ChatUserViewModel({@required this.optimisedChatModel});


  @override
  Widget build(BuildContext context) {

    ChatSpaceBloc _bloc = ChatSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return FutureBuilder<UserModel>(
      future: _bloc.getUserModelData(userId: optimisedChatModel.chat_user_id),
      builder: (context, snapshot) {

        return InkWell(
          onTap: snapshot.hasData && snapshot.data != null? (){

            UserModel chatUserModel = snapshot.data;

            _bloc.setChatSeen(currentUserId: _bloc.getCurrentUserData.userId , chatUserId: chatUserModel.userId);

            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => ChatRoom(
                currentUserModel: _bloc.getCurrentUserData,
                chatUserModel: chatUserModel
            )));


          }: null,



          child: AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            opacity: snapshot.hasData && snapshot.data != null? 1.0: 0.4,
            child: ListTile(
              leading: ChatUserOnlineAvatarView(optimisedChatModel: optimisedChatModel),

              trailing: FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      //DateTimeUtils.getTimeFromMillisecondsSinceEpochType_jm(optimisedChatModel.t),
                      optimisedChatModel.t != null? time_ago_provider.format(DateTime.fromMillisecondsSinceEpoch(optimisedChatModel.t)): "",
                      style: TextStyle(fontSize: Theme.of(context).textTheme.overline.fontSize),
                    ),


                    //ChatMessageSeenWidget(optimisedChatModel: optimisedChatModel,)
                  ],
                ),
              ),

              title: Row(

                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Flexible(
                      child: Text(
                        optimisedChatModel.name != null? optimisedChatModel.name: "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.bold),
                      )
                  ),

                ],
              ),


              subtitle: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[


                          Flexible(
                              flex: 100,
                              child: ChatUserTypingStateView(optimisedChatModel: optimisedChatModel)
                          ),

                          /*
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * scaleFactor * 0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  //DateTimeUtils.getTimeFromMillisecondsSinceEpochType_jm(optimisedChatModel.t),
                                  optimisedChatModel.t != null? TimeAgo.getTimeAgo(
                                      optimisedChatModel.t
                                  ): "",
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.overline.fontSize),
                                ),
                                ChatMessageSeenWidget(optimisedChatModel: optimisedChatModel,)
                              ],
                            ),
                          )
                          */


                        ],
                      ),

                    ],
                  )
              ),

            ),
          ),
        );
      }
    );
  }
}

















class ChatUserOnlineAvatarView extends StatelessWidget{

  OptimisedChatModel optimisedChatModel;

  ChatUserOnlineAvatarView({@required this.optimisedChatModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ChatSpaceBloc _bloc = ChatSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return GestureDetector(
        onTap: (){


          showCupertinoModalPopup(context: context, builder: (BuildContext context) => ImageViewer(
              currentIndex: 0,
              imageList: [optimisedChatModel.chatUserModel.profileImage]
          ));


        },
        child: Container(
          child: Hero(
            tag: optimisedChatModel.chat_user_id,
            child: Container(
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.2),
                backgroundImage: optimisedChatModel.thumb != null? CachedNetworkImageProvider(optimisedChatModel.thumb): null,
                child: optimisedChatModel.thumb == null? Text(
                    optimisedChatModel.name != null? optimisedChatModel.name[0]: ""
                ): null,
              ),
            ),
          )
        )
    );
  }

}






class ChatUserTypingStateView extends StatelessWidget{

  OptimisedChatModel optimisedChatModel;

  ChatUserTypingStateView({@required this.optimisedChatModel});



  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ChatSpaceBloc _bloc = ChatSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<Event>(
      stream: _bloc.getChatUserTypingStatus(currentUserId: _bloc.getCurrentUserId, chatUserId: optimisedChatModel.chat_user_id),
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot){


        if (snapshot.hasData && snapshot.data.snapshot.value == true){

          return Animator(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            //cycles: 1,
            repeats: 1,
            curve: Curves.elasticOut,
            duration: Duration(seconds: 1),
            builder: (context, anim, _){
              return Transform.scale(
                  scale: anim.value,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[

                      Text(
                        "Typing",
                        style: TextStyle(
                            color: _themeData.primaryColor,
                            //fontSize: Theme.of(context).textTheme..fontSize,
                            fontWeight: FontWeight.bold
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

                      SpinKitThreeBounce(color: _themeData.primaryColor, size: 10.0,)
                    ],
                  )
              );
            },
          );


        }
        else{
          return ChatSpaceBlocProvider.of(context).handlers.getChatMessageView(optimisedChatModel: optimisedChatModel);
        }

      },
    );
  }

}


