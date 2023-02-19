import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/profile/profile_view_handlers.dart';

import 'profile_bloc.dart';

class ProfileBlocProvider extends InheritedWidget{

  final ProfileBloc bloc;
  final Key key;
  final Widget child;

  ProfileViewHandlers handlers;

  ScrollController scrollController;


  ProfileBlocProvider({@required this.scrollController, @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = ProfileViewHandlers();


    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 50.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedDogs == false || bloc.getHasLoadedDogs == null) && bloc.getHasMoreDogs) {

          bloc.setHasLoadedDogs = true;

          bloc.loadMoreDogs(
              profileUserId: bloc.getProfileUserId,
              dogQueryLimit: bloc.getDogsQueryLimit
          ).then((_){

            bloc.setHasLoadedDogs = false;
          });

        }

      }

    });


  }

  static ProfileBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(ProfileBlocProvider) as ProfileBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}