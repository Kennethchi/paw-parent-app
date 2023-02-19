import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/post_feed/dog_posts_bloc.dart';
import 'package:paw_parent_app/features/post_feed/post_feed_bloc.dart';
import 'package:paw_parent_app/features/post_feed/post_feed_bloc_provider.dart';
import 'package:paw_parent_app/features/post_feed/post_feed_view.dart';




class PostFeed extends StatefulWidget {
  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {

  PostFeedBloc _bloc;
  DogPostsBloc dogPostsBloc;

  ScrollController dogsScrollController;
  ScrollController postsScrollController;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _bloc = PostFeedBloc();
    dogPostsBloc = DogPostsBloc();
    
    dogsScrollController = ScrollController();
    postsScrollController = ScrollController();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    
    _bloc.dispose();
    dogPostsBloc.dispose();
    postsScrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return PostFeedBlocProvider(
      bloc: _bloc,
      dogPostsBloc: dogPostsBloc,
      dogsScrollController: dogsScrollController,
      postsScrollController: postsScrollController,
      child: PostFeedView()

    );
  }
}
