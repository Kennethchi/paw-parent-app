import 'package:flutter/material.dart';

class DogLoaderWidget extends StatefulWidget {

  double width;
  double height;

  DogLoaderWidget({this.width = 150.0, this.height = 150.0});

  @override
  _DogLoaderWidgetState createState() => _DogLoaderWidgetState();
}

class _DogLoaderWidgetState extends State<DogLoaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/dog_loader.gif",
      width: widget.width,
      height: widget.height,
    );
  }
}
