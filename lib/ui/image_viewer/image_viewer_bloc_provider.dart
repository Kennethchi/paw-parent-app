import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'image_viewer_bloc.dart';



class ImageViewerBlocProvider extends InheritedWidget{

  final ImageViewerBloc bloc;
  final Key key;
  final Widget child;

  int currentIndex;
  List<String> imagesList;


  ImageViewerBlocProvider({
    @required this.bloc, @required this.currentIndex, @required this.imagesList, this.key, this.child}): super(key: key, child: child
  );


  static ImageViewerBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(ImageViewerBlocProvider) as ImageViewerBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}