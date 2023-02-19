import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';




import 'chat_space_bloc.dart';
import 'chat_space_view_handlers.dart';

class ChatSpaceBlocProvider extends InheritedWidget{

  final ChatSpaceBloc bloc;
  final Key key;
  final Widget child;

  ChatSpaceViewHandlers handlers;

  ScrollController scrollController;

  ChatSpaceBlocProvider({
    @required this.scrollController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = ChatSpaceViewHandlers();
  }

  static ChatSpaceBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(ChatSpaceBlocProvider) as ChatSpaceBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}