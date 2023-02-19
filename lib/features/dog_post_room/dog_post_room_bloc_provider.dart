import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



import 'dog_post_room_bloc.dart';
import 'dog_post_room_view_handlers.dart';

class DogPostRoomBlocProvider extends InheritedWidget{

  final DogPostRoomBloc bloc;
  final Key key;
  final Widget child;

  DogPostRoomViewHandlers handlers;

  DogPostRoomBlocProvider({

    @required this.bloc, this.key, this.child}): super(key: key, child: child) {


    handlers = DogPostRoomViewHandlers();
  }

  static DogPostRoomBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(DogPostRoomBlocProvider) as DogPostRoomBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

