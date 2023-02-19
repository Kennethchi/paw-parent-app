import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paw_parent_app/features/insight_room/insight_room.dart';
import 'package:paw_parent_app/features/insights_page_feature/popular_insights_tag/popular_insights_tag_bloc_provider.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/models/insight_model.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';

import 'popular_insights_tag_bloc.dart';



class PopularInsightsTagView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    PopularInsightsTagBlocProvider _provider = PopularInsightsTagBlocProvider.of(context);
    PopularInsightsTagBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      controller: _provider.scrollController,
      child: Column(
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
                                      Icon(Icons.remove_red_eye),
                                      SizedBox(width: 5.0,),
                                      Text("seen 10325")
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
    );
  }
}
