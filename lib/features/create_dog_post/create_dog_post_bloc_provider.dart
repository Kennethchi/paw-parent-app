
import 'package:flutter_swiper/flutter_swiper.dart';

import 'create_dog_post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'create_dog_post_view_handlers.dart';



class CreateDogPostBlocProvider extends InheritedWidget{

  final CreateDogPostBloc bloc;
  final Key key;
  final Widget child;

  CreateDogPostViewHandlers handlers;

  TextEditingController postTextEditingController;

  SwiperController imagesSwiperController;

  dynamic dynamicBloc;

  bool launchedFromHomePage;

  CreateDogPostBlocProvider({
    @required this.imagesSwiperController,
    @required this.postTextEditingController,
    @required this.dynamicBloc,
    @required this.launchedFromHomePage,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = CreateDogPostViewHandlers();

  }

  static CreateDogPostBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(CreateDogPostBlocProvider) as CreateDogPostBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
