
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/post_feed/dog_posts_bloc.dart';

import 'post_feed_bloc.dart';



class PostFeedBlocProvider extends InheritedWidget{

  final PostFeedBloc bloc;
  final DogPostsBloc dogPostsBloc;
  final Key key;
  final Widget child;

  ScrollController dogsScrollController;
  ScrollController postsScrollController;

  PostFeedBlocProvider({
    @required this.dogsScrollController,
    @required this.postsScrollController,
    @required this.dogPostsBloc,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {


    dogsScrollController.addListener((){

      double maxScroll = dogsScrollController.position.maxScrollExtent;
      double currentScroll = dogsScrollController.position.pixels;
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



    postsScrollController.addListener((){

      double maxScroll = postsScrollController.position.maxScrollExtent;
      double currentScroll = postsScrollController.position.pixels;
      double deltaBottom = 50.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((dogPostsBloc.getHasLoadedPosts == false || dogPostsBloc.getHasLoadedPosts == null) && dogPostsBloc.getHasMorePosts) {

          dogPostsBloc.setHasLoadedPosts = true;

          switch(dogPostsBloc.get_dog_post_query_type){

            case DOG_POST_QUERY_TYPE.FEVORITES:
              dogPostsBloc.loadMorePosts(postsQueryLimit: dogPostsBloc.getPostsQueryLimit, dog_post_query_type: DOG_POST_QUERY_TYPE.FEVORITES).then((_){
                dogPostsBloc.setHasLoadedPosts = false;
              });
              break;
            case DOG_POST_QUERY_TYPE.FOLLOWING:

              if (dogPostsBloc.getCurrentUserModel != null){
                dogPostsBloc.loadMorePosts(postsQueryLimit: dogPostsBloc.getPostsQueryLimit,
                    dog_post_query_type: DOG_POST_QUERY_TYPE.FOLLOWING,
                    currentUserDogFollowingList: dogPostsBloc.getCurrentUserDogsFollowingList
                ).then((_){
                  dogPostsBloc.setHasLoadedPosts = false;
                });
              }

              break;
            case DOG_POST_QUERY_TYPE.TRENDING:
              dogPostsBloc.loadMorePosts(postsQueryLimit: dogPostsBloc.getPostsQueryLimit, dog_post_query_type: DOG_POST_QUERY_TYPE.TRENDING).then((_){
                dogPostsBloc.setHasLoadedPosts = false;
              });
              break;
            default:
              dogPostsBloc.loadMorePosts(postsQueryLimit: dogPostsBloc.getPostsQueryLimit).then((_){
                dogPostsBloc.setHasLoadedPosts = false;
              });
          }

        }

      }

    });

  }

  static PostFeedBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PostFeedBlocProvider) as PostFeedBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}