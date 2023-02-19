import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/chat_room/chat_room.dart';
import 'package:paw_parent_app/features/insight_room/insight_room.dart';
import 'package:paw_parent_app/features/insights_page/insights_page_bloc.dart';
import 'package:paw_parent_app/features/insights_page_feature/popular_insights_tag/popular_insights_tag.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/resources/models/insight_tag_model.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';

import 'insights_page_bloc_provider.dart';



class InsightsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    InsightsPageBlocProvider _provider = InsightsPageBlocProvider.of(context);
    InsightsPageBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        controller: _provider.insightsFeedScrollController,
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              child: Column(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text("Popular Tags", style: TextStyle(
                          fontSize: Theme.of(context).textTheme.headline6.fontSize
                        ),),
                      ),
                      SizedBox(height: 20.0,),

                      FutureBuilder<List<InsightTagModel>>(
                        future: _bloc.getPopularInsightsTags(),
                        builder: (context, snapshot) {

                          switch(snapshot.connectionState){

                            case ConnectionState.none: case ConnectionState.waiting:
                              return Center(child: DogLoaderWidget(width: 75.0, height: 75.0));
                            case ConnectionState.active: case ConnectionState.done:
                              if (snapshot.data != null && snapshot.data.length > 0){

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: snapshot.data.map((InsightTagModel insightTagModel){
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: GestureDetector(

                                          onTap: (){
                                            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => PopularInsightsTag(tag: insightTagModel.uniqueName,)));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                                            decoration: BoxDecoration(
                                              color: RGBColors.light_blue,
                                              borderRadius: BorderRadius.circular(30.0)
                                            ),
                                            child: Text(insightTagModel.uniqueName, style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Theme.of(context).textTheme.headline6.fontSize,
                                            ),),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }
                              else{
                                return Center(
                                  child: Text("No Data Available"),
                                );
                              }
                          }

                        }
                      )

                    ],
                  ),
                  SizedBox(height: 50.0,),


                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text("Top Insights", style: TextStyle(
                            fontSize: Theme.of(context).textTheme.headline6.fontSize
                        ),),
                      ),
                      SizedBox(height: 20.0,),

                      FutureBuilder<List<InsightModel>>(
                          future: _bloc.getTopInsightsData(),
                          builder: (context, snapshot) {

                            switch(snapshot.connectionState){

                              case ConnectionState.none: case ConnectionState.waiting:
                                return Center(child: DogLoaderWidget(width: 75.0, height: 75.0));
                              case ConnectionState.active: case ConnectionState.done:
                                if (snapshot.data != null && snapshot.data.length > 0){
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: snapshot.data.map((InsightModel insightModel){

                                        return Padding(
                                          padding: const EdgeInsets.only(right: 20.0),
                                          child: GestureDetector(

                                            onTap: (){
                                              Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => InsightRoom(insightModel: insightModel,)));
                                            },

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
                                    child: Text("No Data Available"),
                                  );
                                }

                            }

                          }
                      )

                    ],
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child:
              Column(
                children: [

                  StreamBuilder<List<InsightModel>>(
                      stream: _provider.bloc.insightsListBehaviorSubject.stream,
                      builder: (context, insightsListSnapshot) {

                        switch(insightsListSnapshot.connectionState){

                          case ConnectionState.none: case ConnectionState.waiting:
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: DogLoaderWidget(width: 100.0, height: 100.0,),
                            ),
                          );
                          case ConnectionState.active: case ConnectionState.done:
                          if (insightsListSnapshot.hasData){

                            if (insightsListSnapshot.data.length == 0){
                              return Container();
                            }
                            else{

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: GridView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  itemCount: insightsListSnapshot.data.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 9 / 10,
                                  ), itemBuilder: (BuildContext context, index){

                                    InsightModel insightModel = insightsListSnapshot.data[index];

                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                                      color: Colors.white,
                                      child: GestureDetector(
                                        onTap: (){

                                          Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => InsightRoom(insightModel: insightModel,)));
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text(insightModel.insightTitle, style: TextStyle(
                                                fontSize: Theme.of(context).textTheme.headline5.fontSize,
                                                fontWeight: FontWeight.bold
                                            ),),
                                            SizedBox(height: 5.0,),

                                            Wrap(
                                              spacing: 10.0,
                                              children: insightModel.tags.map((dynamic tag){
                                                return Text("#" + tag);
                                              }).toList(),
                                            ),
                                            SizedBox(height: 20.0,),

                                            Container(
                                              height: 250.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  image: DecorationImage(
                                                      image:  CachedNetworkImageProvider(ImageModel.fromJson(insightModel.insightData).imagesUrl.first),
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                            ),

                                            SizedBox(height: 20.0,),
                                            Row(
                                              children: [
                                                Icon(Icons.remove_red_eye, color: Colors.black54,),
                                                SizedBox(width: 5.0,),
                                                Text("seen", style: TextStyle(
                                                    fontSize: Theme.of(context).textTheme.caption.fontSize
                                                ),),
                                                SizedBox(width: 5.0,),
                                                FutureBuilder<int>(
                                                    future: _bloc.getNumberOfInsightSeens(insightId: insightModel.insightId),
                                                    builder: (context, numSeensSnapshot) {
                                                      return Text(numSeensSnapshot.hasData && numSeensSnapshot.data != null? "${numSeensSnapshot.data}": "0", style: TextStyle(
                                                          fontSize: Theme.of(context).textTheme.caption.fontSize
                                                      ),);
                                                    }
                                                )
                                              ],
                                            )

                                          ],
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
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: StreamBuilder(
                        stream: _provider.bloc.hasMoreInsightsBehaviorSubject,
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
                                child: Text("No More Insights", style: TextStyle(color: _themeData.primaryColor, fontSize: Theme.of(context).textTheme.subtitle1.fontSize),),
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
