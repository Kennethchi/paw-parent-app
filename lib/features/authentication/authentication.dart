import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/authentication/authentication_bloc.dart';
import 'package:paw_parent_app/features/authentication/authentication_bloc_provider.dart';
import 'package:paw_parent_app/features/authentication/authentication_views.dart';



class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  AuthenticationBloc bloc;

  TextEditingController signInEmailTextEditingController;
  TextEditingController signInPasswordTextEditingController;

  TextEditingController registerProfileNameTextEditingController;
  TextEditingController registerUsernameTextEditingController;
  TextEditingController registerEmailTextEditingController;
  TextEditingController registerPasswordTextEditingController;
  TextEditingController registerConfirmPasswordTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = AuthenticationBloc();
    
    signInEmailTextEditingController = TextEditingController();
    signInPasswordTextEditingController = TextEditingController();
    
    registerProfileNameTextEditingController = TextEditingController();
    registerUsernameTextEditingController = TextEditingController();
    registerEmailTextEditingController = TextEditingController();
    registerPasswordTextEditingController = TextEditingController();
    registerConfirmPasswordTextEditingController = TextEditingController();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.dispose();
    
    signInEmailTextEditingController.dispose();
    signInPasswordTextEditingController.dispose();
    
    registerProfileNameTextEditingController.dispose();
    registerUsernameTextEditingController.dispose();
    registerEmailTextEditingController.dispose();
    registerEmailTextEditingController.dispose();
    registerConfirmPasswordTextEditingController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return AuthenticationBlocProvider(
      signInEmailTextEditingController: this.signInEmailTextEditingController,
      signInPasswordTextEditingController: this.signInPasswordTextEditingController,
      registerProfileNameTextEditingController: this.registerProfileNameTextEditingController,
      registerUsernameTextEditingController:  this.registerUsernameTextEditingController,
      registerEmailTextEditingController: this.registerEmailTextEditingController,
      registerPasswordTextEditingController: this.registerPasswordTextEditingController,
      registerConfirmPasswordTextEditingController: this.registerConfirmPasswordTextEditingController,

      bloc: bloc,
      child: Scaffold(
        backgroundColor: CupertinoTheme.of(context).primaryColor,
        body: AuthenticationViews(),
      ),
    );
  }
}
