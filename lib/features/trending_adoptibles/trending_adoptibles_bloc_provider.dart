




import 'package:flutter/material.dart';
import 'package:paw_parent_app/features/trending_adoptibles/trending_adoptibles_bloc.dart';

import 'trending_adoptibles_view_handlers.dart';



class TrendingAdoptiblesBlocProvider extends InheritedWidget{

  final TrendingAdoptiblesBloc bloc;
  final Key key;
  final Widget child;

  TrendingAdoptiblesViewHandlers handlers;

  ScrollController scrollController;

  TrendingAdoptiblesBlocProvider({
    @required this.scrollController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = TrendingAdoptiblesViewHandlers();



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

  static TrendingAdoptiblesBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(TrendingAdoptiblesBlocProvider) as TrendingAdoptiblesBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}