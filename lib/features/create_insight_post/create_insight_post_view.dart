import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/ui/chip_tags/chip_hash_tags.dart';
import 'package:paw_parent_app/ui/chip_tags/chip_tags.dart';

import 'create_insight_post_bloc.dart';
import 'create_insight_post_bloc_provider.dart';



class CreateInsightPostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CreateInsightPostBlocProvider _provider = CreateInsightPostBlocProvider.of(context);
    CreateInsightPostBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return SingleChildScrollView(
      child: Column(
        children: [

          GestureDetector(
            onTap: (){

              _provider.handlers.showInsightImageSelectOptionModal(pageContext: context);

            },
            child: Stack(
              children: [
                StreamBuilder<File>(
                    stream: _bloc.insightImageFileBehaviorSubject.stream,
                    builder: (context, snapshot) {

                      return Container(
                        width: double.infinity,
                        height: screenHeight * 0.3,
                        decoration: BoxDecoration(
                          color: RGBColors.light_yellow,
                          image: snapshot.hasData? DecorationImage(
                              image: FileImage(snapshot.data),
                            fit: BoxFit.cover
                          ): null
                        ),
                          child: snapshot.hasData? null: Center(
                            child: Icon(FontAwesomeIcons.image, color: Colors.white, size: 75.0,),
                          )
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [

                    Text("Title:", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 20.0,),

                    Flexible(
                      child: TextField(
                        controller: _provider.titleTextEditingController,
                        maxLines: null,
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
                          hintText: "Write Title",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0,),
                Row(
                  children: [

                    Text("Content:", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 20.0,),

                    Flexible(
                      child: TextField(
                        controller: _provider.contentTextEditingController,
                        maxLines: null,
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
                          hintText: "Write Content",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.0,),

                Row(
                  children: [
                    Text("Tags:", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 20.0,),

                    Flexible(
                      child: ChipHashTags(
                        onCompleted: (List<String> resultTags){

                          _bloc.insightTagsListBehaviorSubject.add(resultTags);
                        },
                        chipColor: _themeData.primaryColor,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        keyboardType: TextInputType.text,
                        hintText: "Add Tag",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0,),

                StreamBuilder<bool>(
                  stream: _bloc.showCreateInsightButtonBehaviorSubject,
                  builder: (context, snapshot) {
                    return CupertinoButton(
                      borderRadius: BorderRadius.circular(20.0),
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      color: _themeData.primaryColor,
                      onPressed: snapshot.hasData && snapshot.data? (){

                        _provider.handlers.createInsight(pageContext: context);
                      }: null,
                      child: Text("Create Insight", style: TextStyle(
                        color: Colors.white,
                        fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                        fontWeight: FontWeight.bold
                      ),),
                    );
                  }
                ),
                SizedBox(height: 50.0,),

              ],
            ),
          ),


        ],
      ),
    );
  }
}


