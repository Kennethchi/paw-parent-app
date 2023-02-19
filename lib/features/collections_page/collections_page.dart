import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/collections_page/collections_page_bloc.dart';
import 'package:paw_parent_app/features/collections_page/collections_page_bloc_provider.dart';
import 'package:paw_parent_app/features/collections_page/collections_page_view.dart';
import 'package:paw_parent_app/features/collections_page/collections_page_view_handlers.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';



class CollectionsPage extends StatefulWidget {

  UserModel currentUserModel;

  CollectionsPage({@required this.currentUserModel});

  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}


class _CollectionsPageState extends State<CollectionsPage> {

  CollectionsPageBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = CollectionsPageBloc(currentUserModel: widget.currentUserModel);
  }

  @override
  Widget build(BuildContext context) {

    return CollectionsPageBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Collections", style: TextStyle(
            color: Colors.black87
          ),),
          leading: GestureDetector(
            onTap: (){

              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
        ),

          body: CollectionsPageView()
      ),

    );
  }
}


