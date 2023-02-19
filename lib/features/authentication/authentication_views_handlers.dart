import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/home/home.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/ui/basic_ui.dart';
import 'package:paw_parent_app/ui/loader_widgets/dog_loader_widget.dart';
import 'package:paw_parent_app/utils/encryption.dart';
import 'package:paw_parent_app/utils/string_utils.dart';
import 'authentication_bloc.dart';
import 'authentication_bloc_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';




class AuthenticationViewHandlers{

  Future<void> loginUser({@required BuildContext pageContext}){

    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(pageContext);
    AuthenticationBloc _bloc = _provider.bloc;
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);


    String email = _provider.signInEmailTextEditingController.text.trim();
    String password = _provider.signInPasswordTextEditingController.text;


    if (email.isEmpty || password.isEmpty){

      Flushbar(
        messageText:  Text("Fill all Blank Fields", style: TextStyle(color: CupertinoColors.destructiveRed)),
        backgroundColor: Colors.black,
        duration:  Duration(seconds: 1),
      )..show(pageContext);
    }
    else{

      BasicUI.showProgressDialog(pageContext: pageContext, child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: <Widget>[

            DogLoaderWidget(),

            SizedBox(height: 50.0,),
            Text("Authentication processing...",
              style: TextStyle(
                  color: _themeData.primaryColor,
                fontSize: Theme.of(pageContext).textTheme.headline6.fontSize,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ));

      _bloc.signInUserWithEmailAndPassword(email: email, password: password).then((AuthResult authResult){

        if (authResult.user != null){

          Navigator.pop(pageContext);

          Flushbar(
            messageText:  Text("Successfully Signed In", style: TextStyle(color: _themeData.primaryColor)),
            backgroundColor: Colors.black,
            duration:  Duration(seconds: 4),
          )..show(pageContext);

          Timer(Duration(seconds: 4), (){
            Navigator.of(pageContext).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
              return Home();
            }), (Route<dynamic> route) => false);
          });
        }
        else{
          Navigator.of(pageContext).pop();

          Flushbar(
            //title:  "Hey Ninja",
            messageText:  Text("An error occured", style: TextStyle(color: CupertinoColors.destructiveRed),),
            backgroundColor: Colors.black,
            duration:  Duration(seconds: 3),
          )..show(pageContext);
        }

      }).catchError((e){
        Navigator.of(pageContext).pop();

        Flushbar(
          messageText:  Text(e.toString(), style: TextStyle(color: CupertinoColors.destructiveRed),),
          backgroundColor: Colors.black,
          duration:  Duration(seconds: 3),
        )..show(pageContext);
      });
    }

  }



  Future<void> signupUser({@required BuildContext pageContext}){

    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(pageContext);
    AuthenticationBloc _bloc = _provider.bloc;
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);

    String profileName = StringUtils.toUpperCaseLower(_provider.registerProfileNameTextEditingController.text.trim());
    String username = StringUtils.removeAllSpaces(_provider.registerUsernameTextEditingController.text.trim()).toLowerCase();
    String email = _provider.registerEmailTextEditingController.text.trim();
    String password = _provider.registerPasswordTextEditingController.text;
    String confirmPassword = _provider.registerConfirmPasswordTextEditingController.text;

    RegExp regExp = new RegExp(r"^[A-Za-z0-9_]+$");


    if (profileName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty){

      Flushbar(
        messageText:  Text("Fill all Blank Fields", style: TextStyle(color: CupertinoColors.destructiveRed),),
        backgroundColor: Colors.black,
        duration:  Duration(seconds: 1),
      )..show(pageContext);
    }
    else if (regExp.hasMatch(username) == false){

      Flushbar(
          messageText:  Text("Username can only contain any of the following" + "\n" + "A-Z, a-z, 0-9, _", style: TextStyle(color: CupertinoColors.destructiveRed),),
          backgroundColor: Colors.black,
          duration:  Duration(seconds: 2)
      );
    }
    else if (password != confirmPassword){

      Flushbar(
        messageText:  Text("Passwords do not match", style: TextStyle(color: CupertinoColors.destructiveRed),),
        backgroundColor: Colors.black,
        duration:  Duration(seconds: 1),
      )..show(pageContext);

    }
    else{

      BasicUI.showProgressDialog(pageContext: pageContext, child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: <Widget>[
            DogLoaderWidget(),
            SizedBox(height: 50.0,),
            Text("Creating Account in progress...",
              style: TextStyle(
                  color: _themeData.primaryColor,
                  fontSize: Theme.of(pageContext).textTheme.headline6.fontSize,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ));


      _bloc.checkIfUsernameExists(username: username).then((bool usernameExists){

        if (usernameExists){
          Navigator.of(pageContext).pop();

          Flushbar(
            messageText:  Text("Username already Taken", style: TextStyle(color: CupertinoColors.destructiveRed),),
            backgroundColor: Colors.black,
            duration:  Duration(seconds: 3),
          )..show(pageContext);
        }
        else{

          _bloc.createUserWithEmailAndPassword(email: email, password: password).then((AuthResult authResult){

            if (authResult.user != null){

              _bloc.signInUserWithEmailAndPassword(email: authResult.user.email, password: password).then((value){

                if (authResult.user != null){

                  UserModel userModel = UserModel(
                    userId: authResult.user.uid,
                    profileName: profileName,
                    username: username,
                    email: email,
                    password: password,
                    userType: _bloc.getUserType,
                    signupTimestamp: Timestamp.now(),
                  );

                  _bloc.addUserOptimisedProfileData(userId: authResult.user.uid, optimisedUserModel: OptimisedUserModel(profileName: profileName, username: username));

                  _bloc.addUserProfileData(userModel: userModel, userId: authResult.user.uid).then((_){

                    Navigator.pop(pageContext);

                    Flushbar(
                      messageText:  Text("Successfully Created Account", style: TextStyle(color: _themeData.primaryColor)),
                      backgroundColor: Colors.black,
                      duration:  Duration(seconds: 4),
                    )..show(pageContext);

                    Timer(Duration(seconds: 4), (){
                      Navigator.of(pageContext).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
                        return Home();
                      }), (Route<dynamic> route) => false);
                    });
                  }).catchError((e){
                    Navigator.of(pageContext).pop();

                    Flushbar(
                      messageText:  Text("An error occured while saving user data.", style: TextStyle(color: CupertinoColors.destructiveRed),),
                      backgroundColor: Colors.black,
                      duration:  Duration(seconds: 3),
                    )..show(pageContext);
                  });

                }
                else{
                  Navigator.of(pageContext).pop();

                  Flushbar(
                    //title:  "Hey Ninja",
                    messageText:  Text("An error occured", style: TextStyle(color: CupertinoColors.destructiveRed),),
                    backgroundColor: Colors.black,
                    duration:  Duration(seconds: 3),
                  )..show(pageContext);
                }

              }).catchError((e){
                Navigator.of(pageContext).pop();

                Flushbar(
                  messageText:  Text(e.toString(), style: TextStyle(color: CupertinoColors.destructiveRed),),
                  backgroundColor: Colors.black,
                  duration:  Duration(seconds: 3),
                )..show(pageContext);
              });

            }
            else{
              Navigator.of(pageContext).pop();

              Flushbar(
                messageText:  Text("An error occured", style: TextStyle(color: CupertinoColors.destructiveRed),),
                backgroundColor: Colors.black,
                duration:  Duration(seconds: 3),
              )..show(pageContext);
            }


          }).catchError((e){
            Navigator.of(pageContext).pop();

            Flushbar(
              messageText:  Text(e.toString(), style: TextStyle(color: CupertinoColors.destructiveRed),),
              backgroundColor: Colors.black,
              duration:  Duration(seconds: 3),
            )..show(pageContext);
          });
        }

      });


    }

  }


  /*
  Future<void> clearSignupFields({@required BuildContext pageContext}){

    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(pageContext);

    _provider.textEditingSignupNameController.clear();
    _provider.textEditingSignupEmailController.clear();
    _provider.textEditingSignupPasswordController.clear();
    _provider.textEditingSignupConfirmPasswordController.clear();
  }


  Future<void> clearLoginFields({@required BuildContext pageContext}){

    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(pageContext);

    _provider.textEditingLoginEmailController.clear();
    _provider.textEditingLoginPasswordController.clear();
  }

  */




  Future<void> showLoginViewModal({@required BuildContext pageContext}){


    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(pageContext);
    AuthenticationBloc _bloc = _provider.bloc;
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);

    showDialog(
      context: pageContext,
      builder: (BuildContext context){
        return Scaffold(
          backgroundColor: _themeData.primaryColor,
          body: Column(
            children: [

              Flexible(
                flex: 50,
                fit: FlexFit.tight,
                child: Animator<double>(
                  tween: Tween<double>(begin: 0, end: 1.0),
                  curve: Curves.easeInOutBack,
                  duration: Duration(milliseconds: 1000),
                  repeats: 1,
                  builder: (context, animatorState, child ) => Center(
                    child: Transform.scale(
                      scale: animatorState.value,
                      
                      child: FittedBox(
                        child: Column(
                          children: [
                            Image.asset("assets/images/paw_parent_logo.png",
                              width: 250.0,
                              height: 250.0,
                              color: Colors.white,
                              fit: BoxFit.fill,
                            ),
                            Text("An App for dog lovers", style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Flexible(
                flex: 50,
                fit: FlexFit.tight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))
                  ),
                  child: SingleChildScrollView(
                    child: Column(

                      children: <Widget>[

                        SizedBox(height: 40.0,),

                        Center(
                            child: Text("Sign In", style: TextStyle(
                              fontSize: Theme.of(context).textTheme.headline5.fontSize,
                              fontWeight: FontWeight.bold
                            ),)
                        ),
                        SizedBox(height: 20.0,),

                        TextField(
                          controller: _provider.signInEmailTextEditingController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                            fillColor: _themeData.primaryColor.withOpacity(0.2),
                            prefixIcon: Icon(CupertinoIcons.mail_solid, color: _themeData.primaryColor,),
                            hintText: "Email",
                            labelText: "Email",
                            labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                            hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.2)
                            ),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                        SizedBox(height: 10.0,),

                        StreamBuilder<bool>(
                            stream: _bloc.showSignInPasswordBehaviorSubject,
                            builder: (context, snapshot) {
                              return TextField(
                                controller: _provider.signInPasswordTextEditingController,
                                maxLines: 1,
                                obscureText: snapshot.data != null && snapshot.data? false: true,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                                  prefixIcon: Icon(CupertinoIcons.padlock_solid, color: _themeData.primaryColor,),
                                  suffix: GestureDetector(
                                    onTap: (){

                                      if (snapshot.hasData && snapshot.data){
                                        _bloc.showSignInPasswordBehaviorSubject.add(false);
                                      }
                                      else{
                                        _bloc.showSignInPasswordBehaviorSubject.add(true);
                                      }

                                    },
                                    child: snapshot.hasData && snapshot.data? Text("Hide", style: TextStyle(color: _themeData.primaryColor),): Icon(Icons.remove_red_eye, color: Colors.black54,),
                                  ),
                                  hintText: "Password",
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.2)
                                  ),
                                  contentPadding: EdgeInsets.all(10.0),
                                ),
                              );
                            }
                        ),
                        SizedBox(height: 40.0,),

                        SizedBox(
                          width: screenWidth,
                          child: CupertinoButton(
                            color: _themeData.primaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                            onPressed: (){

                              _provider.handlers.loginUser(pageContext: pageContext);
                            },
                            child: Text("Sign In",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Theme.of(context).textTheme.headline6.fontSize
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0,)

                        /*
                        SizedBox(height: 15.0,),

                        Row(
                          children: [
                            Text("Forgot Password",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        */



                      ],
                    ),
                  ),
                )
              )

            ],
          ),
        );
      }
    );

  }







  Future<void> showSignUpViewModal({@required BuildContext pageContext}){


    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(pageContext);
    AuthenticationBloc _bloc = _provider.bloc;
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);

    showDialog(
        context: pageContext,
        builder: (BuildContext context){
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(

                  children: <Widget>[

                    SizedBox(height: 50.0,),

                    Center(
                        child: Text("Create New Account", style: TextStyle(
                            fontSize: Theme.of(context).textTheme.headline5.fontSize,
                            fontWeight: FontWeight.bold
                        ),)
                    ),
                    SizedBox(height: 20.0,),

                    Row(
                      children: [
                        Flexible(
                            flex: 20,
                            fit: FlexFit.tight,
                            child: Text("I'm a: ")
                        ),

                        Flexible(
                          flex: 80,
                          fit: FlexFit.tight,
                          child: StreamBuilder<String>(
                              stream: _bloc.userTypeBehaviorSubject.stream,
                              //initialData: UserType.pet_owner,
                              builder: (context, snapshot) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[

                                    RadioListTile(
                                      title: Text("Pet Owner"),
                                      value: UserType.pet_owner,
                                      groupValue: snapshot.hasData? snapshot.data: null, // boolean experesion to check if stream has received gender type data
                                      activeColor: _themeData.primaryColor,
                                      onChanged: (String userType){
                                        _bloc.userTypeBehaviorSubject.sink.add(userType);
                                      },
                                    ),

                                    RadioListTile(
                                      title: Text("Adoption Center/Shop"),
                                      value: UserType.adoption_center,
                                      groupValue: snapshot.hasData? snapshot.data: null, // boolean experesion to check if stream has received gender type data
                                      activeColor: _themeData.primaryColor,
                                      onChanged: (String userType){
                                        _bloc.userTypeBehaviorSubject.sink.add(userType);
                                      },
                                    ),

                                  ],
                                );
                              }
                          ),
                        )
                      ],
                    ),

                    TextField(
                      controller: _provider.registerProfileNameTextEditingController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                        prefixIcon: Icon(CupertinoIcons.person_solid, color: _themeData.primaryColor,),
                        hintText: "Profile Name",
                        labelText: "Profile Name",
                        labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2)
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),

                    TextField(
                      controller: _provider.registerUsernameTextEditingController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                        prefixIcon: Icon(CupertinoIcons.person_solid, color: _themeData.primaryColor,),
                        hintText: "Username",
                        labelText: "Username",
                        labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2)
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),

                    TextField(
                      controller: _provider.registerEmailTextEditingController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                        prefixIcon: Icon(CupertinoIcons.mail_solid, color: _themeData.primaryColor,),
                        hintText: "Email",
                        labelText: "Email",
                        labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2)
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),

                    StreamBuilder<bool>(
                        stream: _bloc.showRegisterationPasswordBehaviorSubject,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _provider.registerPasswordTextEditingController,
                            maxLines: 1,
                            obscureText: snapshot.data != null && snapshot.data? false: true,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                              prefixIcon: Icon(CupertinoIcons.padlock_solid, color: _themeData.primaryColor,),
                              suffix: GestureDetector(
                                onTap: (){

                                  if (snapshot.hasData && snapshot.data){
                                    _bloc.showRegisterationPasswordBehaviorSubject.add(false);
                                  }
                                  else{
                                    _bloc.showRegisterationPasswordBehaviorSubject.add(true);
                                  }

                                },
                                child: snapshot.hasData && snapshot.data? Text("Hide", style: TextStyle(color: _themeData.primaryColor),): Icon(Icons.remove_red_eye, color: Colors.black54,),
                              ),
                              hintText: "Password",
                              labelText: "Password",
                              labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                          );
                        }
                    ),

                    StreamBuilder<bool>(
                        stream: _bloc.showRegisterationPasswordBehaviorSubject,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _provider.registerConfirmPasswordTextEditingController,
                            maxLines: 1,
                            obscureText: snapshot.data != null && snapshot.data? false: true,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                              prefixIcon: Icon(CupertinoIcons.padlock_solid, color: _themeData.primaryColor,),
                              suffix: GestureDetector(
                                onTap: (){

                                  if (snapshot.hasData && snapshot.data){
                                    _bloc.showRegisterationPasswordBehaviorSubject.add(false);
                                  }
                                  else{
                                    _bloc.showRegisterationPasswordBehaviorSubject.add(true);
                                  }

                                },
                                child: snapshot.hasData && snapshot.data? Text("Hide", style: TextStyle(color: _themeData.primaryColor),): Icon(Icons.remove_red_eye, color: Colors.black54,),
                              ),
                              hintText: "Confirm Password",
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(color: _themeData.primaryColor.withOpacity(1.0)),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                          );
                        }
                    ),
                    SizedBox(height: 15.0,),
                    Row(
                      children: [

                        Flexible(
                          flex: 20,
                          fit: FlexFit.tight,
                          child: StreamBuilder<bool>(
                              stream: _bloc.isTermsAndPolicyAcceptedBehaviorSubject.stream,
                              initialData: false,
                              builder: (context, snapshot) {
                                return Checkbox(
                                  value: snapshot.data,
                                  checkColor: Colors.white,
                                  activeColor: _themeData.primaryColor,
                                  onChanged: (bool checked){
                                    _bloc.isTermsAndPolicyAcceptedBehaviorSubject.sink.add(checked);
                                  },
                                );
                              }
                          ),
                        ),

                        Flexible(
                            flex: 80,
                            fit: FlexFit.tight,
                            child: Text("I agree with the terms of Use and Privacy Policy")
                        )

                      ],
                    ),
                    SizedBox(height: 40.0,),

                    StreamBuilder<bool>(
                        stream: _bloc.isTermsAndPolicyAcceptedBehaviorSubject.stream,
                        builder: (context, snapshot) {

                          return SizedBox(
                            width: screenWidth,
                            child: CupertinoButton(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(30.0),
                              onPressed: snapshot.hasData && snapshot.data? (){

                                _provider.handlers.signupUser(pageContext: pageContext);
                              }: null,
                              child: Text("Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Theme.of(context).textTheme.headline6.fontSize
                                ),
                              ),
                            ),
                          );

                        }
                    ),

                    SizedBox(height: 20.0,),

                  ],
                ),
              ),
            ),
          );
        }
    );

  }

}
