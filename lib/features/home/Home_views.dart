import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paw_parent_app/features/dog_page_creation/dog_page_creation.dart';
import 'package:paw_parent_app/features/insights_page/insights_page.dart';
import 'package:paw_parent_app/features/post_feed/post_feed.dart';
import 'package:paw_parent_app/features/profile/profile.dart';
import 'package:paw_parent_app/features/splash_screen/splash_screen.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';

import 'home_bloc.dart';
import 'home_bloc_provider.dart';


class HomeViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    HomeBlocProvider _provider = HomeBlocProvider.of(context);
    HomeBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    int _startBottomNavBarIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        
        children: [
          Positioned.fill(
            child: StreamBuilder<UserModel>(
              stream: _bloc.currentuserUserModelBehaviorSubject.stream,
              builder: (context, currentUserModelSnapshot) {

                if (currentUserModelSnapshot.hasData){
                  return Column(
                    children: [

                      Flexible(
                        child: StreamBuilder<int>(
                            stream: _bloc.bottomNavIndexBehaviorSubject.stream,
                            initialData: _startBottomNavBarIndex,
                            builder: (context, snapshot) {

                              if(snapshot.hasData){
                                if (snapshot.data == 0){

                                  return PostFeed();
                                }
                                else if (snapshot.data == 1){
                                  return InsightsPage();
                                }
                                else if (snapshot.data == 2){
                                  return Profile(profileUserModel: currentUserModelSnapshot.data,);
                                }
                                else{
                                  return Center(
                                    child: Text("NO Page"),
                                  );
                                }
                              }
                              else{
                                return Container();
                              }

                            }
                        ),
                      ),

                      Container(
                        height: 50.0,
                        padding: EdgeInsets.all(5.0),
                        color: Colors.white,
                        child: StreamBuilder<int>(
                            stream: _bloc.bottomNavIndexBehaviorSubject.stream,
                            initialData: _startBottomNavBarIndex,
                            builder: (context, snapshot) {
                              return Row(
                                children: [

                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 40,
                                      child: GestureDetector(
                                        onTap: (){
                                          _bloc.bottomNavIndexBehaviorSubject.sink.add(0);
                                        },
                                        child: Container(
                                            width: 75.0,
                                            padding: EdgeInsets.all(2.0),
                                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: snapshot.hasData && snapshot.data == 0? _themeData.primaryColor: Colors.transparent, width: 3.0))
                                            ),
                                            child: FittedBox(
                                              child: Center(
                                                  child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.home,
                                                    color: snapshot.hasData && snapshot.data == 0? _themeData.primaryColor: Colors.black54,
                                                  ),
                                                  SizedBox(height: 2.0,),
                                                  Text("Home", style: TextStyle(color: snapshot.hasData && snapshot.data == 0? _themeData.primaryColor: Colors.black54),)
                                                ],
                                              )),
                                            )
                                        ),
                                      )
                                  ),



                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 40,
                                      child: GestureDetector(
                                        onTap: (){
                                          _bloc.bottomNavIndexBehaviorSubject.sink.add(1);
                                        },
                                        child: Container(
                                            width: 75.0,
                                            padding: EdgeInsets.all(2.0),
                                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: snapshot.hasData && snapshot.data == 1? _themeData.primaryColor: Colors.transparent, width: 3.0))
                                            ),
                                            child: FittedBox(
                                              child: Center(child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.lightbulb_outline,
                                                    color: snapshot.hasData && snapshot.data == 1? _themeData.primaryColor: Colors.black54,
                                                  ),
                                                  SizedBox(height: 2.0,),
                                                  Text("Insights", style: TextStyle(color: snapshot.hasData && snapshot.data == 1? _themeData.primaryColor: Colors.black54),)
                                                ],
                                              )),
                                            )
                                        ),
                                      )
                                  ),



                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 40,
                                      child: GestureDetector(
                                        onTap: (){
                                          _bloc.bottomNavIndexBehaviorSubject.sink.add(2);
                                        },
                                        child: Container(
                                            width: 75.0,
                                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: snapshot.hasData && snapshot.data == 2? _themeData.primaryColor: Colors.transparent, width: 3.0))
                                            ),
                                            child: FittedBox(
                                              child: Center(child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.person_pin,
                                                    color: snapshot.hasData && snapshot.data == 2? _themeData.primaryColor: Colors.black54,
                                                  ),
                                                  SizedBox(height: 2.0,),
                                                  Text("User", style: TextStyle(color: snapshot.hasData && snapshot.data == 2? _themeData.primaryColor: Colors.black54),)
                                                ],
                                              )),
                                            )
                                        ),
                                      )
                                  ),

                                ],
                              );
                            }
                        ),
                      )
                    ],
                  );
                }
                else{
                  return Container();
                }

              }
            ),
          ),

          Positioned(
            bottom: 75.0,
            right: 20.0,
            child: StreamBuilder<int>(
              stream: _bloc.bottomNavIndexBehaviorSubject,
              builder: (context, snapshot) {

               if (snapshot.hasData && snapshot.data != 2){
                 return GestureDetector(
                   onTap: (){

                     _provider.handlers.showHomeMenuFloatingButtonAction(pageContext: context);
                   },
                   child: Card(
                     color: _themeData.primaryColor,
                     elevation: 20.0,
                     shadowColor: _themeData.primaryColor,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000.0)),
                     child: Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Icon(Icons.add, color: Colors.white, size: 40.0,),
                     ),
                   ),
                 );
               }
               else{
                 return Container();
               }


              }
            ),
          )
        ],
      ),
    );
  }
}
