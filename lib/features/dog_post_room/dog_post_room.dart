import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/dog_post_room/dog_post_room_bloc.dart';
import 'package:paw_parent_app/features/dog_post_room/dog_post_room_bloc_provider.dart';
import 'package:paw_parent_app/features/dog_post_room/dog_post_room_view.dart';
import 'package:paw_parent_app/features/dog_post_room/dog_post_room_view_handlers.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';



class DogPostRoom extends StatefulWidget {

  DogPostModel dogPostModel;
  bool popOutComments;

  DogPostRoom({@required this.dogPostModel, this.popOutComments});

  @override
  _DogPostRoomState createState() => _DogPostRoomState();
}

class _DogPostRoomState extends State<DogPostRoom> with AfterLayoutMixin {


  DogPostRoomBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = DogPostRoomBloc(dogPostModel: widget.dogPostModel);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.popOutComments != null && widget.popOutComments == true){

      Timer(Duration(seconds: 1), (){
        DogPostRoomViewHandlers.showPostComments(pageContext: context, dogPostModel: widget.dogPostModel);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DogPostRoomBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: DogPostRoomView(),
      ),
    );
  }


}
