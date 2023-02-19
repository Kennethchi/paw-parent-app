


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/home/home_view_handlers.dart';
import 'home_bloc.dart';



class HomeBlocProvider extends InheritedWidget{

  final HomeBloc bloc;
  final Key key;
  final Widget child;

  HomeViewHandlers handlers;

  HomeBlocProvider({

    @required this.bloc, this.key, this.child}): super(key: key, child: child) {


    handlers = HomeViewHandlers();
  }

  static HomeBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(HomeBlocProvider) as HomeBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

