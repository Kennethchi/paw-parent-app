import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';




import 'insights_page_bloc.dart';
import 'insights_page_view_handlers.dart';

class InsightsPageBlocProvider extends InheritedWidget{

  final InsightsPageBloc bloc;
  final Key key;
  final Widget child;

  InsightsPageViewHandlers handlers;

  ScrollController insightsFeedScrollController;


  InsightsPageBlocProvider({
    @required this.insightsFeedScrollController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = InsightsPageViewHandlers();

    insightsFeedScrollController.addListener(() {

      double maxScroll = insightsFeedScrollController.position.maxScrollExtent;
      double currentScroll = insightsFeedScrollController.position.pixels;
      double deltaBottom = 50.0;

      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedInsights == false || bloc.getHasLoadedInsights == null) && bloc.getHasMoreInsights) {

          bloc.setHasLoadedInsights = true;

          bloc.loadMoreInsights(
              insightsQueryLimit: bloc.getInsightsQueryLimit
          ).then((_){
            bloc.setHasLoadedInsights = false;
          });

        }
      }

    });


  }

  static InsightsPageBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(InsightsPageBlocProvider) as InsightsPageBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

