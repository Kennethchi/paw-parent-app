import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post_bloc.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post_bloc_provider.dart';






class CreateDogPostViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    CreateDogPostBlocProvider _provider = CreateDogPostBlocProvider.of(context);
    CreateDogPostBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(_bloc.getDogModel != null && _provider.launchedFromHomePage != null && _provider.launchedFromHomePage
              ? "Create Post For ${_bloc.getDogModel.profileName}"
              : "Create Dog Post", style: TextStyle(
              color: CupertinoTheme.of(context).primaryColor,
          ), maxLines: 2, textAlign: TextAlign.center,),
        ),
        elevation: 0.0,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios, color: CupertinoTheme.of(context).primaryColor,),
        ),
        actions: [
          StreamBuilder<bool>(
              stream: _bloc.showCreatePostButtonBehaviorSubject.stream,
              builder: (context, snapshot) {

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                    color: _themeData.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    borderRadius: BorderRadius.circular(15.0),
                    onPressed: snapshot.hasData && snapshot.data? (){

                      _provider.handlers.createPost(pageContext: context);
                    }: null,
                    child: Text("Create", style: TextStyle(
                        fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                        fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                  ),
                );
              }
          )
        ],
      ),

      body: Container(
        child: StreamBuilder<String>(
            stream: _bloc.postTypeBehaviorSubject.stream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

              if (snapshot.hasData){

                switch(snapshot.data){

                  case DogPostType.image:
                    return CreateImagePostView();
                  default:
                    return Container(
                      child: Center(
                        child: Text("Unknown Post Type", style: TextStyle(fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                      ),
                    );

                }

              }
              else{
                return Container(
                  child: Center(
                    child: Text("No Data", style: TextStyle(fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                  ),
                );
              }

            }
        ),
      ),
    );
  }
}




class CreateImagePostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    CreateDogPostBlocProvider _provider = CreateDogPostBlocProvider.of(context);
    CreateDogPostBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return SafeArea(
      child: StreamBuilder<List<String>>(
          stream: _bloc.imagesPathBehaviorSubject.stream,
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            return Container(
              child: SingleChildScrollView(
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[


                    Container(
                      child: Container(
                        height: screenHeight * 0.5,
                        color: Colors.black,
                        child: snapshot.data == null || snapshot.data.isEmpty
                            ? Container(child: Center(child: Text("No Images Selected", style: TextStyle(
                            color: _themeData.barBackgroundColor,
                            fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                        ),)),)
                            : Container(
                              child: Swiper(

                          controller: _provider.imagesSwiperController,
                          itemBuilder: (BuildContext context, int index) {
                              return Image.file(File(snapshot.data[index]), fit: BoxFit.contain,);
                          },
                          itemCount: snapshot.data.length,
                          viewportFraction: 0.8,
                          scale: 0.8,
                          loop: false
                        ),
                            ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [

                          Container(
                            child: StreamBuilder<List<String>>(
                                stream: _bloc.imagesPathBehaviorSubject,
                                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                                  return Center(
                                    child: Wrap(

                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,

                                      children: <Widget>[

                                        if (snapshot.hasData)

                                          for (int index = 0; index < snapshot.data.length; ++index)
                                            Padding(
                                              padding: EdgeInsets.all(5.0),

                                              child: GestureDetector(

                                                onTap: (){


                                                  _provider.handlers.showChangeSelectedUploadImageOptionModal(
                                                    pageContext: context,
                                                    imageToChangeIndexInList: index,
                                                  );

                                                },

                                                child: Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      color: _themeData.primaryColor.withOpacity(0.1),
                                                      image: DecorationImage(image: FileImage(File(snapshot.data[index])), fit: BoxFit.cover)
                                                  ),
                                                  child: Container(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: _themeData.primaryColor.withOpacity(0.3),
                                                      ),
                                                      child: Icon(Icons.add, color: Colors.white,)
                                                  ),
                                                ),
                                              ),
                                            ),

                                        StreamBuilder<bool>(
                                            stream: _bloc.isPostImagesLimitReachedBehaviorSubject.stream,
                                            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

                                              if (snapshot.hasData && snapshot.data == true){

                                                return Container();
                                              }
                                              else{

                                                return GestureDetector(

                                                  onTap: (){

                                                    _provider.handlers.showUploadImageOptionModal(pageContext: context);
                                                  },

                                                  child: Padding(
                                                    padding: EdgeInsets.all(10.0),
                                                    child: Container(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: _themeData.primaryColor,
                                                      ),
                                                      child: Icon(Icons.add, color: Colors.white,),
                                                    ),
                                                  ),
                                                );
                                              }


                                            }
                                        )

                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("You can add up to"),
                                SizedBox(width: 5.0,),
                                Text("${AppDataLimits.numberOfImagesPerPost}", style: TextStyle(
                                    color: _themeData.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Theme.of(context).textTheme.subtitle1.fontSize),
                                ),
                                SizedBox(width: 5.0,),
                                Text("Images"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          Text("Caption", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Theme.of(context).textTheme.headline6.fontSize
                          ),),
                          SizedBox(height: 20.0,),

                          TextField(
                            controller: _provider.postTextEditingController,
                            maxLines: null,
                            cursorColor: _themeData.primaryColor,
                            decoration: InputDecoration(
                              border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  gapPadding: 0.0,
                                  borderSide: BorderSide(color: _themeData.primaryColor, width: 1000.0)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  gapPadding: 0.0,
                                  borderSide: BorderSide(color: _themeData.primaryColor, width: 2.0)
                              ),
                              //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                              focusColor: _themeData.primaryColor,
                              hintText: "Write a Caption...",
                              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 50.0,)

                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}


