import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_bloc.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_bloc_provider.dart';
import 'package:paw_parent_app/features/profile_settings/profile_settings_view.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';



class ProfileSettings extends StatefulWidget {

  dynamic dynamicProfileBloc;

  ProfileSettings({@required this.dynamicProfileBloc});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  ProfileSettingsBloc _bloc;
  TextEditingController profileNameTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = ProfileSettingsBloc();
    profileNameTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    profileNameTextEditingController.removeListener(() { });
    profileNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSettingsBlocProvider(
      bloc: _bloc,
      profileNameTextEditingController: profileNameTextEditingController,
      dynamicProfileBloc: widget.dynamicProfileBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: CupertinoTheme.of(context).primaryColor,),
          ),
          title: Text("Account Settings", style: TextStyle(color: Colors.black87),),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: ProfileSettingsView(),
      ),
    );
  }
}
