import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:paw_parent_app/features/create_insight_post/create_insight_post_bloc.dart';
import 'package:paw_parent_app/features/create_insight_post/create_insight_post_bloc_provider.dart';
import 'package:paw_parent_app/main.dart';

import 'create_insight_post_view.dart';





class CreateInsightPost extends StatefulWidget {
  @override
  _CreateInsightPostState createState() => _CreateInsightPostState();
}

class _CreateInsightPostState extends State<CreateInsightPost> {

  CreateInsightPostBloc _bloc;

  TextEditingController titleTextEditingController;
  TextEditingController contentTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = CreateInsightPostBloc();
    titleTextEditingController = TextEditingController();
    contentTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    titleTextEditingController?.dispose();
    contentTextEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CreateInsightPostBlocProvider(
      bloc: _bloc,
      titleTextEditingController: titleTextEditingController,
      contentTextEditingController: contentTextEditingController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: (){

              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: CupertinoTheme.of(context).primaryColor,),
          ),
          title: Text("Create Insight", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: CreateInsightPostView(),
      ),
    );
  }
}

