import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'image_view_bloc.dart';
import 'image_view_bloc_provider.dart';
import 'image_view_views_widgets.dart';




class ImageViewViews extends StatelessWidget {

  Widget child;

  ImageViewViews({@required this.child});

  @override
  Widget build(BuildContext context) {

    ImageViewBlocProvider _provider = ImageViewBlocProvider.of(context);
    ImageViewBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[

            Center(
              child: Container(
                width: screenWidth * 0.9 ,
                height: screenWidth * 0.9,
                
                decoration: BoxDecoration(
                    image: DecorationImage(image: CachedNetworkImageProvider(_provider.imageUrl != null? _provider.imageUrl: ""), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.4)
                ),
                child: Material(

                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.4),

                    onTap: (){
                      

                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){

                        return this.child;
                      }));

                    },

                  ),
                ),
              ),
            ),


          ],
        )
    );
  }
}