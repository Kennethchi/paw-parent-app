import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paw_parent_app/features/profile/profile_bloc.dart';
import 'package:paw_parent_app/features/profile/profile_bloc_provider.dart';
import 'package:paw_parent_app/features/profile/profile_views.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';


class Profile extends StatefulWidget {

  UserModel profileUserModel;

  Profile({@required this.profileUserModel});


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  ProfileBloc _bloc;

  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController = ScrollController();

    _bloc = ProfileBloc(profileUserModel: widget.profileUserModel);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBlocProvider(
      bloc: _bloc,
      scrollController: scrollController,
      child: Scaffold(

        body: ProfileViews(),
      ),
    );
  }
}
