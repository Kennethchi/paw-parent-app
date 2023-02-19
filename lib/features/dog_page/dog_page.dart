import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paw_parent_app/features/dog_page/dog_page_bloc.dart';
import 'package:paw_parent_app/features/dog_page/dog_page_bloc_provider.dart';
import 'package:paw_parent_app/features/dog_page/dog_page_view.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';
import 'package:paw_parent_app/resources/models/dog_model.dart';
import 'package:paw_parent_app/resources/models/user_model.dart';






class DogPage extends StatefulWidget {

  UserModel ownerUserModel;
  DogModel dogModel;

  DogPage({@required this.ownerUserModel, @required this.dogModel});

  @override
  _DogPageState createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {

  DogPageBloc _bloc;
  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = DogPageBloc(ownerUserModel: widget.ownerUserModel, dogModel: widget.dogModel);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    scrollController = ScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DogPageBlocProvider(
      bloc: _bloc,
      scrollController: scrollController,
      child: Scaffold(
        body: DogPageView()
      ),
    );
  }
}
