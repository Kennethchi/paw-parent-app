


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paw_parent_app/features/collections_page/collections_page.dart';
import 'package:paw_parent_app/features/profile/profile_bloc.dart';
import 'package:paw_parent_app/features/profile/profile_bloc_provider.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings.dart';
import 'package:paw_parent_app/features/splash_screen/splash_screen.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';

class ProfileViewHandlers{


  Future<void> showAccountOptionsModal({@required BuildContext pageContext}){

    ProfileBloc _bloc = ProfileBlocProvider.of(pageContext).bloc;
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
                child: ListView(

                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Options", style: TextStyle(fontSize: Theme.of(context).textTheme.headline5.fontSize, fontWeight: FontWeight.bold),),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black54,),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 40.0,),
                    GestureDetector(
                      onTap: (){

                        Navigator.pop(context);

                        Navigator.of(pageContext).push(MaterialPageRoute(builder: (BuildContext context) {
                          return ProfileSettings(dynamicProfileBloc: _bloc,);
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            //border: Border.all(color: _themeData.primaryColor, width: 1.0),
                            color: RGBColors.light_yellow.withOpacity(0.5)
                        ),
                        child: Center(child: Text("Account Settings", style: TextStyle(fontSize: Theme.of(context).textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),)),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    StreamBuilder<UserModel>(
                      stream: _bloc.profileUserModelBehaviorSubject,
                      builder: (context, snapshot) {

                        if (snapshot.hasData && snapshot.data.userId == _bloc.getCurrentUserId){
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: (){

                                  Navigator.pop(context);

                                  Navigator.of(pageContext).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return CollectionsPage(currentUserModel: snapshot.data,);
                                  }));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 15.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      //border: Border.all(color: _themeData.primaryColor, width: 1.0),
                                      color: RGBColors.light_yellow.withOpacity(0.5)
                                  ),
                                  child: Center(child: Text("Collections", style: TextStyle(fontSize: Theme.of(context).textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),)),
                                ),
                              ),

                              SizedBox(height: 20.0,),
                            ],
                          );
                        }
                        else{
                          return Container();
                        }


                      }
                    ),
                    SizedBox(height: 20.0,),

                    GestureDetector(
                      onTap: (){

                        FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){
                          if (firebaseUser != null){

                            FirebaseDatabase.instance.reference()
                                .child(RealtimeDatabaseChildNames.users)
                                .child(firebaseUser.uid)
                                .child(RealtimeDatabaseChildNames.user_profile)
                                .child(OptimisedUserChiledFieldNames.online)
                                .set(Timestamp.now().millisecondsSinceEpoch);

                            FirebaseAuth.instance.signOut().then((value){
                              Navigator.of(pageContext).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
                                return SplashScreen();
                              }), (Route<dynamic> route) => false);
                            });
                          }
                        });

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: _themeData.primaryColor, width: 1.0),
                          color: RGBColors.light_yellow.withOpacity(0.5)
                        ),
                        child: Center(child: Text("Log Out", style: TextStyle(color: _themeData.primaryColor, fontSize: Theme.of(context).textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),)),
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






