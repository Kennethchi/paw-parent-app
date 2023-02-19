import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



import 'package:paw_parent_app/features/profile_settings/profile_settings.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_bloc.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_bloc_provider.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';

class ProfileSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ProfileSettingsBlocProvider _provider = ProfileSettingsBlocProvider.of(context);
    ProfileSettingsBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<UserModel>(
      stream: _bloc.currentUserModelBehaviorSubject.stream,
      builder: (context, snapshot) {

        if (snapshot.hasData){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [

                SizedBox(height: 40.0,),
                GestureDetector(
                  onTap: (){

                    _provider.handlers.showProfileImageSelectOptionModal(pageContext: context);
                  },
                  child: Stack(
                    children: [
                      StreamBuilder<UserModel>(
                        stream: _bloc.currentUserModelBehaviorSubject,
                        builder: (context, currentUserModelSnapshot) {
                          return CircleAvatar(
                            radius: 80.0,
                            backgroundColor: RGBColors.light_yellow,
                            backgroundImage: currentUserModelSnapshot.hasData && currentUserModelSnapshot.data.profileImage.isNotEmpty && currentUserModelSnapshot.data.profileImage != null
                                ? CachedNetworkImageProvider(currentUserModelSnapshot.data.profileImage): null,
                            child: currentUserModelSnapshot.hasData && currentUserModelSnapshot.data.profileImage.isNotEmpty && currentUserModelSnapshot.data.profileImage != null? null: Center(
                              child: Icon(Icons.person, color: Colors.white, size: 75.0,),
                            ),
                          );
                        }
                      ),

                      Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: Icon(Icons.camera_alt, size: 40.0,)
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40.0,),
                InkWell(
                  onTap: (){
                    _provider.handlers.updateUserProfileNameModal(pageContext: context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Profile Name"),
                    subtitle: Text(snapshot.data.profileName, style: TextStyle(color: _themeData.primaryColor),),
                    trailing: Icon(Icons.edit, color: Colors.black54,),
                  ),
                ),

                SizedBox(height: 50.0,)

              ],
            ),
          );
        }
        else{
          return Center(
            child: SpinKitPulse(color: _themeData.primaryColor,),
          );
        }


      }
    );
  }
}
