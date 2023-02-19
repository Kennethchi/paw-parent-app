import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/adoption_centers/adoption_centers_view_handlers.dart';

import 'adoption_centers_bloc.dart';




class AdoptionCentersBlocProvider extends InheritedWidget{

  final AdoptionCentersBloc bloc;
  final Key key;
  final Widget child;

  AdoptionCentersViewHandlers handlers;

  ScrollController scrollController;

  AdoptionCentersBlocProvider({
    @required this.scrollController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = AdoptionCentersViewHandlers();



    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 50.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedUsers == false || bloc.getHasLoadedUsers == null) && bloc.getHasMoreUsers) {

          bloc.setHasLoadedUsers = true;

          bloc.loadMoreUsers(
              dogQueryLimit: bloc.getUsersQueryLimit
          ).then((_){

            bloc.setHasLoadedUsers = false;
          });

        }

      }

    });

  }

  static AdoptionCentersBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(AdoptionCentersBlocProvider) as AdoptionCentersBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}