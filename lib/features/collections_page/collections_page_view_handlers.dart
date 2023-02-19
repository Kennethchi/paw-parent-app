


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/collections_page/collections_page_bloc.dart';
import 'package:paw_parent_app/features/dog_page/dog_page.dart';
import 'package:paw_parent_app/features/dog_post_room/dog_post_room.dart';
import 'package:paw_parent_app/features/insight_room/insight_room.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';

import 'collections_page_bloc_provider.dart';

class CollectionsPageViewHandlers{

  Future<void> showBookmarkedDogPostsModal({@required BuildContext pageContext}){

    CollectionsPageBloc _bloc = CollectionsPageBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;


    showDialog(context: pageContext, builder: (BuildContext context){
      return Center(
        child: SizedBox(
          height: screenHeight * 0.9,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              shadowColor: _themeData.primaryColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Dog Posts Bookmarks", style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize, fontWeight: FontWeight.bold, color: _themeData.primaryColor),),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.black54,),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),

                    Flexible(
                      child: FutureBuilder<List<DogPostModel>>(
                        future: _bloc.getBookmarkedDogPostModelData(postIdList: _bloc.getCurrentUserModel.dogPostsBookmarkList),
                        builder: (context, snapshot) {

                          if (snapshot.hasData){

                            return Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Container(
                                child: GridView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 0.0),
                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 3.5 / 4,
                                  ), itemBuilder: (BuildContext context, index){

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child:  Container(
                                      color: Colors.white,
                                      child: Padding(
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
                                                          ownerUserModel: snapshot.data[index].ownerUserModel,
                                                          dogModel: snapshot.data[index].dogModel,
                                                        )));

                                                      },
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 20.0,
                                                            backgroundColor: RGBColors.light_yellow,
                                                            backgroundImage: CachedNetworkImageProvider(snapshot.data[index].dogModel.profileImage),
                                                          ),
                                                          SizedBox(width: 10.0,),
                                                          Flexible(
                                                            child: Text(snapshot.data[index].dogModel.profileName,
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

                                                  /*
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
                                                          IconButton(icon: Icon(Icons.bookmark_border), onPressed: (){

                                                            _provider.dogPostsBloc.checkIfDogPostIsBookMarked(postId: dogsPostListSnapshot.data[index].postId, currentUserId: _bloc.getCurrentUserId)
                                                                .then((bool isBookmarked){

                                                              if (isBookmarked){
                                                                BasicUI.showSnackBar(
                                                                  context: context,
                                                                  message: "Already added to Collections", textColor: CupertinoColors.destructiveRed, duration: Duration(seconds: 1),

                                                                );
                                                              }else{


                                                                _provider.dogPostsBloc.bookmarkDogPost(postId: dogsPostListSnapshot.data[index].postId, currentUserId: _bloc.getCurrentUserId).then((_){
                                                                  BasicUI.showSnackBar(
                                                                      context: context,
                                                                      message: "Added to Collections",
                                                                      textColor: _themeData.primaryColor,
                                                                      duration: Duration(seconds: 1));
                                                                });
                                                              }
                                                            });
                                                          }),
                                                          SizedBox(height: 10.0,),
                                                          IconButton(icon: Icon(FontAwesomeIcons.commentAlt), onPressed: (){

                                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPostRoom(
                                                              dogPostModel: dogsPostListSnapshot.data[index],
                                                              popOutComments: true,
                                                            )));

                                                          }),
                                                          SizedBox(height: 10.0,),

                                                          PostLikeWidget(dogPostModel: snapshot.data[index],)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  */

                                                  Flexible(
                                                    flex: 100,
                                                    fit: FlexFit.tight,
                                                    child: GestureDetector(
                                                      onTap: (){

                                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPostRoom(
                                                          dogPostModel: snapshot.data[index],
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
                                                                      imageUrl:  ImageModel.fromJson(snapshot.data[index].postData).imagesThumbsUrl[0],
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),

                                                                  Positioned(
                                                                    top: 0.0,
                                                                    right: 0.0,
                                                                    child: ImageModel.fromJson(snapshot.data[index].postData).imagesThumbsUrl.length > 1? Padding(
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
                                                            child: Text(snapshot.data[index].postCaption, style: TextStyle(

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
                                    )
                                  );


                                },),
                              ),
                            );
                          }
                          else{
                            return Center(
                                child: DogLoaderWidget(width: 100.0, height: 100.0,)
                            );
                          }

                        }
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

  }




  Future<void> showBookmarkedInsightsModal({@required BuildContext pageContext}){

    CollectionsPageBloc _bloc = CollectionsPageBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;


    showDialog(context: pageContext, builder: (BuildContext context){
      return Center(
        child: SizedBox(
          height: screenHeight * 0.9,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              shadowColor: _themeData.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Insights Bookmarks", style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize, fontWeight: FontWeight.bold, color: _themeData.primaryColor),),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black54,),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 40.0,),

                    Flexible(
                      child: FutureBuilder<List<InsightModel>>(
                          future: _bloc.getBookmarkedInsightsModelData(insightIdList: _bloc.getCurrentUserModel.insightsBookmarkList),
                          builder: (context, snapshot) {

                            if (snapshot.hasData){

                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: snapshot.data.map((InsightModel insightModel){

                                    return GestureDetector(

                                      onTap: (){
                                        Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => InsightRoom(insightModel: insightModel,)));
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 25.0),
                                        child: Container(
                                          padding: EdgeInsets.all(20.0),
                                          width: screenWidth * 0.8,
                                          height: 200.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30.0),
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(ImageModel.fromJson(insightModel.insightData).imagesUrl.first),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text(insightModel.insightTitle, style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: Theme.of(context).textTheme.headline4.fontSize,
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                    SizedBox(height: 5.0,),

                                                    Wrap(
                                                      spacing: 10.0,
                                                      children: insightModel.tags.map((dynamic tag){
                                                        return Text("#" + tag, style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: Theme.of(context).textTheme.caption.fontSize
                                                        ),);
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20.0,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      child: insightModel.userModel.profileImageThumb != null && insightModel.userModel.profileImageThumb.isNotEmpty? CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundImage: CachedNetworkImageProvider(insightModel.userModel.profileImageThumb),
                                                      ): CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundColor: Colors.white,
                                                        child: Center(
                                                          child: Text(insightModel.userModel.profileName.characters.first.toUpperCase(), style: TextStyle(
                                                              color: Colors.black54,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                                                          ),),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20.0,),
                                                    Text(insightModel.userModel.profileName, style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: Theme.of(context).textTheme.headline6.fontSize
                                                    ),)
                                                  ],
                                                )


                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                            else{
                              return Center(
                                  child: DogLoaderWidget(width: 100.0, height: 100.0,)
                              );
                            }

                          }
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

  }


}



