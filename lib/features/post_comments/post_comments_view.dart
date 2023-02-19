import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/post_comments/post_comments_bloc.dart';

import 'post_comments_bloc_provider.dart';
import 'post_comments_view_widgets.dart';



class PostCommentsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    PostCommentsBlocProvider _provider = PostCommentsBlocProvider.of(context);
    PostCommentsBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;




    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0, bottom: 10.0),
            child: CommentsTitleWidget(),
          ),

          Flexible(
            flex: 100,
            child: CustomScrollView(

              controller: _provider.scrollController,
              slivers: <Widget>[

                CommentListWidget(),

                LoadingCommentsIndicatorWidget(),
              ],
            ),
          ),

          CommentsTextFieldWidget()
        ],
      ),
    );
  }
}
