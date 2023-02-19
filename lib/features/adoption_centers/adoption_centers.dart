import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/adoption_centers/adoption_centers_bloc.dart';
import 'package:paw_parent_app/features/adoption_centers/adoption_centers_bloc_provider.dart';
import 'package:paw_parent_app/features/adoption_centers/adoption_centers_view.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';


class AdoptionCenters extends StatefulWidget {
  @override
  _AdoptionCentersState createState() => _AdoptionCentersState();
}

class _AdoptionCentersState extends State<AdoptionCenters> {

  AdoptionCentersBloc _bloc;
  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = AdoptionCentersBloc();
    scrollController = ScrollController();
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

    return AdoptionCentersBlocProvider(
      bloc: _bloc,
      scrollController: scrollController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Adoption Centers", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black54,),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: AdoptionCentersView(),
      ),
    );

  }

}
