import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'create_insight_post_bloc.dart';
import 'create_insight_post_view_handlers.dart';



class CreateInsightPostBlocProvider extends InheritedWidget{

  final CreateInsightPostBloc bloc;
  final Key key;
  final Widget child;

  CreateInsightPostViewHandlers handlers;


  TextEditingController titleTextEditingController;
  TextEditingController contentTextEditingController;

  CreateInsightPostBlocProvider({
    @required this.titleTextEditingController,
    @required this.contentTextEditingController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {


    handlers = CreateInsightPostViewHandlers();
  }

  static CreateInsightPostBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(CreateInsightPostBlocProvider) as CreateInsightPostBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
