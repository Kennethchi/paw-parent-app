import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'popular_insights_tag_bloc.dart';
import 'popular_insights_tag_bloc_view_handlers.dart';



class PopularInsightsTagBlocProvider extends InheritedWidget{

  final PopularInsightsTagBloc bloc;
  final Key key;
  final Widget child;

  PopularInsightsTagViewHandlers handlers;

  ScrollController scrollController;

  PopularInsightsTagBlocProvider({
    @required this.scrollController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = PopularInsightsTagViewHandlers();


    scrollController.addListener(() {

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 50.0;

      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedInsights == false || bloc.getHasLoadedInsights == null) && bloc.getHasMoreInsights) {

          bloc.setHasLoadedInsights = true;

          bloc.loadMoreInsights(
              insightsQueryLimit: bloc.getInsightsQueryLimit,
            tag: bloc.getInsightsTag
          ).then((_){
            bloc.setHasLoadedInsights = false;
          });

        }
      }

    });

  }

  static PopularInsightsTagBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PopularInsightsTagBlocProvider) as PopularInsightsTagBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}