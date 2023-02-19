import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/chat_space/chat_space_bloc.dart';
import 'package:paw_parent_app/features/chat_space/chat_space_bloc_provider.dart';
import 'package:paw_parent_app/features/chat_space/chat_space_view.dart';




class ChatSpace extends StatefulWidget {
  @override
  _ChatSpaceState createState() => _ChatSpaceState();
}

class _ChatSpaceState extends State<ChatSpace> {

  ChatSpaceBloc _bloc;
  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = ChatSpaceBloc();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChatSpaceBlocProvider(
      bloc: _bloc,
      scrollController: scrollController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("Chats", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
          elevation: 0.0,
        ),
        body: ChatSpaceView(),
      ),
    );
  }
}
