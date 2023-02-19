import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/features/insights_page_feature/popular_insights_tag/popular_insights_tag_bloc_provider.dart';
import 'package:paw_parent_app/features/insights_page_feature/popular_insights_tag/popular_insights_tag_view.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';

import 'popular_insights_tag_bloc.dart';



class PopularInsightsTag extends StatefulWidget {

  String tag;

  PopularInsightsTag({@required this.tag});

  @override
  _PopularInsightsTagState createState() => _PopularInsightsTagState();
}


class _PopularInsightsTagState extends State<PopularInsightsTag> {

  PopularInsightsTagBloc _bloc;
  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = PopularInsightsTagBloc(tag: widget.tag);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return PopularInsightsTagBlocProvider(
      bloc: _bloc,
      scrollController: scrollController,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: RGBColors.cream_light_brown.withOpacity(0.5),
          title: Text("${widget.tag}", style: TextStyle(
            fontSize: Theme.of(context).textTheme.headline5.fontSize,
            color: Colors.black54
          ),),
          leading: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black54,)),
          elevation: 0.0,
        ),
        body: PopularInsightsTagView(),
      ),
    );
  }

}

