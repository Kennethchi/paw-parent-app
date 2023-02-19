import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/dog_page/dog_page.dart';
import 'package:paw_parent_app/features/profile/profile.dart';
import 'package:paw_parent_app/features/search/search_bloc.dart';
import 'package:paw_parent_app/features/search/search_bloc_provider.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SearchBlocProvider _provider = SearchBlocProvider.of(context);
    SearchBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Search By:", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(width: 20.0,),

              StreamBuilder<SEARCH_TYPE>(
                stream: _bloc.searchTypeBehaviorSubject,
                initialData: SEARCH_TYPE.DOG_USERNAME,
                builder: (context, snapshot) {
                  return DropdownButton<SEARCH_TYPE>(
                    value: snapshot.data,
                      items: [
                        DropdownMenuItem<SEARCH_TYPE>(
                          value: SEARCH_TYPE.USER_USERNAME,
                          child: Text("User username")
                        ),
                        DropdownMenuItem<SEARCH_TYPE>(
                          value: SEARCH_TYPE.DOG_USERNAME,
                          child: Text("Dog username"),
                        )
                      ],
                      onChanged: (SEARCH_TYPE searchType){
                        _bloc.searchTypeBehaviorSubject.add(searchType);
                        _bloc.isSearchingBehaviorSunject.add(false);
                      },
                  );
                }
              ),
            ],
          ),
          SizedBox(height: 20.0,),

          TextField(
            controller: _provider.searchTextEditingController,
            maxLines: 1,
            decoration: InputDecoration(
              border:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  gapPadding: 0.0,
                  borderSide: BorderSide(color: _themeData.primaryColor, width: 1000.0)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  gapPadding: 0.0,
                  borderSide: BorderSide(color: _themeData.primaryColor, width: 2.0)
              ),
              hintText: "Search...",
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.3),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            ),
          ),
          SizedBox(height: 10.0,),
          StreamBuilder<String>(
            stream: _bloc.searchTextBehaviorSubject,
            builder: (context, snapshot) {
              return CupertinoButton.filled(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                borderRadius: BorderRadius.circular(15.0),
                onPressed: snapshot.hasData && snapshot.data.trim().isNotEmpty? (){

                  _bloc.isSearchingBehaviorSunject.add(true);

                  _provider.searchTextEditingController.clear();

                  if (_bloc.get_search_type == SEARCH_TYPE.USER_USERNAME){
                    _bloc.getSearchUser(searchUserUsername: snapshot.data.trim().toLowerCase()).then((UserModel userModel){
                      _bloc.searchUserModelBehaviorSubject.add(userModel);
                    });
                  }
                  else if (_bloc.get_search_type == SEARCH_TYPE.DOG_USERNAME){
                    _bloc.getSearchDog(searchDogUsername: snapshot.data.trim().toLowerCase()).then((DogModel dogModel){
                      _bloc.searchDogModelBehaviorSubject.add(dogModel);
                    });
                  }

                }: null,
                child: Text("Search", style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),),
              );
            }
          ),
          SizedBox(height: 20.0,),

          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: StreamBuilder<bool>(
                stream: _bloc.isSearchingBehaviorSunject,
                builder: (context, snapshot) {

                  if (snapshot.hasData && snapshot.data){
                    return Container(
                      child: StreamBuilder<SEARCH_TYPE>(
                          stream: _bloc.searchTypeBehaviorSubject,
                          builder: (context, snapshot) {

                            if (snapshot.hasData){

                              if (snapshot.data == SEARCH_TYPE.USER_USERNAME){
                                return StreamBuilder<UserModel>(
                                    stream: _bloc.searchUserModelBehaviorSubject,
                                    builder: (context, snapshot) {

                                      switch(snapshot.connectionState){

                                        case ConnectionState.none: case ConnectionState.waiting:
                                          return Center(
                                            child: Column(
                                              children: [
                                                DogLoaderWidget(width: 100.0, height: 100.0,),
                                                SizedBox(height: 10.0,),
                                                Text("Searching...", style: TextStyle(color: Colors.black.withOpacity(0.2), fontWeight: FontWeight.bold,
                                                  fontSize: Theme.of(context).textTheme.headline6.fontSize
                                                ),)
                                              ],
                                            ),
                                          );
                                        case ConnectionState.active:case ConnectionState.done:

                                        if (snapshot.data != null){
                                          return GestureDetector(
                                            onTap: (){

                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Profile(profileUserModel: snapshot.data,)));
                                            },
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 25.0,
                                                backgroundColor: RGBColors.light_blue,
                                                backgroundImage: snapshot.data.profileImageThumb == null || snapshot.data.profileImageThumb.trim().isEmpty
                                                    ? null: CachedNetworkImageProvider(
                                                    snapshot.data.profileImageThumb
                                                ),
                                                child: snapshot.data.profileImageThumb == null || snapshot.data.profileImageThumb.trim().isEmpty
                                                    ? Icon(Icons.person, color: Colors.white, size: 30.0,)
                                                    : Container(),
                                              ),
                                              title: Text(snapshot.data.profileName),
                                              subtitle: Text("@" + snapshot.data.username, style: TextStyle(color: Colors.black54.withOpacity(0.4)),),
                                            ),
                                          );
                                        }
                                        else{
                                          return Center(child: Text("Data Not Found"));
                                        }

                                      }

                                    }
                                );
                              }
                              else if (snapshot.data == SEARCH_TYPE.DOG_USERNAME){
                                return StreamBuilder<DogModel>(
                                    stream: _bloc.searchDogModelBehaviorSubject,
                                    builder: (context, snapshot) {

                                      switch(snapshot.connectionState){

                                        case ConnectionState.none: case ConnectionState.waiting:
                                        return Center(
                                          child: Column(
                                            children: [
                                              DogLoaderWidget(width: 100.0, height: 100.0,),
                                              SizedBox(height: 10.0,),
                                              Text("Searching...", style: TextStyle(color: Colors.black.withOpacity(0.2), fontWeight: FontWeight.bold,
                                                  fontSize: Theme.of(context).textTheme.headline6.fontSize
                                              ),)
                                            ],
                                          ),
                                        );
                                        case ConnectionState.active:case ConnectionState.done:

                                        if (snapshot.data != null){
                                          return GestureDetector(
                                            onTap: (){

                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DogPage(
                                                dogModel: snapshot.data,
                                                ownerUserModel: snapshot.data.ownerUserModel,
                                              )));
                                            },
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 25.0,
                                                backgroundColor: RGBColors.light_blue,
                                                backgroundImage: snapshot.data.profileImageThumb == null || snapshot.data.profileImageThumb.trim().isEmpty
                                                    ? null: CachedNetworkImageProvider(
                                                    snapshot.data.profileImageThumb
                                                ),
                                                child: snapshot.data.profileImageThumb == null || snapshot.data.profileImageThumb.trim().isEmpty
                                                    ? Icon(Icons.person, color: Colors.white, size: 30.0,)
                                                    : Container(),
                                              ),
                                              title: Text(snapshot.data.profileName),
                                              subtitle: Text("@" + snapshot.data.username, style: TextStyle(color: Colors.black54.withOpacity(0.4)),),
                                            ),
                                          );
                                        }
                                        else{
                                          return Center(child: Text("Data Not Found"));
                                        }

                                      }

                                    }
                                );
                              }
                              else{
                                return Container();
                              }

                            }else{
                              return Container();
                            }


                          }
                      ),
                    );
                  }
                  else{

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: Icon(Icons.search, size: 100.0, color: Colors.black.withOpacity(0.2),)),
                        SizedBox(height: 10.0,),
                        Center(child: Text("Search", style: TextStyle(color: Colors.black.withOpacity(0.2), fontSize: Theme.of(context).textTheme.headline6.fontSize, fontWeight: FontWeight.bold),))
                      ],
                    );
                  }

                }
              ),
            ),
          )

        ],
      ),
    );
  }
}
