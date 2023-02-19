import 'dart:math';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/create_dog_post/create_dog_post.dart';
import 'package:paw_parent_app/features/dog_page/dog_page.dart';
import 'package:paw_parent_app/features/dog_page/dog_page_bloc_provider.dart';
import 'package:paw_parent_app/features/dog_page_creation/dog_page_creation.dart';
import 'package:paw_parent_app/features/dog_post_room/dog_post_room.dart';
import 'package:paw_parent_app/features/profile/profile.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/dog_post_model.dart';
import 'package:paw_parent_app/resources/models/image_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_ff_model.dart';
import 'package:paw_parent_app/ui/app_animations/app_animations.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/image_viewer/image_viewer.dart';
import 'package:paw_parent_app/utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dog_page_bloc.dart';



class DogPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    DogPageBlocProvider _provider = DogPageBlocProvider.of(context);
    DogPageBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<DogModel>(
        stream: _bloc.dogModelBehaviorSubject.stream,
        builder: (context, dogModelSnapshot) {

          if (dogModelSnapshot.hasData){
            return Container(
                color: RGBColors.light_yellow,
                child: SingleChildScrollView(
                  controller: _provider.scrollController,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Row(
                                children: [

                                  Text("Owner:", style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(width: 10.0,),

                                  StreamBuilder<UserModel>(
                                    stream: _bloc.ownerUserModelBehaviorSubject,
                                    builder: (context, snapshot) {

                                      if (snapshot.hasData){
                                        return GestureDetector(

                                          onTap: (){

                                            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserModel: snapshot.data,)));
                                          },
                                          child: Text("@" + snapshot.data.username, style: TextStyle(
                                              fontSize: Theme.of(context).textTheme.headline6.fontSize,
                                              fontWeight: FontWeight.bold,
                                            color: Colors.black87
                                          ),),
                                        );
                                      }
                                      else{
                                        return Container();
                                      }


                                    }
                                  ),
                                ],
                              ),

                              StreamBuilder<bool>(
                                stream: _bloc.isCurrentUserDogOwnerBehaviorSubject.stream,
                                builder: (context, snapshot) {

                                  if (snapshot.hasData && snapshot.data){
                                    return IconButton(
                                      onPressed: (){

                                      },
                                      icon: Icon(Icons.more_vert, color: Colors.black,),
                                    );
                                  }
                                  else{
                                    return Container();
                                  }


                                }
                              )

                            ],
                          ),
                        ),

                        SizedBox(height: 40.0,),
                        GestureDetector(
                          onTap: (){

                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ImageViewer(
                              currentIndex: 0,
                              imageList: [dogModelSnapshot.data.profileImage],
                            )));

                          },
                          child: CircleAvatar(
                            radius: 80.0,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 75.0,
                              backgroundColor: RGBColors.light_yellow,
                              backgroundImage: CachedNetworkImageProvider(dogModelSnapshot.data.profileImageThumb),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(dogModelSnapshot.data.profileName, style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.headline5.fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54
                                    ), textAlign: TextAlign.center,),
                                  ),
                                  Container(
                                      child: dogModelSnapshot.data.adoptible != null && dogModelSnapshot.data.adoptible? Row(
                                        children: [
                                          SizedBox(width: 20.0,),
                                          Icon(FontAwesomeIcons.storeAlt, color: RGBColors.light_blue,),
                                        ],
                                      ): Container()
                                  ),

                                ],
                              ),
                              SizedBox(height: 8.0,),
                              Text("@" + dogModelSnapshot.data.username, style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ), textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: <Widget>[
                                  Text("Posts"),
                                  SizedBox(height: 5.0,),
                                  Container(
                                    child: dogModelSnapshot.data.ownerUserId == _bloc.getCurrentUserModel.userId? StreamBuilder<Event>(

                                      stream: _bloc.getNumberOfPostsStreamEvent(ownerUserId: dogModelSnapshot.data.ownerUserId, dogId: dogModelSnapshot.data.userId),
                                      builder: (context, snapshot) {

                                        return Text(snapshot.hasData && snapshot.data.snapshot.value != null
                                            ? StringUtils.formatNumber(snapshot.data.snapshot.value)
                                            : "0", style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.headline5.fontSize,
                                            fontWeight: FontWeight.bold
                                        ),);

                                      }
                                    ): Container(
                                      child: FutureBuilder<int>(
                                        future: _bloc.getNumberOfPosts(ownerUserId: dogModelSnapshot.data.ownerUserId, dogId: dogModelSnapshot.data.userId),
                                        builder: (context, snapshot) {
                                          return Text(snapshot.hasData && snapshot.data != null
                                              ? StringUtils.formatNumber(snapshot.data)
                                              : "0", style: TextStyle(
                                              fontSize: Theme.of(context).textTheme.headline5.fontSize,
                                              fontWeight: FontWeight.bold
                                          ),);
                                        }
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: <Widget>[
                                  Text("Followers"),
                                  SizedBox(height: 5.0,),
                                  StreamBuilder<int>(
                                    stream: _bloc.numberOfFollowersBehaviorSubject.stream,
                                    builder: (context, snapshot) {
                                      return Text(snapshot.hasData && snapshot.data != null
                                          ? StringUtils.formatNumber(snapshot.data)
                                          : "0", style: TextStyle(
                                          fontSize: Theme.of(context).textTheme.headline5.fontSize,
                                          fontWeight: FontWeight.bold
                                      ),);
                                    }
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),

                        Container(
                          child: dogModelSnapshot.data.dogBehaviorsList != null && dogModelSnapshot.data.dogBehaviorsList.isNotEmpty? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                            child: Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: dogModelSnapshot.data.dogBehaviorsList.map((behavior){
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: Text(behavior, style: TextStyle(color: Colors.black),),
                                );
                              }).toList(),
                            ),
                          ): Container(),
                        ),


                        Container(
                          child: StreamBuilder<String>(
                              stream: _bloc.dogInfoMenuTypeBehaviorSubject.stream,
                              initialData: DogInfoMenuType.about,
                              builder: (context, snapshot) {
                                return Column(
                                  children: [

                                    SizedBox(height: 30.0,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: (){

                                            _bloc.dogInfoMenuTypeBehaviorSubject.add(DogInfoMenuType.about);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                                            decoration: BoxDecoration(
                                              color: snapshot.hasData && snapshot.data == DogInfoMenuType.about?  RGBColors.dark_brown: Colors.transparent,
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: Center(
                                                child: Text("About", style: TextStyle(
                                                  color: snapshot.hasData && snapshot.data == DogInfoMenuType.about?  Colors.white: RGBColors.dark_brown,
                                                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                                ),)
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){

                                            _bloc.dogInfoMenuTypeBehaviorSubject.add(DogInfoMenuType.details);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                                            decoration: BoxDecoration(
                                              color: snapshot.hasData && snapshot.data == DogInfoMenuType.details?  RGBColors.dark_brown: Colors.transparent,
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: Center(
                                                child: Text("Details", style: TextStyle(
                                                  color: snapshot.hasData && snapshot.data == DogInfoMenuType.details? Colors.white:  RGBColors.dark_brown,
                                                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                                ),)
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24.0,),

                                    Container(
                                      child: snapshot.hasData && snapshot.data == DogInfoMenuType.about? Container(
                                        child: Text(_bloc.getDogModel.about),
                                      ): Container(
                                        child: Column(
                                          children: [


                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Flexible(
                                                    flex: 40,
                                                    fit: FlexFit.tight,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text("Vaccinated", style: TextStyle(color: RGBColors.dark_brown, fontSize: Theme.of(context).textTheme.subtitle1.fontSize),),
                                                      ],
                                                    )
                                                ),
                                                SizedBox(width: 25.0,),

                                                Flexible(
                                                  flex: 60,
                                                  fit: FlexFit.tight,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: dogModelSnapshot.data.isVaccinated != null && dogModelSnapshot.data.isVaccinated? Icon(Icons.check, color: RGBColors.dark_brown,)
                                                            : Icon(Icons.close, color: _themeData.primaryColor,),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                            SizedBox(height: 10.0,),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Flexible(
                                                    flex: 40,
                                                    fit: FlexFit.tight,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text("Mixed Breed", style: TextStyle(color: RGBColors.dark_brown, fontSize: Theme.of(context).textTheme.subtitle1.fontSize),),
                                                      ],
                                                    )
                                                ),
                                                SizedBox(width: 25.0,),

                                                Flexible(
                                                  flex: 60,
                                                  fit: FlexFit.tight,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: dogModelSnapshot.data.isMixedBreed != null && dogModelSnapshot.data.isMixedBreed? Icon(Icons.check, color: RGBColors.dark_brown,)
                                                            : Icon(Icons.close, color: _themeData.primaryColor,),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                            SizedBox(height: 10.0,),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Flexible(
                                                    flex: 40,
                                                    fit: FlexFit.tight,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text("Gender", style: TextStyle(color: RGBColors.dark_brown, fontSize: Theme.of(context).textTheme.subtitle1.fontSize),),
                                                      ],
                                                    )
                                                ),
                                                SizedBox(width: 25.0,),

                                                Flexible(
                                                  flex: 60,
                                                  fit: FlexFit.tight,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: dogModelSnapshot.data.genderType != null? Text(
                                                            dogModelSnapshot.data.genderType
                                                        )
                                                            : Text("Unknown", style: TextStyle(color: _themeData.primaryColor),),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                            SizedBox(height: 10.0,),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Flexible(
                                                    flex: 40,
                                                    fit: FlexFit.tight,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text("Breed", style: TextStyle(color: RGBColors.dark_brown, fontSize: Theme.of(context).textTheme.subtitle1.fontSize),),
                                                      ],
                                                    )
                                                ),
                                                SizedBox(width: 25.0,),

                                                Flexible(
                                                  flex: 60,
                                                  fit: FlexFit.tight,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: dogModelSnapshot.data.dogBreed != null? Text(
                                                            dogModelSnapshot.data.dogBreed
                                                        )
                                                            : Text("Unknown", style: TextStyle(color: _themeData.primaryColor),),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                            SizedBox(height: 10.0,),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Flexible(
                                                    flex: 40,
                                                    fit: FlexFit.tight,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text("Date Of Birth", style: TextStyle(color: RGBColors.dark_brown, fontSize: Theme.of(context).textTheme.subtitle1.fontSize),),
                                                      ],
                                                    )
                                                ),
                                                SizedBox(width: 25.0,),

                                                Flexible(
                                                  flex: 60,
                                                  fit: FlexFit.tight,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: dogModelSnapshot.data.dateOfBirth != null? Text(
                                                          DateFormat.yMMMMd().format(dogModelSnapshot.data.dateOfBirth.toDate())
                                                        )
                                                            : Text("Unknown", style: TextStyle(color: _themeData.primaryColor),),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),


                                          ],
                                        ),
                                      ) ,
                                    )

                                  ],
                                );
                              }
                          ),
                        ),
                        StreamBuilder<bool>(
                          stream: _bloc.isCurrentUserDogOwnerBehaviorSubject.stream,
                          builder: (context, snapshot) {

                            if(snapshot.data == null || snapshot.data == false){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 30.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StreamBuilder<Event>(
                                        stream: _bloc.checkIfCurrentUserIsADogFollowerStreamEvent(currentUserId: _bloc.getCurrentUserModel.userId, dogId: dogModelSnapshot.data.userId),
                                        builder: (context, checkIfCurrentUserIsAFlowersnapshot) {

                                          switch(checkIfCurrentUserIsAFlowersnapshot.connectionState){

                                            case ConnectionState.none: case ConnectionState.waiting:
                                              return SpinKitPulse(color: _themeData.primaryColor,);
                                            case ConnectionState.active: case ConnectionState.done:

                                              if (checkIfCurrentUserIsAFlowersnapshot.data.snapshot.value != null){

                                                return InkWell(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                  splashColor: Colors.white,
                                                  highlightColor: Colors.white,
                                                  onTap: (){

                                                    _bloc.removeDogFollower(currentUserId: _bloc.getCurrentUserModel.userId, dogId: dogModelSnapshot.data.userId, dogOwnerId: dogModelSnapshot.data.ownerUserId)
                                                        .then((value){

                                                          _bloc.removeUserDogFollowingUserId(currentUserId: _bloc.getCurrentUserModel.userId, dogId: dogModelSnapshot.data.userId);

                                                          _bloc.getNumberOfFollowers(ownerUserId: dogModelSnapshot.data.ownerUserId, dogId: dogModelSnapshot.data.userId).then((int numFollowers){
                                                            _bloc.numberOfFollowersBehaviorSubject.add(numFollowers);
                                                          });
                                                    });

                                                    _bloc.removeDogFollowing(currentUserId: _bloc.getCurrentUserModel.userId, dogId: dogModelSnapshot.data.userId);

                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                                                    decoration: BoxDecoration(
                                                      color: _themeData.primaryColor.withOpacity(0.4),
                                                      borderRadius: BorderRadius.circular(20.0),

                                                    ),
                                                    child: Center(
                                                      child: Text("UnFollow", style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                                          fontWeight: FontWeight.bold
                                                      ),),
                                                    ),
                                                  ),
                                                );

                                              }
                                              else{


                                                return InkWell(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                  splashColor: Colors.white,
                                                  highlightColor: Colors.white,
                                                  onTap: (){


                                                    _bloc.addDogFollower(optimisedFFModel: OptimisedFFModel(user_id: _bloc.getCurrentUserModel.userId,
                                                        t: Timestamp.now().microsecondsSinceEpoch),
                                                        currentUserId: _bloc.getCurrentUserModel.userId, dogId: dogModelSnapshot.data.userId, dogOwnerId: dogModelSnapshot.data.ownerUserId)
                                                        .then((value){

                                                          _bloc.addUserDogFollowingUserId(currentUserId: _bloc.getCurrentUserModel.userId, dogId: dogModelSnapshot.data.userId);

                                                          _bloc.getNumberOfFollowers(ownerUserId: dogModelSnapshot.data.ownerUserId, dogId: dogModelSnapshot.data.userId).then((int numFollowers){
                                                            _bloc.numberOfFollowersBehaviorSubject.add(numFollowers);
                                                          });

                                                          BasicUI.showSnackBar(context: context, message: "You Followed ${dogModelSnapshot.data.profileName}", textColor: _themeData.primaryColor,
                                                            duration: Duration(seconds: 2)
                                                          );
                                                    });

                                                    _bloc.addDogFollowing(optimisedFFModel: OptimisedFFModel(user_id: dogModelSnapshot.data.userId, t: Timestamp.now().microsecondsSinceEpoch),
                                                        currentUserId: _bloc.getCurrentUserModel.userId, dogId: dogModelSnapshot.data.userId);

                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                                                    decoration: BoxDecoration(
                                                      color: _themeData.primaryColor,
                                                      borderRadius: BorderRadius.circular(20.0),

                                                    ),
                                                    child: Center(
                                                        child: Row(
                                                          children: [
                                                            Text("Follow", style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                                                fontWeight: FontWeight.bold
                                                            ),),
                                                            SizedBox(width: 5.0,),
                                                            Icon(Icons.add, color: Colors.white,)
                                                          ],
                                                        )
                                                    ),
                                                  ),
                                                );
                                              }
                                          }


                                        }
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            else{
                              return Container();
                            }


                          }
                        ),
                        SizedBox(height: 75.0,),

                        Stack(
                          overflow: Overflow.visible,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))
                              ),
                              child: Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                                    child: StreamBuilder<bool>(
                                        stream: _bloc.isListViewBehaviorSubject.stream,
                                        initialData: false,
                                        builder: (context, isListViewSnapshot) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                child: IconButton(
                                                  icon: Icon(Icons.list, color: isListViewSnapshot.data? _themeData.primaryColor: Colors.black54,),
                                                  onPressed: (){

                                                    _bloc.isListViewBehaviorSubject.sink.add(true);
                                                  },
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                child: IconButton(
                                                  icon: Icon(Icons.view_module, color: isListViewSnapshot.data == false? _themeData.primaryColor: Colors.black54,),
                                                  onPressed: (){

                                                    _bloc.isListViewBehaviorSubject.sink.add(false);
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                    ),
                                  ),

                                  StreamBuilder<bool>(
                                      stream: _bloc.isListViewBehaviorSubject.stream,
                                      initialData: false,
                                      builder: (context, isListViewSnapshot) {




                                        return StreamBuilder<List<DogPostModel>>(
                                            stream: _bloc.postsListBehaviorSubject.stream,
                                            builder: (context, dogsPostListSnapshot) {


                                              if (dogsPostListSnapshot.hasData){

                                                if (dogsPostListSnapshot.data.length == 0){
                                                  return Container();
                                                }
                                                else{

                                                  if (isListViewSnapshot.data){
                                                    return GridView.builder(
                                                      itemCount: dogsPostListSnapshot.data.length,
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: isListViewSnapshot.data? 1: 2,
                                                        childAspectRatio: 3.5 / 4,
                                                      ), itemBuilder: (BuildContext context, index){

                                                        return Padding(
                                                          padding: const EdgeInsets.only(bottom: 30.0),
                                                          child: Column(
                                                            children: [

                                                              Padding(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      child: Row(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius: 20.0,
                                                                            backgroundColor: RGBColors.light_yellow,
                                                                            backgroundImage: CachedNetworkImageProvider(dogModelSnapshot.data.profileImageThumb),
                                                                          ),
                                                                          SizedBox(width: 10.0,),
                                                                          Flexible(
                                                                            child: Text(dogModelSnapshot.data.profileName,
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

                                                                    StreamBuilder<bool>(
                                                                      stream: _bloc.isCurrentUserDogOwnerBehaviorSubject.stream,
                                                                      builder: (context, snapshot) {

                                                                        if (snapshot.hasData && snapshot.data){

                                                                          return PopupMenuButton<DOG_POST_MENU_TYPE>(
                                                                            icon: Icon(Icons.more_horiz),
                                                                            itemBuilder: (BuildContext context){
                                                                              return <PopupMenuItem<DOG_POST_MENU_TYPE>>[
                                                                                PopupMenuItem(
                                                                                  child: Text("Delete Post"),
                                                                                  value: DOG_POST_MENU_TYPE.DELETE_POST,
                                                                                )
                                                                              ];
                                                                            },
                                                                            onSelected: (DOG_POST_MENU_TYPE value){
                                                                              if (value == DOG_POST_MENU_TYPE.DELETE_POST){

                                                                                if (_bloc.getOwnerUserModel.userId == _bloc.getCurrentUserModel.userId){

                                                                                  _provider.handlers.deletePostModalDialog(pageContext: context, dogPostModel: dogsPostListSnapshot.data[index]);
                                                                                }
                                                                              }
                                                                            },
                                                                          );

                                                                        }
                                                                        else{
                                                                          return Container();
                                                                        }


                                                                      }
                                                                    )
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
                                                                                stream: _provider.bloc.getCurrentUserStreamModel(currentUserId: _bloc.getCurrentUserId),
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

                                                                                        _provider.bloc.bookmarkDogPost(postId: dogsPostListSnapshot.data[index].postId, currentUserId: _bloc.getCurrentUserId).then((_){
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
                                                        );


                                                    },);
                                                  }
                                                  else{
                                                    return StaggeredGridView.countBuilder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      crossAxisCount: 4,
                                                      itemCount: dogsPostListSnapshot.data.length,
                                                      shrinkWrap: true,
                                                      itemBuilder: (BuildContext context, int index){

                                                        return Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: InkWell(
                                                            onTap: (){

                                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ImageViewer(
                                                                currentIndex: 0,
                                                                imageList: ImageModel.fromJson(dogsPostListSnapshot.data[index].postData).imagesUrl.cast<String>(),
                                                              )));
                                                            },
                                                            child: Card(
                                                              elevation: 5.0,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                              shadowColor: _themeData.primaryColor,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                child: Container(
                                                                  color: Colors.white,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                    children: [
                                                                      Flexible(
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
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

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } ,
                                                      staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 3 : 2),
                                                      mainAxisSpacing: 4.0,
                                                      crossAxisSpacing: 4.0,
                                                    );
                                                  }

                                                }

                                              }
                                              else{

                                                return Padding(
                                                  padding: const EdgeInsets.all(50.0),
                                                  child: SpinKitCubeGrid(size: 100.0, color: _themeData.primaryColor,),
                                                );

                                              }

                                            }
                                        );

                                      }
                                  ),



                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Center(
                                      child: StreamBuilder(
                                        stream: _bloc.hasMorePostsBehaviorSubject.stream,
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
                            ),

                            StreamBuilder<bool>(
                              stream: _bloc.isCurrentUserDogOwnerBehaviorSubject.stream,
                              builder: (context, snapshot) {

                                if (snapshot.hasData && snapshot.data){

                                  return Positioned(
                                    top: -35.0,
                                    right: 50.0,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30.0),
                                      splashColor: _themeData.primaryColor.withOpacity(0.1),
                                      highlightColor: _themeData.primaryColor.withOpacity(0.1),
                                      onTap: (){


                                        if (_bloc.getDogModel.ownerUserId == _bloc.getCurrentUserModel.userId){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreateDogPost(
                                            currentUserModel: _bloc.getCurrentUserModel,
                                            dogModel: _bloc.getDogModel,
                                            dynamicBloc: _bloc,
                                          )));
                                        }
                                      },
                                      child: Container(
                                        width: 70.0,
                                        height: 70.0,
                                        decoration: BoxDecoration(
                                          color: _themeData.primaryColor,
                                          borderRadius: BorderRadius.circular(10000000),

                                        ),
                                        child: Center(
                                          child: Image.asset("assets/images/camera-plus.png", width: 50.0, height: 50.0, color: Colors.white,),
                                          /*
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(FontAwesomeIcons.dog, color: Colors.white,),
                                                SizedBox(width: 2.0,),
                                                Icon(Icons.add, color: Colors.white),
                                              ],
                                            )
                                                */
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                else{
                                  return Container();
                                }

                              }
                            )
                          ],
                        )


                      ],
                    ),
                  ),
                )
            );
          }
          else{
            return Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitFadingCube(color: CupertinoTheme.of(context).primaryColor, size: 50.0,),
                )
            );
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


    DogPageBloc _bloc = DogPageBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;



    return Container(
      child: StreamBuilder<Event>(
        stream: _bloc.getIfUserLikedPostStream(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _bloc.getCurrentUserId),
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

                  _bloc.addPostLike(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _bloc.getCurrentUserId);

                  AppAnimations.animateDogPostLike(context: context);
                }
                else{

                  _bloc.removePostLike(postId: dogPostModel.postId, dogId: dogPostModel.dogUserId, currentUserId: _bloc.getCurrentUserId);
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