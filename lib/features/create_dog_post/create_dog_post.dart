import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post_bloc.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post_bloc_provider.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post_view_handlers.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post_views.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';




class CreateDogPost extends StatefulWidget {

  UserModel currentUserModel;
  DogModel dogModel;
  dynamic dynamicBloc;
  bool launchedFromHomePage;

  CreateDogPost({@required this.currentUserModel, @required this.dogModel, this.dynamicBloc, this.launchedFromHomePage});


  @override
  _CreateDogPostState createState() => _CreateDogPostState();
}

class _CreateDogPostState extends State<CreateDogPost> {

  CreateDogPostBloc _bloc;
  TextEditingController postTextEditingController;

  SwiperController imagesSwiperController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = CreateDogPostBloc(currentUserModel: widget.currentUserModel, dogModel: widget.dogModel);

    postTextEditingController = TextEditingController();

    imagesSwiperController = SwiperController();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    postTextEditingController?.dispose();
    imagesSwiperController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CreateDogPostBlocProvider(
      bloc: _bloc,
      dynamicBloc: widget.dynamicBloc,
      launchedFromHomePage: widget.launchedFromHomePage,
      imagesSwiperController: imagesSwiperController,
      postTextEditingController: postTextEditingController,
      child: CreateDogPostViews()
    );

  }
}
