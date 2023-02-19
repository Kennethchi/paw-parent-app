import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/top_paws/top_paws_bloc.dart';
import 'package:paw_parent_app/features/top_paws/top_paws_view_handlers.dart';

class TopPawsBlocProvider extends InheritedWidget{

  final TopPawsBloc bloc;
  final Key key;
  final Widget child;

  TopPawsViewHandlers handlers;

  ScrollController scrollController;

  TopPawsBlocProvider({
    @required this.scrollController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = TopPawsViewHandlers();



    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 50.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedDogs == false || bloc.getHasLoadedDogs == null) && bloc.getHasMoreDogs) {

          bloc.setHasLoadedDogs = true;

          bloc.loadMoreDogs(
              dogQueryLimit: bloc.getDogsQueryLimit
          ).then((_){

            bloc.setHasLoadedDogs = false;
          });

        }

      }

    });

  }

  static TopPawsBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(TopPawsBlocProvider) as TopPawsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}