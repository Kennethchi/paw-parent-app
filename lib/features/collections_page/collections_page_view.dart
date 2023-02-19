import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'collections_page_bloc.dart';
import 'collections_page_bloc_provider.dart';




class CollectionsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CollectionsPageBlocProvider _provider = CollectionsPageBlocProvider.of(context);
    CollectionsPageBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return ListView(
      children: [
        
        InkWell(
          onTap: (){
            _provider.handlers.showBookmarkedDogPostsModal(pageContext: context);
          },
          child: ListTile(
            leading: Icon(
              Icons.bookmark,
              color: _themeData.primaryColor,
            ),
            title: Text("Dog Posts Bookmarks"),
          ),
        ),

        InkWell(
          onTap: (){

            _provider.handlers.showBookmarkedInsightsModal(pageContext: context);
          },
          child: ListTile(
            leading: Icon(
              Icons.bookmark,
              color: _themeData.primaryColor,
            ),
            title: Text("Insights Bookmarks"),
          ),
        )
        
      ],
    );
  }
}
