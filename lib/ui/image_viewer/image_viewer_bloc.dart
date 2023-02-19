import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';



abstract class BlocBlueprint{

  void dispose();
}


class ImageViewerBloc implements BlocBlueprint{


  BehaviorSubject<String> _backgroundImageBehaviorSubject =  BehaviorSubject<String>();
  Stream<String> get getBackgroundImageStream => _backgroundImageBehaviorSubject.stream;
  StreamSink<String> get _getBackgroundImageSink => _backgroundImageBehaviorSubject.sink;


  // Streaming images index streaming
  BehaviorSubject<int> _imagesCurrentIndexBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getImagesCurrentIndexStream => _imagesCurrentIndexBehaviorSubject.stream;
  StreamSink<int> get _getImagesCurrentIndexSink => _imagesCurrentIndexBehaviorSubject.sink;




  ImageViewerBloc(){

  }



  void addImagesCurrentIndexToStream(int imagesCurrentIndex){
    _getImagesCurrentIndexSink.add(imagesCurrentIndex);
  }

  void addBackgroundImageToStream(String backgroundImage){
    _getBackgroundImageSink.add(backgroundImage);
  }



  @override
  void dispose() {
    _backgroundImageBehaviorSubject?.close();
    _imagesCurrentIndexBehaviorSubject?.close();
  }
}


