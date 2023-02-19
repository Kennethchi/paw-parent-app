import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/post_comments/post_comments_bloc.dart';
import 'package:paw_parent_app/features/post_comments/post_comments_bloc_provider.dart';
import 'package:paw_parent_app/features/post_comments/post_comments_view.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';



class PostComments extends StatefulWidget {

  DogPostModel dogPostModel;

  PostComments({@required this.dogPostModel});

  @override
  _PostCommentsState createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {

  PostCommentsBloc _bloc;
  ScrollController scrollController;
  TextEditingController textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = PostCommentsBloc(dogPostModel: widget.dogPostModel);
    scrollController = ScrollController();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PostCommentsBlocProvider(
      bloc: _bloc,
      scrollController: scrollController,
      textEditingController: textEditingController,
      child: Scaffold(
        body: PostCommentsView(),
      ),
    );
  }
}
