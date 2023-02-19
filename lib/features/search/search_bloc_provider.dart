

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:paw_parent_app/features/search/search_bloc.dart';

import 'search_view_handlers.dart';

class SearchBlocProvider extends InheritedWidget{

  final SearchBloc bloc;
  final Key key;
  final Widget child;

  SearchViewHandlers handlers;

  TextEditingController searchTextEditingController;


  SearchBlocProvider({
    @required this.searchTextEditingController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = SearchViewHandlers();

    searchTextEditingController.addListener(() {
      bloc.searchTextBehaviorSubject.add(searchTextEditingController.text);
    });
  }

  static SearchBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(SearchBlocProvider) as SearchBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}