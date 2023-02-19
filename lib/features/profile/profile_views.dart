import 'dart:math';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/chat_room/chat_room.dart';
import 'package:paw_parent_app/features/dog_page/dog_page.dart';
import 'package:paw_parent_app/features/dog_page_creation/dog_page_creation.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'file:///D:/PROJECTS/CONTRACT_PROJECTS/Paw_Parent_Project/paw_parent_app/lib/features/calendar_schedule/calendar_schedule.dart';
import 'package:paw_parent_app/ui/image_viewer/image_viewer.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/string_utils.dart';

import 'profile_bloc.dart';
import 'profile_bloc_provider.dart';





class ProfileViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ProfileBlocProvider _provider = ProfileBlocProvider.of(context);
    ProfileBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<UserModel>(
        stream: _bloc.profileUserModelBehaviorSubject.stream,
        builder: (context, profileUserSnapshot) {

          if (profileUserSnapshot.hasData){
            return Container(
                color: RGBColors.cream_light_brown,
                child: SingleChildScrollView(
                  controller: _provider.scrollController,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Row(
                          children: [

                            StreamBuilder<bool>(
                                stream: _bloc.isProfileUserEqualCurrentUserBehaviorSubject.stream,
                                builder: (context, snapshot) {

                                  if (snapshot.hasData && snapshot.data == false){
                                    return IconButton(
                                      onPressed: (){

                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.arrow_back_ios, color: Colors.black54,),
                                    );
                                  }
                                  else{
                                    return Container();
                                  }

                                }
                            ),
                            
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Text("@" + profileUserSnapshot.data.username, style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.headline5.fontSize,
                                        fontWeight: FontWeight.bold,
                                      color: Colors.black54
                                    ),),

                                    StreamBuilder<bool>(
                                      stream: _bloc.isProfileUserEqualCurrentUserBehaviorSubject.stream,
                                      builder: (context, snapshot) {

                                        if (snapshot.hasData && snapshot.data){
                                          return IconButton(
                                            onPressed: (){

                                              _provider.handlers.showAccountOptionsModal(pageContext: context);
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
                            ),
                          ],
                        ),

                        SizedBox(height: 40.0,),
                        GestureDetector(
                          onTap: profileUserSnapshot.hasData && profileUserSnapshot.data.profileImage.isNotEmpty && profileUserSnapshot.data.profileImage != null?(){


                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ImageViewer(
                              currentIndex: 0,
                              imageList: [profileUserSnapshot.data.profileImage],
                            )));

                          }: null,
                          child: CircleAvatar(
                            radius: 80.0,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 75.0,
                              backgroundColor: RGBColors.cream_light_brown,
                              backgroundImage: profileUserSnapshot.hasData && profileUserSnapshot.data.profileImage.isNotEmpty && profileUserSnapshot.data.profileImage != null
                                  ? CachedNetworkImageProvider(profileUserSnapshot.data.profileImage): null,
                              child: profileUserSnapshot.hasData && profileUserSnapshot.data.profileImage.isNotEmpty && profileUserSnapshot.data.profileImage != null
                                  ? Container(): Icon(Icons.person, color: Colors.white, size: 100.0,),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(profileUserSnapshot.data.profileName, style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.headline5.fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),),
                            ),
                            Container(
                                child: profileUserSnapshot.data.userType == UserType.adoption_center? Row(
                                  children: [
                                    SizedBox(width: 20.0,),
                                    Icon(FontAwesomeIcons.storeAlt, color: RGBColors.light_blue,),
                                  ],
                                ): Container()
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: <Widget>[
                                  Text("Dogs"),
                                  SizedBox(height: 5.0,),

                                  Container(
                                    child: profileUserSnapshot.data.userId == _bloc.getCurrentUserModel.userId? StreamBuilder<Event>(

                                        stream: _bloc.getNumberOfDogsStreamEvent(profileUserId: profileUserSnapshot.data.userId),
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
                                          future: _bloc.getNumberOfDogs(profileUserId: profileUserSnapshot.data.userId),
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
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: <Widget>[
                                  Text("Following"),
                                  SizedBox(height: 5.0,),
                                  StreamBuilder<int>(
                                      stream: _bloc.numberOfFollowingsBehaviorSubject.stream,
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
                            )

                          ],
                        ),
                        StreamBuilder<bool>(
                          stream: _bloc.isProfileUserEqualCurrentUserBehaviorSubject.stream,
                          builder: (context, snapshot) {

                            if (snapshot.hasData && snapshot.data){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 25.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(30.0),
                                        splashColor: Colors.white,
                                        highlightColor: Colors.white,
                                        onTap: (){

                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPageCreation(
                                            dynamicBloc: _bloc,
                                            currentUserModel: profileUserSnapshot.data,
                                          )));
                                        },
                                        child: CircleAvatar(
                                          radius: 35.0,
                                          backgroundColor: _themeData.primaryColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Center(
                                              child: FittedBox(
                                                child: Row(
                                                  children: [
                                                    Icon(FontAwesomeIcons.dog, color: Colors.white,),
                                                    SizedBox(width: 2.0,),
                                                    Icon(FontAwesomeIcons.plus, color: Colors.white,),
                                                  ],
                                                ),
                                              ),
                                              /*
                                                child: Text("Create Dog Page", style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                                    fontWeight: FontWeight.bold
                                                ),)
                                                    */
                                            ),
                                          ),
                                        ),
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
                        StreamBuilder<bool>(
                          stream: _bloc.isProfileUserEqualCurrentUserBehaviorSubject,
                          builder: (context, snapshot) {

                            switch(snapshot.connectionState){

                              case ConnectionState.none: case ConnectionState.waiting:
                                return Container();
                              case ConnectionState.active: case ConnectionState.done:

                                if (snapshot.data == false){
                                  return Column(
                                    children: [
                                      SizedBox(height: 20.0,),
                                      CupertinoButton.filled(
                                        borderRadius: BorderRadius.circular(30.0),
                                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),

                                        onPressed: (){

                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChatRoom(
                                            currentUserModel: _bloc.getCurrentUserModel,
                                            chatUserModel: profileUserSnapshot.data,
                                          )));
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            Icon(FontAwesomeIcons.comments, color: Colors.white,),
                                            SizedBox(width: 15.0,),
                                            Text("Message", style: TextStyle(
                                                color: Colors.white,
                                              fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                              fontWeight: FontWeight.bold
                                            ),),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }
                                else{
                                  return Container();
                                }

                            }



                          }
                        ),

                        SizedBox(height: 50.0,),

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



                                        return StreamBuilder<List<DogModel>>(
                                            stream: _bloc.dogsListBehaviorSubject.stream,
                                            builder: (context, dogsListSnapshot) {


                                              if (dogsListSnapshot.hasData){

                                                if (dogsListSnapshot.data.length == 0){
                                                  return Container();
                                                }
                                                else{


                                                  return GridView.builder(
                                                    itemCount: dogsListSnapshot.data.length,
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: isListViewSnapshot.data? 1: 2,
                                                      childAspectRatio: isListViewSnapshot.data? 4 / 3:  11/ 16,
                                                    ), itemBuilder: (BuildContext context, index){

                                                    return Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: InkWell(
                                                        onTap: (){

                                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPage(
                                                            ownerUserModel: _bloc.getCurrentUserModel,
                                                            dogModel: dogsListSnapshot.data[index],
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
                                                                    fit: FlexFit.tight,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: dogsListSnapshot.data[index].profileImageThumb,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                      children: [
                                                                        Text(dogsListSnapshot.data[index].profileName, style: TextStyle(
                                                                            fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black54
                                                                        ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                                        SizedBox(height: 10.0,),

                                                                        Text(dogsListSnapshot.data[index].dogBreed, style: TextStyle(
                                                                          fontSize: Theme.of(context).textTheme.caption.fontSize,
                                                                        ), overflow: TextOverflow.ellipsis, maxLines: 1,)
                                                                      ],
                                                                    ),
                                                                  ),


                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );

                                                  },);
                                                }

                                              }
                                              else{


                                                return Padding(
                                                  padding: const EdgeInsets.all(50.0),
                                                  child: Center(
                                                    child: DogLoaderWidget(width: 100.0, height: 100.0,),
                                                  ),
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
                            ),



                            /*
                            StreamBuilder<bool>(
                              stream: _bloc.isProfileUserEqualCurrentUserBehaviorSubject.stream,
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

                                        Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context)=> CalendarSchedule() ));
                                      },
                                      child: Container(
                                        width: 70.0,
                                        height: 70.0,
                                        decoration: BoxDecoration(
                                          color: _themeData.primaryColor,
                                          borderRadius: BorderRadius.circular(10000000),

                                        ),
                                        child: Center(
                                            child: Icon(Icons.calendar_today, color: Colors.white,)
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
                            */



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
