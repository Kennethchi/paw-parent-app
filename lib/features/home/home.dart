import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/home/Home_views.dart';
import 'package:paw_parent_app/features/home/home_view_handlers.dart';
import 'package:paw_parent_app/features/splash_screen/splash_screen.dart';
import 'package:paw_parent_app/resources/optimised_models/optimised_user_model.dart';
import 'package:paw_parent_app/services/firebase_constants.dart';
import 'package:paw_parent_app/ui/app_animations/app_animations.dart';
import 'home_bloc.dart';
import 'home_bloc_provider.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin, WidgetsBindingObserver {

  HomeBloc _bloc;


  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = HomeBloc();

    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){
      if (firebaseUser == null){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SplashScreen()), (route) => false);
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);




    switch (state) {

      case AppLifecycleState.resumed:

        FirebaseDatabase.instance.goOnline().then((_){

          print("Firebase online");
        }).then((_){

          FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
            if (user != null) {
              FirebaseDatabase.instance.reference().child(
                  RealtimeDatabaseChildNames.users).child(user.uid).child(RealtimeDatabaseChildNames.user_profile).child(
                  OptimisedUserChiledFieldNames.online).set(1);
            }
          });
          print("resumed");
        });

        break;

      case AppLifecycleState.inactive:

        FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
          if (user != null) {
            FirebaseDatabase.instance.reference().child(
                RealtimeDatabaseChildNames.users).child(user.uid).child(RealtimeDatabaseChildNames.user_profile).child(
                OptimisedUserChiledFieldNames.online).set(Timestamp
                .now()
                .millisecondsSinceEpoch);
          }
        });

        print("inactive");
        break;


      case AppLifecycleState.paused:

        FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
          if (user != null) {
            FirebaseDatabase.instance.reference().child(
                RealtimeDatabaseChildNames.users).child(user.uid).child(RealtimeDatabaseChildNames.user_profile).child(
                OptimisedUserChiledFieldNames.online).set(Timestamp
                .now()
                .millisecondsSinceEpoch);
          }
        }).then((_){

          /*
          FirebaseDatabase.instance.goOffline().then((_){

            print("Firebase offline");
          });
          */
        });
        print("paused");
        break;

      case AppLifecycleState.detached:
        FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
          if (user != null) {
            FirebaseDatabase.instance.reference().child(
                RealtimeDatabaseChildNames.users).child(user.uid).child(RealtimeDatabaseChildNames.user_profile).child(
                OptimisedUserChiledFieldNames.online).set(Timestamp
                .now()
                .millisecondsSinceEpoch);
          }
        }).then((_){

        });
        print("suspending");
        break;

    }

  }

  @override
  Widget build(BuildContext context) {


    return HomeBlocProvider(
      bloc: _bloc,
      child: HomeViews(),
    );
  }
}
