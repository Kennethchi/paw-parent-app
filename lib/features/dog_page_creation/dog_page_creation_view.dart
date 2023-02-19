import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/constants/dog_breeds_list.dart';
import 'package:paw_parent_app/features/dog_page_creation/dog_page_creation_bloc.dart';
import 'package:paw_parent_app/features/dog_page_creation/dog_page_creation_bloc_provider.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/ui/chip_tags/chip_tags.dart';



class DogPageCreationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    DogPageCreationBlocProvider _provider = DogPageCreationBlocProvider.of(context);
    DogPageCreationBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(

          children: <Widget>[

            SizedBox(height: 40.0,),
            GestureDetector(
              onTap: (){

                _provider.handlers.showDogImageSelectOptionModal(pageContext: context);

              },
              child: Stack(
                children: [
                  StreamBuilder<File>(
                    stream: _bloc.dogProfileImageFileBehaviorSubject.stream,
                    builder: (context, snapshot) {
                      return CircleAvatar(
                        radius: 80.0,
                        backgroundColor: RGBColors.light_yellow,
                        backgroundImage: snapshot.hasData? FileImage(snapshot.data): null,
                        child: snapshot.hasData? null: Center(
                          child: Icon(FontAwesomeIcons.dog, color: Colors.white, size: 75.0,),
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
            SizedBox(height: 20.0,),

            TextField(
              controller: _provider.dogProfileNameTextEditingController,
              maxLines: 1,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                prefixIcon: Icon(FontAwesomeIcons.dog, color: _themeData.primaryColor,),
                hintText: "Pet Name",
                labelText: "Pet Name",
                labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.2)
                ),
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),

            TextField(
              controller: _provider.dogUsernameTextEditingController,
              maxLines: 1,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                prefixIcon: Icon(FontAwesomeIcons.dog, color: _themeData.primaryColor,),
                hintText: "Pet Username",
                labelText: "Pet Username",
                labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.2)
                ),
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
            SizedBox(height: 40.0,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Text("About:", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0,),

                TextField(
                  controller: _provider.dogAboutTextEditingController,
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
                    hintText: "Write about your Pet...",
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.3),
                    ),
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Behaviors:", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0,),
                
                ChipTags(
                  onCompleted: (List<String> resultTags){

                    _bloc.dogBehaviorsListBehaviorSubject.add(resultTags);
                  },
                  chipColor: _themeData.primaryColor,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  keyboardType: TextInputType.text,
                  hintText: "Add Behavior",
                ),
              ],
            ),
            SizedBox(height: 40.0,),

            Row(
              children: [
                Text("Gender:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20.0,),
                Flexible(
                  child: StreamBuilder<String>(
                      stream: _bloc.genderTypeBehaviorSubject,
                      builder: (context, snapshot) {

                        return GestureDetector(
                          onTap: () {

                            showCupertinoModalPopup(context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    color: Colors.white,
                                    height: screenHeight * 0.2,
                                    child: CupertinoPicker(itemExtent: 40.0,
                                      magnification: 1.2,
                                      onSelectedItemChanged: (int index) {
                                        _bloc.genderTypeBehaviorSubject.add(
                                            get_dog_gender_types[index]);
                                      },
                                      children: get_dog_gender_types.map((
                                          String breed) {
                                        return Center(child: Text(breed, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Theme.of(context).textTheme.subtitle1.fontSize),));
                                      }).toList(),
                                    ),
                                  );
                                });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(child: Text(snapshot.data == null? "Select Gender": snapshot.data,)),
                                  SizedBox(width: 20.0,),
                                  Icon(Icons.arrow_drop_down, color: Colors.black54,)
                                ],
                              ),
                            ),
                          ),
                        );

                      }
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0,),

            Row(
              children: [
                Text("Breed:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20.0,),
                Flexible(
                  child: StreamBuilder<String>(
                    stream: _bloc.dogBreedBehaviorSubject.stream,
                    builder: (context, snapshot) {

                      return GestureDetector(
                        onTap: () {

                          showCupertinoModalPopup(context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Colors.white,
                                  height: screenHeight * 0.25,
                                  child: CupertinoPicker(itemExtent: 40.0,
                                    magnification: 1.2,
                                    onSelectedItemChanged: (int index) {
                                      _bloc.dogBreedBehaviorSubject.add(
                                          get_dog_breeds_list[index]);
                                    },
                                    children: get_dog_breeds_list.map((
                                        String breed) {
                                      return Center(child: Text(breed, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: Theme.of(context).textTheme.subtitle1.fontSize),));
                                    }).toList(),
                                  ),
                                );
                              });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: Text(snapshot.data == null? "Select Breed": snapshot.data,)),
                                SizedBox(width: 20.0,),
                                Icon(Icons.arrow_drop_down, color: Colors.black54,)
                              ],
                            ),
                          ),
                        ),
                      );

                    }
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),

            Row(
              children: [
                Text("Date Of Birth:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20.0,),
                Flexible(
                  child: StreamBuilder<DateTime>(
                      stream: _bloc.dateOfBirthBehaviorSubject,
                      builder: (context, snapshot) {

                        return GestureDetector(
                          onTap: () {

                            showCupertinoModalPopup(context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    color: Colors.white,
                                    height: screenHeight * 0.25,
                                    child: DatePickerWidget(
                                      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                                      lastDate: DateTime.now(),
                                      onChange: (DateTime dateTime, List<int> data){
                                        _bloc.dateOfBirthBehaviorSubject.add(dateTime);
                                      },
                                    ),
                                  );
                                });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(child: Text(snapshot.data == null? "Select Date": DateFormat.yMMMMd().format(snapshot.data),)),
                                  SizedBox(width: 20.0,),
                                  Icon(Icons.arrow_drop_down, color: Colors.black54,)
                                ],
                              ),
                            ),
                          ),
                        );

                      }
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),


            Row(
              children: [

                StreamBuilder<bool>(
                    stream: _bloc.isDogVaccinatedBehaviorSubject.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Checkbox(
                        value: snapshot.data,
                        checkColor: Colors.white,
                        activeColor: _themeData.primaryColor,
                        onChanged: (bool checked){
                          _bloc.isDogVaccinatedBehaviorSubject.sink.add(checked);
                        },
                      );
                    }
                ),

                Text("Vaccinated", style: TextStyle(fontWeight: FontWeight.bold)),

              ],
            ),

            Row(
              children: [

                StreamBuilder<bool>(
                    stream: _bloc.isDogMixedBreedBehaviorSubject.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Checkbox(
                          value: snapshot.data,
                          checkColor: Colors.white,
                          activeColor: _themeData.primaryColor,
                          onChanged: (bool checked){
                            _bloc.isDogMixedBreedBehaviorSubject.sink.add(checked);
                          }
                      );
                    }
                ),

                Text("Mixed Breed", style: TextStyle(fontWeight: FontWeight.bold)),

              ],
            ),

            SizedBox(height: 40.0),
            StreamBuilder<bool>(
              stream: _bloc.showCreatePageButtonBehaviorSubject.stream,
              builder: (context, snapshot) {

                if (snapshot.hasData && snapshot.data){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(30.0),
                        splashColor: Colors.white,
                        highlightColor: Colors.white,
                        onTap: (){

                          _provider.handlers.createDogPage(pageContext: context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                          decoration: BoxDecoration(
                            color: _themeData.primaryColor,
                            borderRadius: BorderRadius.circular(20.0),

                          ),
                          child: Center(
                              child: Text("Create Page", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                                  fontWeight: FontWeight.bold
                              ),)
                          ),
                        ),
                      ),
                    ],
                  );
                }
                else{
                  return Container();
                }


              }
            ),

            SizedBox(height: 50.0,)
          ],


        ),
      ),
    );

  }
}
