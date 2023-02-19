import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dog_page_bloc.dart';
import 'dog_page_view_handlers.dart';


class DogPageBlocProvider extends InheritedWidget{

  final DogPageBloc bloc;
  final Key key;
  final Widget child;

  DogPageViewHandlers handlers;

  ScrollController scrollController;


  DogPageBlocProvider({@required this.scrollController, @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = DogPageViewHandlers();


    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 50.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedPosts == false || bloc.getHasLoadedPosts == null) && bloc.getHasMorePosts) {

          bloc.setHasLoadedPosts = true;

          bloc.loadMorePosts(
              userId: bloc.getOwnerUserModel.userId,
              dogId: bloc.getDogModel.userId,
              dogQueryLimit: bloc.getPostsQueryLimit
          ).then((_){

            bloc.setHasLoadedPosts = false;
          });

        }

      }

    });

  }

  static DogPageBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(DogPageBlocProvider) as DogPageBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}