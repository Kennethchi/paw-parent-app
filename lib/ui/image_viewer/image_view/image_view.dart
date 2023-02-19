import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';

import 'image_view_bloc.dart';
import 'image_view_bloc_provider.dart';
import 'image_view_views.dart';
import 'image_view_views_widgets.dart';




class ImageView extends StatefulWidget {

  String imageUrl;
  Widget child;

  ImageView({@required this.imageUrl, @required this.child});


  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {



  ImageViewBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = ImageViewBloc();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return ImageViewBlocProvider(
      bloc: _bloc,
      imageUrl: widget.imageUrl,
      child: Scaffold(

        backgroundColor: Colors.transparent,

        body: CupertinoPageScaffold(
            backgroundColor: Colors.transparent,
            navigationBar: CupertinoNavigationBar(
                backgroundColor: Colors.transparent,
                border: Border.all(style: BorderStyle.none),
            ),

            child: ImageViewViews(child: widget.child,)
        ),
      ),
    );;
  }
}
