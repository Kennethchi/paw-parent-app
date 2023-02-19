import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'image_view_bloc.dart';

class ImageViewBlocProvider extends InheritedWidget{

  final ImageViewBloc bloc;
  final Key key;
  final Widget child;

  String imageUrl;

  ImageViewBlocProvider({@required this.bloc, @required this.imageUrl, this.key, this.child}): super(key: key, child: child);


  static ImageViewBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(ImageViewBlocProvider) as ImageViewBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}