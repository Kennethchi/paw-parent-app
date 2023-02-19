





import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_bloc.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_view_handlers.dart';

class ProfileSettingsBlocProvider extends InheritedWidget{

  final ProfileSettingsBloc bloc;
  final Key key;
  final Widget child;

  ProfileSettingsViewHandlers handlers;

  TextEditingController profileNameTextEditingController;

  dynamic dynamicProfileBloc;

  ProfileSettingsBlocProvider({
    @required this.dynamicProfileBloc,
    @required this.profileNameTextEditingController,
    @required this.bloc, this.key, this.child}): super(key: key, child: child) {

    handlers = ProfileSettingsViewHandlers();

    profileNameTextEditingController.addListener(() {
      if (profileNameTextEditingController.text.trim().isNotEmpty){
        bloc.showUpdateProfileNameButtonBehaviorSubject.add(true);
      }
      else{
        bloc.showUpdateProfileNameButtonBehaviorSubject.add(false);
      }
    });
  }

  static ProfileSettingsBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(ProfileSettingsBlocProvider) as ProfileSettingsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}