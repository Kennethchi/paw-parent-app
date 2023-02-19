


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paw_parent_app/features/dog_page/dog_page.dart';
import 'package:paw_parent_app/features/trending_adoptibles/trending_adoptibles_bloc.dart';
import 'package:paw_parent_app/features/trending_adoptibles/trending_adoptibles_bloc_provider.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/ui/list_shimmer/list_shimmer.dart';

class TrendingAdoptiblesView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    TrendingAdoptiblesBlocProvider _provider = TrendingAdoptiblesBlocProvider.of(context);
    TrendingAdoptiblesBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<List<DogModel>>(
        stream: _bloc.dogsListBehaviorSubject,
        builder: (context, dogsListSnapshot) {

          if (dogsListSnapshot.hasData){

            if (dogsListSnapshot.data.length == 0){

              return Center(
                child: Text("No Data Available"),
              );
            }
            else{

              return ListView.builder(
                  controller: _provider.scrollController,
                  itemCount: dogsListSnapshot.data.length,
                  itemBuilder: (BuildContext context, int index){

                    DogModel dogModel = dogsListSnapshot.data[index];

                    return InkWell(
                      onTap: (){

                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPage(dogModel: dogModel, ownerUserModel: dogModel.ownerUserModel,)));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: RGBColors.light_yellow,
                          backgroundImage: dogModel.profileImageThumb == null || dogModel.profileImageThumb.trim().isEmpty
                              ? null: CachedNetworkImageProvider(
                              dogModel.profileImageThumb
                          ),
                          child: dogModel.profileImageThumb == null || dogModel.profileImageThumb.trim().isEmpty
                              ? Icon(Icons.person, color: Colors.black.withOpacity(0.2), size: 30.0,)
                              : Container(),
                        ),
                        title: Text(dogModel.profileName),
                        subtitle: Text("@" + dogModel.username, style: TextStyle(color: Colors.black54.withOpacity(0.4)),),
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
