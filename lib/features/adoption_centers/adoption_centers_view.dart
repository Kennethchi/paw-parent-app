import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/adoption_centers/adoption_centers_bloc.dart';
import 'package:paw_parent_app/features/adoption_centers/adoption_centers_bloc_provider.dart';
import 'package:paw_parent_app/features/profile/profile.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/ui/list_shimmer/list_shimmer.dart';
import 'package:shimmer/shimmer.dart';



class AdoptionCentersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AdoptionCentersBlocProvider _provider = AdoptionCentersBlocProvider.of(context);
    AdoptionCentersBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<List<UserModel>>(
      stream: _bloc.usersListBehaviorSubject,
      builder: (context, usersListSnapshot) {

        if (usersListSnapshot.hasData){

          if (usersListSnapshot.data.length == 0){

            return Center(
              child: Text("No Data Available"),
            );
          }
          else{

            return ListView.builder(
              controller: _provider.scrollController,
              itemCount: usersListSnapshot.data.length,
              itemBuilder: (BuildContext context, int index){

                UserModel userModel = usersListSnapshot.data[index];

                return InkWell(
                  onTap: (){

                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Profile(profileUserModel: userModel,)));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: RGBColors.light_yellow,
                      backgroundImage: userModel.profileImageThumb == null || userModel.profileImageThumb.trim().isEmpty
                          ? null: CachedNetworkImageProvider(
                        userModel.profileImageThumb
                      ),
                      child: userModel.profileImageThumb == null || userModel.profileImageThumb.trim().isEmpty
                          ? Icon(Icons.person, color: Colors.black.withOpacity(0.2), size: 30.0,)
                          : Container(),
                    ),
                    title: Text(userModel.profileName),
                    subtitle: Text("@" + userModel.username, style: TextStyle(color: Colors.black54.withOpacity(0.4)),),
                  ),
                );
              }
            );
          }

          return Container();
        }
        else{
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListShimmer(),
          );
        }

        return Container();
      }

    );
  }
}
