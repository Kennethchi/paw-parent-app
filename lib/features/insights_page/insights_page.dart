import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:paw_parent_app/features/insights_page/insights_page_bloc_provider.dart';
import 'package:paw_parent_app/features/insights_page/insights_page_view.dart';
import 'package:paw_parent_app/res/rgb_colors.dart';

import 'insights_page_bloc.dart';



 class InsightsPage extends StatefulWidget {
   @override
   _InsightsPageState createState() => _InsightsPageState();
 }


 class _InsightsPageState extends State<InsightsPage> {

   InsightsPageBloc _bloc;
   ScrollController insightsFeedScrollController;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = InsightsPageBloc();
    insightsFeedScrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {
     return InsightsPageBlocProvider(
       bloc: _bloc,
       insightsFeedScrollController: insightsFeedScrollController,
       child: Scaffold(
         backgroundColor: RGBColors.light_yellow.withOpacity(0.5),
         body: InsightsPageView(),
       ),
     );
   }
 }
