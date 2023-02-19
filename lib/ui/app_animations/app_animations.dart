import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';


class AppAnimations{


  static Future<void> animateDogPostLike({@required BuildContext context})async{


    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.01),
        builder: (BuildContext context){

          Timer(Duration(milliseconds: 2000), (){
            Navigator.of(context).pop();
          });

          return Center(
            child: FlareActor(
              "assets/flare/paw_like.flr",
              animation: "Like",
              //color: RGBColors.fuchsia,
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
          );
        }
    );

    /*
    OverlayState overlay = Overlay.of(context);


    OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context){

      return Positioned(
          child: FlareActor(
            "assets/flare/paw_like.flr",
            animation: "Like",
            //color: RGBColors.fuchsia,
            alignment: Alignment.center,
            fit: BoxFit.contain,
          )
      );
    }, maintainState: true);

    overlay.insert(overlayEntry);

    await Future.delayed(Duration(milliseconds: 700), (){});

    overlayEntry.remove();
    //overlay.dispose();

     */
  }

}