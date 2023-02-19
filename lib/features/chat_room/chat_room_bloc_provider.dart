import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/constants/constants.dart';



import 'chat_room_bloc.dart';
import 'chat_room_view_handlers.dart';

class ChatRoomBlocProvider extends InheritedWidget{

  final ChatRoomBloc bloc;
  final Key key;
  final Widget child;

  ChatRoomViewHandlers handlers;

  ScrollController scrollController;

  TextEditingController textEditingController;

  ChatRoomBlocProvider({
    @required this.scrollController,
    @required this.textEditingController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = ChatRoomViewHandlers();

    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 50.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedMessages == false || bloc.getHasLoadedMessages == AppDataLimits.maxNumberOfMessagesToLoad)
            && bloc.getHasMoreMessages
            && bloc.getMessagesList.length < 300
        ){

          bloc.setHasLoadedMessages = true;

          bloc.loadMoreMessages(
              currentUserId: bloc.getCurrentUserModel.userId,
              chatUserId: bloc.getChatUserModel.userId,
              messageQueryLimit: bloc.getMessagesQueryLimit
          ).then((_){

            bloc.setHasLoadedMessages = false;
          });
        }
      }

    });
  }

  static ChatRoomBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(ChatRoomBlocProvider) as ChatRoomBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}