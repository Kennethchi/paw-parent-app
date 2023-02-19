import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/dog_page_creation/dog_page_creation_view_handlers.dart';



import 'dog_page_creation_bloc.dart';

class DogPageCreationBlocProvider extends InheritedWidget{

  final DogPageCreationBloc bloc;
  final Key key;
  final Widget child;


  TextEditingController dogProfileNameTextEditingController;
  TextEditingController dogUsernameTextEditingController;
  TextEditingController dogAboutTextEditingController;

  DogPageCreationViewHandlers handlers;

  dynamic dynamicBloc;

  DogPageCreationBlocProvider({
    @required this.dynamicBloc,
    @required this.dogProfileNameTextEditingController,
    @required this.dogUsernameTextEditingController,
    @required this.dogAboutTextEditingController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = DogPageCreationViewHandlers();
  }

  static DogPageCreationBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(DogPageCreationBlocProvider) as DogPageCreationBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}