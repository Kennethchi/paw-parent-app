import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/insight_room/insight_room_bloc.dart';
import 'package:paw_parent_app/features/insight_room/insight_room_bloc_provider.dart';
import 'package:paw_parent_app/features/insight_room/insight_room_view.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';



class InsightRoom extends StatefulWidget {

  InsightModel insightModel;

  InsightRoom({@required this.insightModel});

  @override
  _InsightRoomState createState() => _InsightRoomState();
}

class _InsightRoomState extends State<InsightRoom> {

  InsightRoomBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = InsightRoomBloc(insightModel: widget.insightModel);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InsightRoomBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
          title: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text("Back to blogs", style: TextStyle(color: Colors.black),)),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: InsightRoomView(),
      ),
    );
  }
}
