import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/top_paws/top_paws_bloc.dart';
import 'package:paw_parent_app/features/top_paws/top_paws_bloc_provider.dart';
import 'package:paw_parent_app/features/top_paws/top_paws_views.dart';




class TopPaws extends StatefulWidget {
  @override
  _TopPawsState createState() => _TopPawsState();
}

class _TopPawsState extends State<TopPaws> {

  TopPawsBloc _bloc;
  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = TopPawsBloc();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TopPawsBlocProvider(
      bloc: _bloc,
      scrollController: scrollController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Top Paws", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: TopPawsView(),
      ),
    );
  }
}
