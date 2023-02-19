import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/dog_page/dog_page.dart';
import 'package:paw_parent_app/features/dog_post_room/dog_post_room_view_handlers.dart';
import 'package:paw_parent_app/features/post_comments/post_comments.dart';
import 'package:paw_parent_app/features/profile/profile.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/ui/app_animations/app_animations.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dog_post_room_bloc.dart';
import 'dog_post_room_bloc_provider.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as time_ago_provider;



class DogPostRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    DogPostRoomBlocProvider _provider = DogPostRoomBlocProvider.of(context);
    DogPostRoomBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return StreamBuilder<DogPostModel>(
      stream: _bloc.dogPostModelBehaviorSubject,
      builder: (context, snapshot) {

        if(snapshot.hasData){
          return Column(
            children: [

              Container(
                child: Container(
                  height: screenHeight * 0.5,
                  color: Colors.black,
                  child: snapshot.data == null || snapshot.data.postData == null
                      ? Container()
                      : Container(
                    child: Swiper(

                        itemBuilder: (BuildContext context, int index) {

                          return CachedNetworkImage(
                              imageUrl: ImageModel.fromJson(snapshot.data.postData).imagesUrl[index],
                            fit: BoxFit.contain,
                          );

                        },
                        itemCount: ImageModel.fromJson(snapshot.data.postData).imagesUrl.length,
                        viewportFraction: 0.8,
                        scale: 0.8,
                        loop: false
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [



                        PostLikeWidget(dogPostModel: snapshot.data,),
                        SizedBox(width: 20.0,),
                        IconButton(icon: Icon(FontAwesomeIcons.commentAlt), onPressed: (){

                          DogPostRoomViewHandlers.showPostComments(pageContext: context, dogPostModel: snapshot.data);
                        }),
                        SizedBox(width: 10.0,),
                        StreamBuilder<DocumentSnapshot>(
                            stream: _provider.bloc.getCurrentUserStreamModel(currentUserId: _bloc.getCurrentUserId),
                            builder: (context, currentUserModelStreamSnapshot) {

                              switch(currentUserModelStreamSnapshot.connectionState){

                                case ConnectionState.none: case ConnectionState.waiting:
                                return Container();
                                case ConnectionState.active: case ConnectionState.done:

                                if (currentUserModelStreamSnapshot.hasData
                                    && currentUserModelStreamSnapshot.data.data != null
                                    && UserModel.fromJson(currentUserModelStreamSnapshot.data.data).dogPostsBookmarkList.contains(snapshot.data.postId)){

                                  return IconButton(icon: Icon(Icons.bookmark, color: _themeData.primaryColor,), onPressed: (){

                                    BasicUI.showSnackBar(
                                      context: context,
                                      message: "Already added to Collections", textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 1),
                                    );
                                  });

                                }
                                else{

                                  return IconButton(icon: Icon(Icons.bookmark_border, color: _themeData.primaryColor,), onPressed: (){

                                    _provider.bloc.bookmarkDogPost(postId: snapshot.data.postId, currentUserId: _bloc.getCurrentUserId).then((_){
                                      BasicUI.showSnackBar(
                                          context: context,
                                          message: "Added to Collections",
                                          textColor: _themeData.primaryColor,
                                          duration: Duration(seconds: 1));
                                    });
                                  });

                                }
                              }

                            }
                        ),
                        SizedBox(width: 10.0,),

                        IconButton(icon: Icon(Icons.share), onPressed: (){

                          launch(AppConstants.android_app_link);
                        }),



                      ],
                    ),
                    SizedBox(height: 20.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => DogPage(
                          dogModel: snapshot.data.dogModel, ownerUserModel: snapshot.data.ownerUserModel,
                        )));
                      },
                      child: ListTile(
                        leading: Container(
                          child: snapshot.data.dogModel.profileImageThumb != null && snapshot.data.dogModel.profileImageThumb.isNotEmpty? CircleAvatar(
                            radius: 20.0,
                            backgroundColor: _themeData.primaryColor,
                            backgroundImage: CachedNetworkImageProvider(snapshot.data.dogModel.profileImageThumb),
                          ): CircleAvatar(
                            radius: 20.0,
                            backgroundColor: _themeData.primaryColor,
                            child: Center(
                              child: Text(snapshot.data.dogModel.profileName.characters.first.toUpperCase(), style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                              ),),
                            ),
                          ),
                        ),
                        title: Text(snapshot.data.dogModel.profileName, style: TextStyle(
                            color: Colors.black,
                            fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                        ),),
                        subtitle: Text(time_ago_provider.format(snapshot.data.dogModel.creationTimestamp.toDate()), style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: Theme.of(context).textTheme.caption.fontSize
                        ),),
                      ),
                    ),
                    SizedBox(height: 20.0,),


                    Text(snapshot.data.postCaption, style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      height: 1.5
                    ),)
                  ],
                ),
              )

            ],
          );
        }
        else{
          return Center(child: DogLoaderWidget(width: 100.0, height: 100.0,));
        }

      }
    );
  }
}





class PostLikeWidget extends StatelessWidget{

  DogPostModel dogPostModel;

  PostLikeWidget({@required this.dogPostModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    DogPostRoomBlocProvider _provider = DogPostRoomBlocProvider.of(context);
    DogPostRoomBloc _bloc = _provider.bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;



    return Container(
      child: StreamBuilder<Event>(
        stream: _bloc.getIfUserLikedPostStream(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _provider.bloc.getCurrentUserId),
        builder: (BuildContext context, AsyncSnapshot<Event> userLikedPostSnapshot){

          switch(userLikedPostSnapshot.connectionState){
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return SpinKitPulse(color: _themeData.primaryColor, size: 10.0,);
            case ConnectionState.active:  case ConnectionState.done:

            return GestureDetector(
              onTap: (){

                if (userLikedPostSnapshot.data.snapshot.value == null){

                  _bloc.addPostLike(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _provider.bloc.getCurrentUserId);

                  AppAnimations.animateDogPostLike(context: context);
                }
                else{

                  _bloc.removePostLike(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _provider.bloc.getCurrentUserId);
                }

              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  if (userLikedPostSnapshot.data.snapshot.value == null)
                    Icon(FontAwesomeIcons.heart, color: _themeData.primaryColor,)
                  else
                    Icon(FontAwesomeIcons.solidHeart, color: Colors.pinkAccent,),

                  SizedBox(width: 5.0,),

                  Flexible(
                    child: StreamBuilder<Event>(
                      stream: _bloc.getNumberOfPostLikesStream(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId),
                      builder: (BuildContext context, AsyncSnapshot<Event> snapshot){

                        print(snapshot.connectionState);

                        switch(snapshot.connectionState){
                          case ConnectionState.none: case ConnectionState.done:
                          return Container();
                          case ConnectionState.waiting:
                            return SpinKitPulse(color: Colors.white, size: 15.0,);
                          case ConnectionState.active:
                            if (snapshot.hasData && snapshot.data.snapshot.value != null){
                              return Text(StringUtils.formatNumber(snapshot.data.snapshot.value), style: TextStyle(color: _themeData.primaryColor, fontWeight: FontWeight.bold),);
                            }

                            else{
                              return Container(
                                child: Text("0", style: TextStyle(color: _themeData.primaryColor, fontWeight: FontWeight.bold)),
                              );
                            }
                        }

                      },
                    ),
                  )
                ],
              ),
            );

          }

        },
      ),
    );

  }
}
