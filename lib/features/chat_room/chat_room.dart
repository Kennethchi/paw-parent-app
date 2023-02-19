import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/chat_room/chat_room_bloc.dart';
import 'package:paw_parent_app/features/chat_room/chat_room_bloc_provider.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';

import 'chat_room_view.dart';
import 'chat_room_view_handlers.dart';


class ChatRoom extends StatefulWidget {

  UserModel currentUserModel;
  UserModel chatUserModel;

  ChatRoom({@required this.currentUserModel, @required this.chatUserModel});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin, WidgetsBindingObserver, AfterLayoutMixin<ChatRoom> {

  ChatRoomBloc _bloc;


  TextEditingController _textEditingController;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _bloc = ChatRoomBloc(chatUserModel: widget.chatUserModel, currentUserModel: widget.currentUserModel);
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addObserver(this);
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    ChatRoomViewHandlers.onChangeAppLifecycleState(state: state, bloc: _bloc);
  }


  @override
  void afterFirstLayout(BuildContext context) {

  }



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();


  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChatRoomBlocProvider(
      bloc: _bloc,
      scrollController: _scrollController,
      textEditingController: _textEditingController,

      child: WillPopScope(
        //onWillPop: () async => false
        onWillPop: () async{
          //await _animationController.reverse();

          Navigator.pop(context);
        },
        child: Scaffold(


          appBar: getChatRoomAppBar(context: context, chatUserModel: widget.chatUserModel),

          body: CupertinoPageScaffold(

            backgroundColor: RGBColors.light_yellow,

            child: Container(
              width: MediaQuery.of(context).size.width,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                //fit: StackFit.loose,
                //alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[


                  Flexible(
                      flex: 100,
                      child: Stack(
                        //fit: StackFit.passthrough,
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          MessagesListView(),

                          Positioned(
                            top: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                  child: Card(
                                    elevation: 0.0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.125)
                                    ),
                                    child: ChatUserTypingStateView(),
                                  )
                              ),
                            ),
                          ),
                        ],
                      )
                  ),


                  ChatMessageTextField()

                ],
              ),
            ),



            /*
            navigationBar: CupertinoNavigationBar(

              leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FittedBox(
                      child: ChatUserOnlineAvatarView(chatUserModel: widget.chatUserModel)
                  )
              ),

              middle: AppbarTitleView(),

              trailing: IconButton(icon: Icon(Icons.more_vert, color: RGBColors.light_grey_level_3,), onPressed: (){}),
            ),

            */
          ),


        ),
      ),
    );
  }

}
