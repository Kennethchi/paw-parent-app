
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paw_parent_app/features/dog_page_creation/dog_page_creation_view.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';
import 'dog_page_creation_bloc.dart';
import 'dog_page_creation_bloc_provider.dart';



class DogPageCreation extends StatefulWidget {

  dynamic dynamicBloc;
  UserModel currentUserModel;

  DogPageCreation({@required this.dynamicBloc, @required this.currentUserModel });

  @override
  _DogPageCreationState createState() => _DogPageCreationState();
}

class _DogPageCreationState extends State<DogPageCreation> {

  DogPageCreationBloc _bloc;

  TextEditingController dogProfileNameTextEditingController;
  TextEditingController dogUsernameTextEditingController;
  TextEditingController dogAboutTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = DogPageCreationBloc(currentUserModel: widget.currentUserModel);

    dogProfileNameTextEditingController = TextEditingController();
    dogUsernameTextEditingController = TextEditingController();
    dogAboutTextEditingController = TextEditingController();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    dogProfileNameTextEditingController?.dispose();
    dogUsernameTextEditingController?.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return DogPageCreationBlocProvider(
      bloc: _bloc,
      dynamicBloc: widget.dynamicBloc,
      dogProfileNameTextEditingController: this.dogProfileNameTextEditingController,
      dogUsernameTextEditingController: this.dogUsernameTextEditingController,
      dogAboutTextEditingController: this.dogAboutTextEditingController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Text("Create Dog Page", style: TextStyle(
              color: CupertinoTheme.of(context).primaryColor
            ),),
          ),
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: CupertinoTheme.of(context).primaryColor
              ,),
          ),
          elevation: 0.0,
        ),

        body: DogPageCreationView(),
      ),
    );
  }
}
