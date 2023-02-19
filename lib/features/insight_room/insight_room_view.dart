import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/profile/profile.dart';
import 'package:paw_parent_app/main.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'insight_room_bloc.dart';
import 'insight_room_bloc_provider.dart';



class InsightRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    InsightRoomBlocProvider _provider = InsightRoomBlocProvider.of(context);
    InsightRoomBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<InsightModel>(
      stream: _bloc.insightModelBehaviorSubject,
      builder: (context, snapshot) {

        if (snapshot.hasData){
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  SizedBox(height: 20.0,),

                  Container(
                    height: 250.0,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25.0),
                        image: DecorationImage(
                            image:  CachedNetworkImageProvider(ImageModel.fromJson(snapshot.data.insightData).imagesUrl.first),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Wrap(
                    spacing: 10.0,
                    children: snapshot.data.tags.map((dynamic tag){
                      return Text("#" + tag, style: TextStyle(color: _themeData.primaryColor),);
                    }).toList(),
                  ),
                  SizedBox(height: 10.0,),
                  Text(snapshot.data.insightTitle, style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline5.fontSize,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 5.0,),

                  Row(
                    children: [
                      Icon(Icons.remove_red_eye, color: Colors.black54,),
                      SizedBox(width: 5.0,),
                      Text("seen", style: TextStyle(
                          fontSize: Theme.of(context).textTheme.caption.fontSize
                      ),),
                      SizedBox(width: 5.0,),
                      FutureBuilder<int>(
                        future: _bloc.getNumberOfInsightSeens(insightId: snapshot.data.insightId),
                        builder: (context, numSeensSnapshot) {
                          return Text(numSeensSnapshot.hasData && numSeensSnapshot.data != null? "${numSeensSnapshot.data}": "0", style: TextStyle(
                            fontSize: Theme.of(context).textTheme.caption.fontSize
                          ),);
                        }
                      )
                    ],
                  ),
                  SizedBox(height: 30.0,),

                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserModel: snapshot.data.userModel,)));
                    },
                    child: Row(
                      children: [
                        Container(
                          child: snapshot.data.userModel.profileImageThumb != null && snapshot.data.userModel.profileImageThumb.isNotEmpty? CircleAvatar(
                            radius: 20.0,
                            backgroundColor: _themeData.primaryColor,
                            backgroundImage: CachedNetworkImageProvider(snapshot.data.userModel.profileImageThumb),
                          ): CircleAvatar(
                            radius: 20.0,
                            backgroundColor: _themeData.primaryColor,
                            child: Center(
                              child: Text(snapshot.data.userModel.profileName.characters.first.toUpperCase(), style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                              ),),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.0,),
                        Text(snapshot.data.userModel.profileName, style: TextStyle(
                            color: Colors.black,
                            fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                        ),)
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0,),

                  Text(snapshot.data.insightContent, style: TextStyle(
                    height: 1.5,
                    fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                  ),),
                  SizedBox(height: 75.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [


                      InsightLikeWidget(insightModel: snapshot.data,),

                      StreamBuilder<DocumentSnapshot>(
                        stream: _bloc.getCurrentUserStreamModel(currentUserId: _bloc.getCurrentUserId),
                        builder: (context, currentUserModelStreamSnapshot) {

                          switch(currentUserModelStreamSnapshot.connectionState){

                            case ConnectionState.none: case ConnectionState.waiting:
                              return Container();
                            case ConnectionState.active: case ConnectionState.done:

                            if (currentUserModelStreamSnapshot.hasData
                                && currentUserModelStreamSnapshot.data.data != null
                                && UserModel.fromJson(currentUserModelStreamSnapshot.data.data).insightsBookmarkList.contains(snapshot.data.insightId)){

                              return GestureDetector(
                                onTap: (){

                                  BasicUI.showSnackBar(
                                    context: context,
                                    message: "Already added to Collections", textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 1),
                                  );

                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundColor: _themeData.primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FittedBox(child: Icon(Icons.bookmark_border, color: Colors.white,)),
                                      ),
                                    ),
                                    SizedBox(height: 10.0,),
                                    Text("Found \nin \nCollections", textAlign: TextAlign.center,)
                                  ],
                                ),
                              );

                            }
                            else{
                              return GestureDetector(
                                onTap: (){

                                  _bloc.bookmarkInsight(insightId: snapshot.data.insightId, currentUserId: _bloc.getCurrentUserId).then((_){
                                    BasicUI.showSnackBar(context: context, message: "Added to Collections", textColor: _themeData.primaryColor, duration: Duration(seconds: 1));
                                  });

                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: _themeData.primaryColor, width: 3.0)
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FittedBox(child: Icon(Icons.bookmark_border, color: _themeData.primaryColor,)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0,),
                                    Text("Add to \nCollections", textAlign: TextAlign.center,)
                                  ],
                                ),
                              );
                            }
                          }

                        }
                      ),

                      GestureDetector(
                        onTap: (){
                          launch(AppConstants.android_app_link).then((_){
                            print(_);
                            _bloc.increaseInsightNumShares(insightId: snapshot.data.insightId);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.share, color: Colors.black54,),
                            SizedBox(width: 10.0,),
                            FutureBuilder<int>(
                                future: _bloc.getNumberOfInsightShares(insightId: snapshot.data.insightId),
                                builder: (context, numSharesSnapshot) {

                                  return Text(numSharesSnapshot.hasData && numSharesSnapshot.data != null? StringUtils.formatNumber(numSharesSnapshot.data) : "0", style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),);
                                }
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 75.0,)
                ],
              ),
            ),
          );
        }
        else{
          return Center(
            child: DogLoaderWidget(width: 100.0, height: 100.0,),
          );
        }

      }
    );
  }
}




