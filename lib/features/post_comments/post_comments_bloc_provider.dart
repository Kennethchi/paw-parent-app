import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'post_comments_bloc.dart';
import 'post_comments_view_handlers.dart';



class PostCommentsBlocProvider extends InheritedWidget{

  final PostCommentsBloc bloc;
  final Key key;
  final Widget child;

  PostCommentsViewHandlers handlers;

  ScrollController scrollController;
  TextEditingController textEditingController;

  PostCommentsBlocProvider({@required this.scrollController, @required this.textEditingController, @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = PostCommentsViewHandlers();



    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 0.0;


      if (maxScroll == currentScroll){

        if ((bloc.getHasLoadedComments == false || bloc.getHasLoadedComments == null) && bloc.getHasMoreComments){

          bloc.setHasLoadedComments = true;

          bloc.loadMoreComments(
              commentsPostId: bloc.getDogPostModel.postId,
              dogId: bloc.getDogPostModel.dogUserId,
              queryLimit: bloc.getCommentsQueryLimit,
              endAtValue: bloc.getQueryEndAtValue
          ).then((_){

            bloc.setHasLoadedComments = false;
          });
        }
      }

    });
  }

  static PostCommentsBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PostCommentsBlocProvider) as PostCommentsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}