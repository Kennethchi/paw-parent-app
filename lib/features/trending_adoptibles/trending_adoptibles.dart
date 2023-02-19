import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/trending_adoptibles/trending_adoptibles_bloc.dart';
import 'package:paw_parent_app/features/trending_adoptibles/trending_adoptibles_bloc_provider.dart';
import 'package:paw_parent_app/features/trending_adoptibles/trending_adoptibles_views.dart';


class TrendingAdoptibles extends StatefulWidget {
  @override
  _TrendingAdoptiblesState createState() => _TrendingAdoptiblesState();
}

class _TrendingAdoptiblesState extends State<TrendingAdoptibles> {

  TrendingAdoptiblesBloc _bloc;
  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = TrendingAdoptiblesBloc();
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
    return TrendingAdoptiblesBlocProvider(
      bloc: _bloc,
      scrollController: scrollController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Trending Adoptibles", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
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
        body: TrendingAdoptiblesView(),
      ),
    );
  }

}
