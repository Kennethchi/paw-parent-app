import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:paw_parent_app/constants/constants.dart';
import 'package:paw_parent_app/features/authentication/authentication_bloc.dart';
import 'package:paw_parent_app/features/authentication/authentication_bloc_provider.dart';


class AuthenticationViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationMainView();
  }
}


class AuthenticationMainView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(context);
    AuthenticationBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          SizedBox(height: 40.0,),

          Flexible(
            flex: 70,
            fit: FlexFit.tight,
            child: Animator<double>(
              tween: Tween<double>(begin: 0, end: 1.0),
              curve: Curves.easeInOutBack,
              duration: Duration(milliseconds: 1000),
              repeats: 1,
              builder: (context, animatorState, child ) => Center(
                child: Transform.scale(
                  scale: animatorState.value,
                  child: Column(
                    children: [
                      Image.asset("assets/images/paw_parent_logo.png",
                        width: 300.0,
                        height: 300.0,
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
          SizedBox(height: 15.0,),

          Flexible(
            flex: 30,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [

                  InkWell(
                    borderRadius: BorderRadius.circular(30.0),
                    splashColor: _themeData.primaryColor.withOpacity(0.1),
                    highlightColor: _themeData.primaryColor.withOpacity(0.1),
                    onTap: (){

                      _bloc.isLoginViewBehaviorSubject.sink.add(false);

                      _provider.handlers.showLoginViewModal(pageContext: context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Center(
                        child: Text("Sign In",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context).textTheme.headline6.fontSize
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),

                  InkWell(
                    borderRadius: BorderRadius.circular(30.0),
                    splashColor: _themeData.primaryColor.withOpacity(0.1),
                    highlightColor: _themeData.primaryColor.withOpacity(0.1),
                    onTap: (){

                      _bloc.isLoginViewBehaviorSubject.sink.add(false);

                      _provider.handlers.showSignUpViewModal(pageContext: context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Center(
                        child: Text("Sign Up",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Theme.of(context).textTheme.headline6.fontSize
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )


          /*
          StreamBuilder<bool>(
            stream: _bloc.isLoginViewBehaviorSubject.stream,
            initialData: true,
            builder: (context, snapshot) {

              bool isLoginView = snapshot.data;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 50,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              splashColor: _themeData.primaryColor.withOpacity(0.1),
                              highlightColor: _themeData.primaryColor.withOpacity(0.1),
                              onTap: (){

                                _bloc.isLoginViewBehaviorSubject.sink.add(true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: isLoginView? _themeData.primaryColor: Colors.white,
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                child: Center(
                                  child: Text("Log In",
                                    style: TextStyle(
                                        color: isLoginView? Colors.white: _themeData.primaryColor,
                                        fontSize: Theme.of(context).textTheme.headline6.fontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Flexible(
                        flex: 50,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              splashColor: _themeData.primaryColor.withOpacity(0.1),
                              highlightColor: _themeData.primaryColor.withOpacity(0.1),
                              onTap: (){

                                _bloc.isLoginViewBehaviorSubject.sink.add(false);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: isLoginView? Colors.white: _themeData.primaryColor,
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                child: Center(
                                  child: Text("Sign Up",
                                    style: TextStyle(
                                        color: isLoginView? _themeData.primaryColor: Colors.white,
                                        fontSize: Theme.of(context).textTheme.headline6.fontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 65.0),
                    child: isLoginView
                        ? Container(
                      child: SignInView(),
                    )
                        : Container(
                      child: SignUpView(),
                    ),
                  )

                ],


              );
            }
          ),
          */



        ],
      ),
    );
  }
}





/*
class SignInView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(context);
    AuthenticationBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;



    return SingleChildScrollView(
      child: Column(

        children: <Widget>[

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
          SizedBox(height: 40.0,),

          OutlineButton(
            borderSide: BorderSide(color: _themeData.primaryColor, width: 3.0, style: BorderStyle.solid),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            highlightedBorderColor: _themeData.primaryColor.withOpacity(0.2),
            splashColor: _themeData.primaryColor.withOpacity(0.1),
            highlightColor: _themeData.primaryColor.withOpacity(0.1),
            onPressed: (){

              _provider.handlers.loginUser(pageContext: context);
            },
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Text("Log In"),
          ),


        ],
      ),
    );
  }
}








class SignUpView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    AuthenticationBlocProvider _provider = AuthenticationBlocProvider.of(context);
    AuthenticationBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;



    return Column(

      children: <Widget>[

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
        SizedBox(height: 10.0,),
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
        SizedBox(height: 20.0,),

        StreamBuilder<bool>(
          stream: _bloc.isTermsAndPolicyAcceptedBehaviorSubject.stream,
          builder: (context, snapshot) {
            return OutlineButton(
              borderSide: BorderSide(color: _themeData.primaryColor, width: 3.0, style: BorderStyle.solid),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              highlightedBorderColor: _themeData.primaryColor.withOpacity(0.2),
              splashColor: _themeData.primaryColor.withOpacity(0.1),
              highlightColor: _themeData.primaryColor.withOpacity(0.1),
              onPressed: snapshot.hasData && snapshot.data? (){

                _provider.handlers.signupUser(pageContext: context);
              }: null,
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Text("Sign Up")
            );
          }
        ),

        SizedBox(height: 20.0,),
      ],
    );
  }
}

*/