class InsightLikeWidget extends StatelessWidget {

  InsightModel insightModel;

  InsightLikeWidget({@required this.insightModel});

  @override
  Widget build(BuildContext context) {


    InsightRoomBlocProvider _provider = InsightRoomBlocProvider.of(context);
    InsightRoomBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: StreamBuilder<Event>(
        stream: _bloc.getIfUserLikedInsightStream(insightId: insightModel.insightId, currentUserId: _bloc.getCurrentUserId),
        builder: (BuildContext context, AsyncSnapshot<Event> userLikedPostSnapshot){

          switch(userLikedPostSnapshot.connectionState){
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return Container();
            case ConnectionState.active:  case ConnectionState.done:

            return GestureDetector(
              onTap: (){

                if (userLikedPostSnapshot.data.snapshot.value == null){

                  _bloc.addInsightLike(insightId: insightModel.insightId, currentUserId: _bloc.getCurrentUserId);
                }
                else{

                  _bloc.removeInsightLike(insightId: insightModel.insightId, currentUserId: _bloc.getCurrentUserId);
                }

              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  if (userLikedPostSnapshot.data.snapshot.value == null)
                    Icon(FontAwesomeIcons.heart, color: Colors.black54,)
                  else
                    Icon(FontAwesomeIcons.solidHeart, color: Colors.pinkAccent,),

                  SizedBox(width: 10.0,),

                  Flexible(
                    child: StreamBuilder<Event>(
                      stream: _bloc.getNumberOfInsightLikesStream(insightId: insightModel.insightId),
                      builder: (BuildContext context, AsyncSnapshot<Event> snapshot){

                        print(snapshot.connectionState);

                        switch(snapshot.connectionState){
                          case ConnectionState.none: case ConnectionState.done:
                          return Container();
                          case ConnectionState.waiting:
                            return Container();
                          case ConnectionState.active:
                            if (snapshot.hasData && snapshot.data.snapshot.value != null){
                              return Text(StringUtils.formatNumber(snapshot.data.snapshot.value), style: TextStyle(fontWeight: FontWeight.bold),);
                            }

                            else{
                              return Container(
                                child: Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
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
