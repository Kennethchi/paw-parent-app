

import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/authentication/authentication_bloc.dart';
import 'package:paw_parent_app/features/authentication/authentication_views_handlers.dart';

class AuthenticationBlocProvider extends InheritedWidget{

  final AuthenticationBloc bloc;
  final Key key;
  final Widget child;

  AuthenticationViewHandlers handlers;

  TextEditingController signInEmailTextEditingController;
  TextEditingController signInPasswordTextEditingController;

  TextEditingController registerProfileNameTextEditingController;
  TextEditingController registerUsernameTextEditingController;
  TextEditingController registerEmailTextEditingController;
  TextEditingController registerPasswordTextEditingController;
  TextEditingController registerConfirmPasswordTextEditingController;

  AuthenticationBlocProvider({
    @required this.signInEmailTextEditingController,
    @required this.signInPasswordTextEditingController,

    @required this.registerProfileNameTextEditingController,
    @required this.registerUsernameTextEditingController,
    @required this.registerEmailTextEditingController,
    @required this.registerPasswordTextEditingController,
    @required this.registerConfirmPasswordTextEditingController,

    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = AuthenticationViewHandlers();
  }

  static AuthenticationBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(AuthenticationBlocProvider) as AuthenticationBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}