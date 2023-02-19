import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/authentication/authentication.dart';
import 'package:paw_parent_app/features/home/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 5), (){
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => Authentication()));
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoTheme.of(context).primaryColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset("assets/images/paw_parent_logo.png",
                  width: 300.0,
                  height: 300.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.0,),
              Text("An App for dog lovers", style: TextStyle(color: Colors.white),)
            ],
          ),

          Positioned(
            bottom: 20.0,
            child: SpinKitThreeBounce(color: Colors.white, size: 40.0,),
          )
        ],
      ),
    );
  }
}






