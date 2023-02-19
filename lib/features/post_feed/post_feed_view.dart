import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/adoption_centers/adoption_centers.dart';
import 'package:paw_parent_app/features/chat_space/chat_space.dart';
import 'package:paw_parent_app/features/dog_page/dog_page.dart';
import 'package:paw_parent_app/features/dog_page/dog_page_bloc_provider.dart';
import 'package:paw_parent_app/features/dog_post_room/dog_post_room.dart';
import 'package:paw_parent_app/features/post_feed/post_feed_bloc.dart';
import 'package:paw_parent_app/features/search/search.dart';
import 'package:paw_parent_app/features/top_paws/top_paws.dart';
import 'package:paw_parent_app/features/trending_adoptibles/trending_adoptibles.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/ui/app_animations/app_animations.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/google_ads_widget/google_ads_widget.dart';
import 'package:paw_parent_app/ui/image_viewer/image_viewer.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'post_feed_bloc_provider.dart';



class PostFeedView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {



    PostFeedBlocProvider _provider = PostFeedBlocProvider.of(context);
    PostFeedBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: RGBColors.light_yellow.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: _themeData.primaryColor,
        elevation: 0.0,
        title: Text("Paw Parent",
          style: TextStyle(color: RGBColors.dark_brown, fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.headline5.fontSize),
        ),
        actions: [


          IconButton(
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(FontAwesomeIcons.comments, color: Colors.black54,),
                  StreamBuilder<String>(
                    stream: _bloc.currentUserIdBehaviorSubject,
                    builder: (context, currentUserIdSnapshot) {

                      if (currentUserIdSnapshot.data != null){
                        return Container(
                          child: StreamBuilder<Event>(
                              stream: _bloc.getCurrentUserHasNewMessagesStreamEvent(currentUserId: currentUserIdSnapshot.data),
                              builder: (context, hasNewMessagesSnapshot) {

                                if (hasNewMessagesSnapshot.data != null && hasNewMessagesSnapshot.data.snapshot.value == true){
                                  return CircleAvatar(
                                    radius: 5.0,
                                    backgroundColor: RGBColors.light_blue,
                                  );
                                }
                                else{
                                  return Container();
                                }

                              }
                          ),
                        );
                      }
                      else{
                        return Container();
                      }

                    }
                  )
                ],
              ),
              onPressed: (){

                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChatSpace()));
              }),
          //SizedBox(width: 10.0,),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
                icon: Icon(Icons.search, color: Colors.black54,),
                onPressed: (){
                  Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Search()));
                }),
          ),
          SizedBox(width: 15.0,),

        ],
      ),

      body: SingleChildScrollView(
        controller: _provider.postsScrollController,
        child: Column(
          children: [


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [


                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        GestureDetector(
                          onTap: (){

                            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => TopPaws()));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 75.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                    color: _themeData.primaryColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/paw-alt.png")
                                    )
                                ),
                              ),
                              SizedBox(height: 10.0,),

                              Text("Top \nPaws", textAlign: TextAlign.center,)
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: (){

                            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => AdoptionCenters()));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 75.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                    color: RGBColors.light_blue,
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/paw-confort.png")
                                    )
                                ),
                              ),
                              SizedBox(height: 10.0,),

                              Text("Adoption \nCenters", textAlign: TextAlign.center,)
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: (){

                            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => TrendingAdoptibles()));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 75.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                    color: RGBColors.orange,
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/paw-dog.png")
                                    )
                                ),
                              ),
                              SizedBox(height: 10.0,),

                              Text("Trending \nAdoptibles", textAlign: TextAlign.center,)
                            ],
                          ),
                        ),

                        /*
                        GestureDetector(
                          onTap: (){

                          },
                          child: Column(
                            children: [
                              Container(
                                width: 75.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                    color: RGBColors.lime_green,
                                    borderRadius: BorderRadius.circular(20.0),
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/file-alt.png")
                                  )
                                ),

                              ),
                              SizedBox(height: 10.0,),

                              Text("Trending \nPosts", textAlign: TextAlign.center,)
                            ],
                          ),
                        )
                         */

                      ],
                    ),
                  ),



                  SizedBox(
                    height: screenHeight * 0.25,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [

                              Text("Open for Adoption", style: TextStyle(
                                color: Colors.black87,
                                fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                fontWeight: FontWeight.bold
                              ),)

                            ],
                          ),
                        ),

                        Flexible(
                          child: StreamBuilder<List<DogModel>>(

                            stream: _bloc.dogsListBehaviorSubject,
                            builder: (context, dogsListSnapshot) {

                              if (dogsListSnapshot.hasData){

                                if (dogsListSnapshot.data.length == 0){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Center(
                                          child: Text("No Dogs For Adoption", style: TextStyle(color: _themeData.primaryColor),),
                                        )
                                      ],
                                    ),
                                  );
                                }else{

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,

                                    child: Row(
                                      children: [

                                        GridView.builder(
                                          controller: _provider.dogsScrollController,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: dogsListSnapshot.data.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            childAspectRatio: 4 / 3,
                                          ), itemBuilder: (BuildContext context, index){

                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: InkWell(
                                              onTap: (){


                                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPage(
                                                  ownerUserModel: dogsListSnapshot.data[index].ownerUserModel,
                                                  dogModel: dogsListSnapshot.data[index],
                                                )));



                                              },
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                        child: CachedNetworkImage(
                                                          imageUrl: dogsListSnapshot.data[index].profileImageThumb,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(dogsListSnapshot.data[index].profileName, style: TextStyle(
                                                              fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black54
                                                          ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                        ],
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),
                                          );

                                        },),

                                        Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Center(
                                            child: StreamBuilder(
                                              stream: _bloc.hasMoreDogsBehaviorSubject.stream,
                                              builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

                                                switch(snapshot.connectionState){
                                                  case ConnectionState.none:
                                                    return Container();
                                                  case ConnectionState.waiting:
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SpinKitChasingDots(color: _themeData.primaryColor,),
                                                    );
                                                  case ConnectionState.active: case ConnectionState.done:

                                                  if (snapshot.hasData && snapshot.data){
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SpinKitChasingDots(color: _themeData.primaryColor,),
                                                    );
                                                  }
                                                  else{
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("No More Dogs", style: TextStyle(color: _themeData.primaryColor, fontSize: Theme.of(context).textTheme.subtitle1.fontSize),),
                                                    );
                                                  }
                                                }

                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );

                                }

                              }else{
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Center(
                                      child: SpinKitPulse(color: _themeData.primaryColor,),
                                    )
                                  ],
                                );
                              }

                              return Container();
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))
              ),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0, bottom: 40.0),
                    child: StreamBuilder<DOG_POST_QUERY_TYPE>(
                      stream: _provider.dogPostsBloc.dogPostQueryTypeBehaviorSubject,
                      initialData: DOG_POST_QUERY_TYPE.FEVORITES,
                      builder: (context, snapshot) {

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Flexible(
                              flex: 33,
                              fit: FlexFit.tight,
                              child: Center(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30.0),
                                  splashColor: _themeData.primaryColor.withOpacity(0.1),
                                  highlightColor: _themeData.primaryColor.withOpacity(0.1),
                                  onTap: (){

                                    _provider.dogPostsBloc.dogPostQueryTypeBehaviorSubject.add(DOG_POST_QUERY_TYPE.FEVORITES);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                        color: snapshot.data == DOG_POST_QUERY_TYPE.FEVORITES? _themeData.primaryColor: Colors.white,
                                        borderRadius: BorderRadius.circular(30.0)
                                    ),
                                    child: Center(
                                      child: Text("Favourties",
                                        style: TextStyle(
                                            color: snapshot.data == DOG_POST_QUERY_TYPE.FEVORITES? Colors.white: _themeData.primaryColor,
                                            fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Flexible(
                              flex: 33,
                              fit: FlexFit.tight,
                              child: Center(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30.0),
                                  splashColor: _themeData.primaryColor.withOpacity(0.1),
                                  highlightColor: _themeData.primaryColor.withOpacity(0.1),
                                  onTap: (){

                                    _provider.dogPostsBloc.dogPostQueryTypeBehaviorSubject.add(DOG_POST_QUERY_TYPE.FOLLOWING);

                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                        color: snapshot.data == DOG_POST_QUERY_TYPE.FOLLOWING? _themeData.primaryColor: Colors.white,
                                        borderRadius: BorderRadius.circular(30.0)
                                    ),
                                    child: Center(
                                      child: Text("Following",
                                        style: TextStyle(
                                            color: snapshot.data == DOG_POST_QUERY_TYPE.FOLLOWING? Colors.white: _themeData.primaryColor,
                                            fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Flexible(
                              flex: 33,
                              fit: FlexFit.tight,
                              child: Center(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30.0),
                                  splashColor: _themeData.primaryColor.withOpacity(0.1),
                                  highlightColor: _themeData.primaryColor.withOpacity(0.1),
                                  onTap: (){

                                    _provider.dogPostsBloc.dogPostQueryTypeBehaviorSubject.add(DOG_POST_QUERY_TYPE.TRENDING);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                        color: snapshot.data == DOG_POST_QUERY_TYPE.TRENDING? _themeData.primaryColor: Colors.white,
                                        borderRadius: BorderRadius.circular(30.0)
                                    ),
                                    child: Center(
                                      child: Text("Trending",
                                        style: TextStyle(
                                            color: snapshot.data == DOG_POST_QUERY_TYPE.TRENDING? Colors.white: _themeData.primaryColor,
                                            fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        );
                      }
                    ),
                  ),

                  StreamBuilder<List<DogPostModel>>(
                    stream: _provider.dogPostsBloc.postsListBehaviorSubject.stream,
                    builder: (context, dogsPostListSnapshot) {

                      switch(dogsPostListSnapshot.connectionState){

                        case ConnectionState.none: case ConnectionState.waiting:
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: DogLoaderWidget(width: 100.0, height: 100.0,),
                            ),
                          );
                        case ConnectionState.active: case ConnectionState.done:
                        if (dogsPostListSnapshot.hasData){

                          if (dogsPostListSnapshot.data.length == 0){
                            return Container();
                          }
                          else{

                            return Container(
                              color: RGBColors.light_yellow.withOpacity(0.5),
                              child: GridView.builder(
                                padding: EdgeInsets.symmetric(vertical: 0.0),
                                itemCount: dogsPostListSnapshot.data.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 3.5 / 4,
                                ), itemBuilder: (BuildContext context, index){

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child:  Container(
                                    color: Colors.white,
                                    child: dogsPostListSnapshot.data[index].postType == DogPostType.google_ads
                                        ? Container(
                                      child: GoogleAdsWidget(height: double.infinity,),
                                    )
                                        : Padding(
                                      padding: const EdgeInsets.only(bottom: 20.0),
                                      child: Column(
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: GestureDetector(
                                                    onTap: (){


                                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPage(
                                                        ownerUserModel: dogsPostListSnapshot.data[index].ownerUserModel,
                                                        dogModel: dogsPostListSnapshot.data[index].dogModel,
                                                      )));


                                                    },
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 20.0,
                                                          backgroundColor: RGBColors.light_yellow,
                                                          backgroundImage: CachedNetworkImageProvider(dogsPostListSnapshot.data[index].dogModel.profileImage),
                                                        ),
                                                        SizedBox(width: 10.0,),
                                                        Flexible(
                                                          child: Text(dogsPostListSnapshot.data[index].dogModel.profileName,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),

                                          Flexible(
                                            child: Row(
                                              children: [

                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(icon: Icon(Icons.share), onPressed: (){

                                                          launch(AppConstants.android_app_link);
                                                        }),
                                                        SizedBox(height: 10.0,),

                                                        StreamBuilder<DocumentSnapshot>(
                                                            stream: _provider.dogPostsBloc.getCurrentUserStreamModel(currentUserId: _bloc.getCurrentUserId),
                                                            builder: (context, currentUserModelStreamSnapshot) {

                                                              switch(currentUserModelStreamSnapshot.connectionState){

                                                                case ConnectionState.none: case ConnectionState.waiting:
                                                                return Container();
                                                                case ConnectionState.active: case ConnectionState.done:

                                                                if (currentUserModelStreamSnapshot.hasData
                                                                    && currentUserModelStreamSnapshot.data.data != null
                                                                    && UserModel.fromJson(currentUserModelStreamSnapshot.data.data).dogPostsBookmarkList.contains(dogsPostListSnapshot.data[index].postId)){

                                                                  return IconButton(icon: Icon(Icons.bookmark, color: _themeData.primaryColor,), onPressed: (){

                                                                    BasicUI.showSnackBar(
                                                                      context: context,
                                                                      message: "Already added to Collections", textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 1),
                                                                    );
                                                                  });

                                                                }
                                                                else{

                                                                  return IconButton(icon: Icon(Icons.bookmark_border, color: _themeData.primaryColor,), onPressed: (){

                                                                    _provider.dogPostsBloc.bookmarkDogPost(postId: dogsPostListSnapshot.data[index].postId, currentUserId: _bloc.getCurrentUserId).then((_){
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

                                                        SizedBox(height: 10.0,),
                                                        IconButton(icon: Icon(FontAwesomeIcons.commentAlt), onPressed: (){

                                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPostRoom(
                                                            dogPostModel: dogsPostListSnapshot.data[index],
                                                            popOutComments: true,
                                                          )));

                                                        }),
                                                        SizedBox(height: 10.0,),

                                                        PostLikeWidget(dogPostModel: dogsPostListSnapshot.data[index],)
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Flexible(
                                                  flex: 100,
                                                  fit: FlexFit.tight,
                                                  child: GestureDetector(
                                                    onTap: (){

                                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPostRoom(
                                                        dogPostModel: dogsPostListSnapshot.data[index],
                                                        popOutComments: false,
                                                      )));
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Flexible(
                                                          flex: 75,
                                                          fit: FlexFit.tight,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
                                                            child: Stack(
                                                              fit: StackFit.expand,
                                                              children: [
                                                                Positioned.fill(
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:  ImageModel.fromJson(dogsPostListSnapshot.data[index].postData).imagesThumbsUrl[0],
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),

                                                                Positioned(
                                                                  top: 0.0,
                                                                  right: 0.0,
                                                                  child: ImageModel.fromJson(dogsPostListSnapshot.data[index].postData).imagesThumbsUrl.length > 1? Padding(
                                                                    padding: const EdgeInsets.all(10.0),
                                                                    child: Icon(FontAwesomeIcons.solidClone, color: Colors.white,),
                                                                  ): Container(),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, right: 15.0),
                                                          child: Text(dogsPostListSnapshot.data[index].postCaption, style: TextStyle(

                                                          ), overflow: TextOverflow.ellipsis, maxLines: AppDataLimits.maxLinesForPostText,),
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                )

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );


                              },),
                            );
                          }

                        }else{
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: DogLoaderWidget(width: 100.0, height: 100.0,),
                            ),
                          );

                        }
                      }


                    }
                  ),



                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: StreamBuilder(
                        stream: _provider.dogPostsBloc.hasMorePostsBehaviorSubject.stream,
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

                          switch(snapshot.connectionState){
                            case ConnectionState.none:
                              return Container();
                            case ConnectionState.waiting:
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitChasingDots(color: _themeData.primaryColor,),
                              );
                            case ConnectionState.active: case ConnectionState.done:

                            if (snapshot.hasData && snapshot.data){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitChasingDots(color: _themeData.primaryColor,),
                              );
                            }
                            else{
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No More Posts", style: TextStyle(color: _themeData.primaryColor, fontSize: Theme.of(context).textTheme.subtitle1.fontSize),),
                              );
                            }
                          }

                        },
                      ),
                    ),
                  )


                ],
              ),
            )

          ],
        ),
      ),
    );

  }

}









class PostLikeWidget extends StatelessWidget{

  DogPostModel dogPostModel;

  PostLikeWidget({@required this.dogPostModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


   PostFeedBlocProvider _provider = PostFeedBlocProvider.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;



    return Container(
      child: StreamBuilder<Event>(
        stream: _provider.dogPostsBloc.getIfUserLikedPostStream(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _provider.bloc.getCurrentUserId),
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

                  _provider.dogPostsBloc.addPostLike(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _provider.bloc.getCurrentUserId);

                  AppAnimations.animateDogPostLike(context: context);
                }
                else{

                  _provider.dogPostsBloc.removePostLike(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _provider.bloc.getCurrentUserId);
                }

              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  if (userLikedPostSnapshot.data.snapshot.value == null)
                    Icon(FontAwesomeIcons.heart, color: _themeData.primaryColor,)
                  else
                    Icon(FontAwesomeIcons.solidHeart, color: Colors.pinkAccent,),

                  SizedBox(height: 5.0,),

                  Flexible(
                    child: StreamBuilder<Event>(
                      stream: _provider.dogPostsBloc.getNumberOfPostLikesStream(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId),
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
