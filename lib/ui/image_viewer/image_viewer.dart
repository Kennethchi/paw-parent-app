import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'image_viewer_bloc.dart';
import 'image_viewer_bloc_provider.dart';
import 'image_viewer_views.dart';




class ImageViewer extends StatefulWidget{

  List<String> imageList;
  int currentIndex;


  ImageViewer({@required this.imageList, @required this.currentIndex});


  _ImageViewerState createState() => new _ImageViewerState();
}



class _ImageViewerState extends State<ImageViewer>{


  int _currentIndex = 0;
  ImageViewerBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = ImageViewerBloc();



    if (
        widget.currentIndex == null
        || (widget.currentIndex > widget.imageList.length - 1)
        || widget.currentIndex < 0
    ){
      _currentIndex = 0;
    }
    else{
      _currentIndex = widget.currentIndex;
    }



    _bloc.addBackgroundImageToStream(widget.imageList[_currentIndex]);

    _bloc.addImagesCurrentIndexToStream(this._currentIndex);
  }


  @override
  void dispose() {
    // TODO: implement dispose

    // clears gesture cache after dispose
    clearGestureDetailsCache();

    _bloc.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ImageViewerBlocProvider(
      bloc: this._bloc,
      currentIndex: this._currentIndex,
      imagesList: widget.imageList,
      child: Scaffold(
        backgroundColor: RGBColors.light_yellow,
        body: ImageViewerView(),
      )
    );
  }
  

}


