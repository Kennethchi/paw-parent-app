import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'image_view/image_view.dart';
import 'image_viewer_bloc.dart';
import 'image_viewer_bloc_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:ui';
import 'image_viewer_views_widgets.dart';


class ImageViewerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ImageViewerBlocProvider _provider = ImageViewerBlocProvider.of(context);
    ImageViewerBloc _bloc = ImageViewerBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;



    return StreamBuilder<String>(
      stream: _bloc.getBackgroundImageStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){


        return  Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(

          ),
          child: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[



                Positioned.fill(
                  child: ExtendedImageGesturePageView.builder(

                    itemBuilder: (BuildContext context, int index) {




                      Widget extendedImage = ExtendedImage.network(
                        _provider.imagesList[index],
                        fit: BoxFit.contain,
                        mode: ExtendedImageMode.gesture,
                        enableSlideOutPage: true,

                        initGestureConfigHandler: (ExtendedImageState a) => GestureConfig(
                          inPageView: true,
                          initialScale: 1.0,
                          //you can cache gesture state even though page view page change.
                          //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
                          cacheGesture: true,
                        ),

                      );




                      return ImageView(imageUrl: _provider.imagesList[index], child: extendedImage,);

                    },
                    itemCount: _provider.imagesList.length,
                    onPageChanged: (int index) {

                      _provider.currentIndex = index;
                      _bloc.addBackgroundImageToStream(_provider.imagesList[index]);

                      _bloc.addImagesCurrentIndexToStream(index);
                    },
                    controller: PageController(
                      initialPage: _provider.currentIndex,
                    ),
                    scrollDirection: Axis.horizontal,
                  ),
                ),



                Positioned(
                  //right: screenWidth * scaleFactor * 0.25,
                  top: screenWidth * scaleFactor * 0.25,

                  child: ImageCountWidget(totalImages: _provider.imagesList.length,),
                ),


              ],
            ),
          ),
        );

      },
    );
  }
}
