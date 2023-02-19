import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post.dart';
import 'package:paw_parent_app/features/create_insight_post/create_insight_post.dart';
import 'package:paw_parent_app/features/home/home.dart';
import 'package:paw_parent_app/features/home/home_bloc.dart';
import 'package:paw_parent_app/features/home/home_bloc_provider.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';



class HomeViewHandlers{


  Future<void> showCurrentUserDogsDialog({@required BuildContext pageContext}){

    HomeBloc _bloc = HomeBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;


    showDialog(context: pageContext, builder: (BuildContext context){
      return Center(
        child: SizedBox(
          height: screenHeight * 0.75,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              shadowColor: _themeData.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [

                    Text("Create Dog Post", style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10.0,),
                    Text("(Select your Dog)", style: TextStyle(fontSize: Theme.of(context).textTheme.subtitle2.fontSize),),
                    SizedBox(height: 40.0,),

                    Flexible(
                      child: StreamBuilder<UserModel>(
                        stream: _bloc.currentuserUserModelBehaviorSubject.stream,
                        builder: (context, currentUserSnapshot) {

                          if (currentUserSnapshot.hasData){
                            return FutureBuilder<List<DogModel>>(
                                future: _bloc.getCurrentUserDogsData(currentUserId: _bloc.getCurrentUserId),
                                builder: (context, snapshot) {

                                  if (snapshot.hasData){
                                    if (snapshot.data.length > 0){
                                      return ListView.builder(
                                        itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context, index){
                                        return InkWell(
                                          onTap: (){

                                            Navigator.of(context).pop();
                                            Navigator.of(pageContext).push(MaterialPageRoute(builder: (BuildContext context) => CreateDogPost(
                                              currentUserModel: currentUserSnapshot.data, dogModel: snapshot.data[index], launchedFromHomePage: true,)));
                                          },
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 20.0,
                                              backgroundColor: RGBColors.light_yellow,
                                              backgroundImage: CachedNetworkImageProvider(snapshot.data[index].profileImageThumb),
                                            ),
                                            title: Text(snapshot.data[index].profileName, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                          ),
                                        );
                                      });
                                    }
                                    else{
                                      return Center(
                                        child: Text("No Dogs"),
                                      );
                                    }
                                  }
                                  else{
                                    return Center(
                                      child: DogLoaderWidget(width: 100.0, height: 100.0,),
                                    );
                                  }

                                }
                            );
                          }else{
                            return Center(
                              child: DogLoaderWidget(width: 100.0, height: 100.0,),
                            );
                          }


                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

  }


  Future<void> showHomeMenuFloatingButtonAction({@required BuildContext pageContext})async{


    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;


    await showDialog(
        context: pageContext,
        builder: (BuildContext context){

      return Center(
        child: SizedBox(
          width: screenWidth * 0.75,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            color: Colors.white,

            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Option", style: TextStyle(color: Colors.black54),),
                  SizedBox(height: 20.0,),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();

                      showCurrentUserDogsDialog(pageContext: pageContext);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.black54,),
                          SizedBox(width: 20.0,),
                          Text("Create a post", style: TextStyle(
                              color: Colors.black54,
                              fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                          ),),
                        ],
                      ),
                    ),
                  ),


                  InkWell(
                    onTap: (){

                      Navigator.of(context).pop();
                      Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => CreateInsightPost()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.view_compact, color: Colors.black54,),
                          SizedBox(width: 20.0,),
                          Text("Share Insights", style: TextStyle(
                              color: Colors.black54,
                              fontSize: Theme.of(context).textTheme.subtitle1.fontSize
                          ),),
                        ],
                      ),
                    ),
                  ),



                ],
              ),
            ),


          ),
        ),
      );
    }
    );


  }

}
