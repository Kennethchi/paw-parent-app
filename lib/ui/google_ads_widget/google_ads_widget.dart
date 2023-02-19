import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';


class GoogleAdsWidget extends StatefulWidget {

  double height;

  GoogleAdsWidget({this.height = 200.0});

  @override
  _GoogleAdsWidgetState createState() => _GoogleAdsWidgetState();
}

class _GoogleAdsWidgetState extends State<GoogleAdsWidget> {

  static const String _adUnitID = "ca-app-pub-6607785367659956/8165291327";

  NativeAdmobController _nativeAdmobController;
  StreamSubscription _adLoadStateSubscription;

  double _height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _height = widget.height;

    _nativeAdmobController = NativeAdmobController();

    _adLoadStateSubscription = _nativeAdmobController.stateChanged.listen((AdLoadState adLoadState) {
      switch(adLoadState){
        case AdLoadState.loading:
          setState(() {
            _height = 0.0;
          });
          break;
        case AdLoadState.loadError:
          // TODO: Handle this case.
          break;
        case AdLoadState.loadCompleted:
          setState(() {
            setState(() {
              _height = widget.height;
            });
          });
          break;
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose

    _adLoadStateSubscription.cancel();
    _nativeAdmobController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          height: _height,
          child: NativeAdmob(
            // Your ad unit id
            adUnitID: _adUnitID,
            //adUnitID: "ca-app-pub-3940256099942544/2247696110",
            controller: _nativeAdmobController,
            type: NativeAdmobType.full,
            //options: NativeAdmobOptions(),
            // Don't show loading widget when in loading state
            loading: CircularProgressIndicator(),
            error: Text("Failed to load Ad"),

          ),

        ),
      ),
    );
  }
}
