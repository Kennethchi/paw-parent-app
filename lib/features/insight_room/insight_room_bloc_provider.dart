



import 'insight_room_bloc.dart';
import 'package:flutter/material.dart';

import 'insight_room_view_handers.dart';

class InsightRoomBlocProvider extends InheritedWidget{

  final InsightRoomBloc bloc;
  final Key key;
  final Widget child;

  InsightRoomViewHandlers handlers;

  InsightRoomBlocProvider({

    @required this.bloc, this.key, this.child}): super(key: key, child: child) {


    handlers = InsightRoomViewHandlers();
  }

  static InsightRoomBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(InsightRoomBlocProvider) as InsightRoomBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

