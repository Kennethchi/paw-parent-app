import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'collections_page_bloc.dart';
import 'collections_page_view_handlers.dart';



class CollectionsPageBlocProvider extends InheritedWidget{

  final CollectionsPageBloc bloc;
  final Key key;
  final Widget child;

  CollectionsPageViewHandlers handlers;

  CollectionsPageBlocProvider({

    @required this.bloc, this.key, this.child}): super(key: key, child: child) {


    handlers = CollectionsPageViewHandlers();
  }

  static CollectionsPageBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(CollectionsPageBlocProvider) as CollectionsPageBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

