import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/search/search_bloc_provider.dart';
import 'package:paw_parent_app/features/search/search_view.dart';

import 'search_bloc.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  SearchBloc _bloc;
  TextEditingController searchTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = SearchBloc();
    searchTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc?.dispose();
    searchTextEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBlocProvider(
      bloc: _bloc,
      searchTextEditingController: searchTextEditingController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Search", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: SearchView(),

      ),
    );
  }
}
